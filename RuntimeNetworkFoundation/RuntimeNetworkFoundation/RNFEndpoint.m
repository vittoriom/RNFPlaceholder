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
#import "RNFUnifiedConfiguration.h"
#import "RNFResponseValidator.h"

#import <objc/runtime.h>

static NSString * const kRNFParsedRuntimeArguments = @"arguments";
static NSString * const kRNFParsedRuntimeCompletionBlock = @"completion";

@interface RNFEndpoint ()

@property (nonatomic, strong) id<RNFConfigurationLoader> configurator;

//Operation handling

- (NSArray *) operations;

@property (nonatomic, strong) id<RNFOperationQueue> networkQueue;

//Caching module
@property (nonatomic, strong) id<RNFCacheHandler> cacheHandler;

//Attributes
@property (nonatomic, strong) NSString *name;

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
    
    self.name = name;
    
    return self;
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
        
        Class operationQueueClass = [config operationQueueClass];
        if(operationQueueClass)
            self.networkQueue = [operationQueueClass new];
        
        Class cacheHandler = [config cacheClass];
        if(cacheHandler)
        {
            if ([cacheHandler respondsToSelector:@selector(cacheHandlerForEndpoint:)])
                self.cacheHandler = [cacheHandler cacheHandlerForEndpoint:self];
            else
                self.cacheHandler = [cacheHandler new];
        }
        
        Class loggerClass = [config logger];
        if (loggerClass)
        {
            if([loggerClass respondsToSelector:@selector(loggerForEndpoint:)])
               self.logger = [loggerClass loggerForEndpoint:self];
            else
               self.logger = [loggerClass new];
        }

        self.configuration = config;
    }
}

#pragma mark - dynamic getters

- (NSURL *) baseURL
{
    if(!_configuration)
        [self loadConfigurationForConfigurator:self.configurator];
    
    return [self.configuration baseURL];
}

- (NSString *) endpointName
{
    return self.name;
}

- (NSArray *) operations
{
    return [self.configuration operations];
}

#pragma mark - Convenience methods

- (id<RNFOperation>) operationWithName:(NSString *)name
{
    NSArray *operationsArray = [self operations];
    return [operationsArray objectPassingTest:^BOOL(id<RNFOperationConfiguration> operation) {
        return [[operation name] isEqualToString:name];
    }];
}

- (NSInteger) indexOfOperationWithName:(NSString *)name inArray:(NSArray *)operations
{
    return [operations indexOfObjectPassingTest:^BOOL(id<RNFOperationConfiguration> operation, NSUInteger idx, BOOL *stop) {
        return [[operation name] isEqualToString:name];
    }];
}

- (void) handleResponse:(NSData *)response
           forOperation:(id<RNFOperation>)operation
         withStatusCode:(NSInteger)statusCode
                 cached:(BOOL)cached
     usingConfiguration:(RNFUnifiedConfiguration *)unifiedConfiguration
    withCompletionBlock:(RNFCompletionBlockComplete)completion
           failureBlock:(RNFErrorBlock)errorBlock
{
    Class deserializer = [unifiedConfiguration responseDeserializer];
    id deserializedResponse = deserializer ? [[deserializer new] deserializeResponse:response] : response;
    
    //Response is valid?
    Class validatorClass = [unifiedConfiguration responseValidator];
    id<RNFResponseValidator> validator = validatorClass ? [validatorClass new] : nil;
    NSError *responseError = validator ? [validator responseIsValid:deserializedResponse forOperation:operation withStatusCode:statusCode] : nil;
    
    if(responseError)
    {
        errorBlock(deserializedResponse, responseError,statusCode);
        return;
    }
    
    id<RNFDataDeserializer> dataDeserializer = [unifiedConfiguration dataDeserializer];
    deserializedResponse = dataDeserializer ? [dataDeserializer deserializeData:deserializedResponse
                                                                   usingMapping:[dataDeserializer mappings]
                                                                     transforms:[dataDeserializer transforms]
                                                                      intoClass:[dataDeserializer targetClass]] : deserializedResponse;
    
    if(completion)
        completion(deserializedResponse, operation, statusCode, cached);
    
    if(!cached && [unifiedConfiguration cacheResults])
        [self.cacheHandler cacheObject:response withKey:[operation uniqueIdentifier] withCost:[response length]];
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

	NSInteger indexOfOperation = [self indexOfOperationWithName:selectorAsString inArray:operations];
    
	if(indexOfOperation == NSNotFound)
		return self;

	id<RNFOperationConfiguration> operationConfiguration = [operations objectAtIndex:indexOfOperation];
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
            
            if(completion)
                parsedResult[kRNFParsedRuntimeCompletionBlock] = completion;
            parsedResult;
        });
        
        RNFCompletionBlockComplete completion = parsedRuntimeMethodName[kRNFParsedRuntimeCompletionBlock];
    	RNFUnifiedConfiguration *unifiedConfiguration = [[RNFUnifiedConfiguration alloc] initWithEndpointConfiguration:self.configuration operationConfiguration:operationConfiguration];
        
        NSString *urlString = [unifiedConfiguration URL];
        urlString = [urlString URLStringByAppendingQueryStringParameters:[unifiedConfiguration queryStringParameters]];
        
        NSURL *operationURL = [NSURL URLWithString:[[RNFParametersParser new] parseString:urlString withArguments:parsedRuntimeMethodName[kRNFParsedRuntimeArguments]]];
        
        Class operationClass = [unifiedConfiguration operationClass];
        id<RNFOperation> operation = [[operationClass alloc] initWithURL:operationURL
                                                                  method:[unifiedConfiguration HTTPMethod]
                                                                 headers:[unifiedConfiguration headers]
                                                                    body:[unifiedConfiguration HTTPBody]];
        
        id cachedData = nil;
        if ([[unifiedConfiguration HTTPMethod] isEqualToString:@"GET"])
            cachedData = [self.cacheHandler cachedObjectWithKey:[operation uniqueIdentifier]];
        
        if (cachedData)
        {
            [self handleResponse:cachedData
                    forOperation:operation
                  withStatusCode:200
                          cached:YES
              usingConfiguration:unifiedConfiguration
             withCompletionBlock:completion
                    failureBlock:nil];
        }
        
        [operation setCompletionBlock:^(id response, id<RNFOperation> operation, NSUInteger statusCode, BOOL cached) {
            [self handleResponse:response
                    forOperation:operation
                  withStatusCode:statusCode
                          cached:NO
              usingConfiguration:unifiedConfiguration
             withCompletionBlock:completion
                    failureBlock:nil];
		} errorBlock:^(id response, NSError *error, NSUInteger statusCode) {
			NSLog(@"Something went wrong: %@",error);
		}];
        
        [self.networkQueue enqueueOperation:operation];
        
        return operation;
    }), [NSMethodSignature methodSignatureForMethodWithArguments:argsCount]);
    
    return self;
}

@end
