//
//  RNFEndpoint.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 09/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "RNFEndpoint.h"
#import "RNF.h"
#import "RNFPlistConfigurationLoader.h"
#import "RNFParametersParser.h"

#import <objc/runtime.h>

static NSString * const kRNFParsedRuntimeArguments = @"arguments";
static NSString * const kRNFParsedRuntimeCompletionBlock = @"completion";

@interface RNFEndpoint ()

@property (nonatomic, strong) id<RNFConfigurationLoader> configurator;

//Operation handling
@property (nonatomic, strong) NSArray *operations;
@property (nonatomic, strong) id<RNFOperationQueue> networkQueue;

//Caching module
@property (nonatomic, strong) id<RNFCacheHandler> cacheHandler;

//Attributes
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSURL *baseURL;
@property (nonatomic, strong) id<RNFEndpointConfiguration> configuration;

//Attached behaviors
@property (nonatomic, strong) id<RNFLogger> logger;

@end

@implementation RNFEndpoint
{
    BOOL _configurationLoaded;
}

#pragma mark - Initializers

- (id) initWithConfigurator:(id<RNFConfigurationLoader>)configurator
{
    self = [self init];
    
    _configurator = configurator;
    
    return self;
}

- (id) initWithName:(NSString *)name
{
    id<RNFConfigurationLoader> configurationLoader = [[RNFPlistConfigurationLoader alloc] initWithPlistName:name];
    
    self = [self initWithConfigurator:configurationLoader];
    
    //Eagerly load the configuration
    [self loadConfigurationForConfigurator:configurationLoader];
    
    _name = name;
    
    return self;
}

- (id) init
{
    return [super init];
}

#pragma mark - Configuration loading

- (void) loadConfigurationForConfigurator:(id<RNFConfigurationLoader>)configurator
{
    @synchronized(self)
    {
        if(_configurationLoaded)
            return;
        
        if ([configurator respondsToSelector:@selector(load)])
        {
            [configurator load];
        }
        
        _configurationLoaded = YES;
        
        id<RNFEndpointConfiguration> config = [configurator endpointAttributes];
        
        self.name = [config name];
        self.baseURL = [config baseURL];
        
        Class operationQueueClass = [config operationQueueClass];
        if(operationQueueClass)
            self.networkQueue = [operationQueueClass new];
        
        Class cacheHandler = [config cacheClass];
        if(cacheHandler)
            self.cacheHandler = [cacheHandler new];
        
        Class loggerClass = [config logger];
        if (loggerClass)
            self.logger = [loggerClass new];
        
        self.configuration = config;
    }
}

#pragma mark - dynamic getters

- (NSURL *) baseURL
{
    if(!_configuration)
        [self loadConfigurationForConfigurator:self.configurator];
    
    return _baseURL;
}

#pragma mark - Convenience methods

- (id<RNFOperation>) operationWithName:(NSString *)name
{
    return [self.operations objectPassingTest:^BOOL(id<RNFOperation> operation) {
        return [[operation name] isEqualToString:name];
    }];
}

#pragma mark - Runtime machinery

- (void) forwardInvocation:(NSInvocation *)anInvocation
{
    [anInvocation invoke];
}

- (id) forwardingTargetForSelector:(SEL)aSelector
{
    NSString *selectorAsString = NSStringFromSelector(aSelector);
    
    if(!self.configuration)
    {
        [self loadConfigurationForConfigurator:self.configurator];
    }
    
    NSArray *operations = [self.configuration operations];
    
	int i=0;
	BOOL found = NO;
	for (id<RNFOperationConfiguration> operation in operations)
    {
		if ([[operation name] isEqualToString:selectorAsString]) {
			found = YES;
			break;
		} else
			i++;
	}
	
	if(!found)
		return self;

	id<RNFOperationConfiguration> operationConfiguration = [operations objectAtIndex:i];
	NSUInteger argsCount = [NSMethodSignature numberOfArgumentsForSelector:aSelector];
    
    class_replaceMethod([self class], aSelector, imp_implementationWithBlock(^id<RNFOperation>(RNFEndpoint *endpointSelf, ...){
    	NSDictionary *parsedRuntimeMethodName = ({
            NSMutableDictionary *parsedResult = [NSMutableDictionary new];
            va_list args;
            va_start(args, endpointSelf);
            
            NSMutableArray *argsArray = [NSMutableArray new];
            
            id arg;
            RNFCompletionBlockComplete completion;
            for(int i=0; i<argsCount; i++)
            {
                arg = va_arg(args, id);
                [argsArray addObject:arg];
                
                if ([arg isKindOfClass:NSClassFromString(@"NSBlock")]) {
                    completion = arg;
                }
            }
            
            va_end(args);
            
            parsedResult[kRNFParsedRuntimeArguments] = argsArray;
            parsedResult[kRNFParsedRuntimeCompletionBlock] = completion;
            parsedResult;
        });
        
        RNFCompletionBlockComplete completion = parsedRuntimeMethodName[kRNFParsedRuntimeCompletionBlock];
    	
        NSString *urlString = [NSString stringWithFormat:@"%@/%@",
                               [self baseURL].absoluteString,
                               [operationConfiguration URL]];
        NSURL *operationURL = [NSURL URLWithString:[[RNFParametersParser new] parseString:urlString withArguments:parsedRuntimeMethodName[kRNFParsedRuntimeArguments]]];
        Class operationClass = [operationConfiguration operationClass];
        id<RNFOperation> operation = [[operationClass alloc] initWithURL:operationURL method:[operationConfiguration HTTPMethod]];
		
        [operation setHeaders:[operationConfiguration headers]];
        [operation setBody:[operationConfiguration HTTPBody]];
        
        //3. If the cacheHandler has a cached response already, start calling the given completion block
        
        //4. Enqueue the RNFOperation in the RNFOperationQueue
		//[self.networkQueue enqueueOperation:operation];
        
        [operation startWithCompletionBlock:^(id response, id<RNFOperation> operation, NSUInteger statusCode, BOOL cached) {
            id<RNFResponseDeserializer> deserializer = [self.configuration deserializer];
            id deserializedResponse = deserializer ? [deserializer deserializeResponse:response] : response;
        
            /*
            //TODO Data deserialization
            id<RNFDataDeserializer> dataDeserializer = [operationConfiguration dataDeserializer];
            id deserializedObject = dataDeserializer ? [dataDeserializer deserializeData:deserializedResponse
                                                                            usingMapping:nil
                                                                              transforms:nil
                                                                               intoClass:nil];
            */
            
            if(completion)
				completion(deserializedResponse, operation, statusCode, cached);
		} errorBlock:^(id response, NSError *error, NSUInteger statusCode) {
			NSLog(@"Something went wrong: %@",error);
		}];
        
        if([operationConfiguration cacheResults])
            ; //TODO cache the response with the cacheHandler
        
        return operation;
    }), [NSMethodSignature methodSignatureForMethodWithArguments:argsCount]);
    
    return self;
}

@end
