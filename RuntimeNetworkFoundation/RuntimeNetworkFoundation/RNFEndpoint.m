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
#import "RNFBaseOperation.h"

#import <objc/runtime.h>

@interface RNFEndpoint ()

//Extension points
@property (nonatomic, strong) Class<RNFOperation> operationClass;
@property (nonatomic, strong) id<RNFResponseDeserializer> responseDeserializer;
@property (nonatomic, strong) id<RNFConfigurationLoader> configurator;

//Operation handling
@property (nonatomic, strong) NSArray *operations;
@property (nonatomic, strong) id<RNFOperationQueue> networkQueue;

//Caching module
@property (nonatomic, strong) id<RNFCacheHandler> cacheHandler;
@property (nonatomic, assign) BOOL cacheResults;

//Attributes
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSURL *baseURL;
@property (nonatomic, strong) NSDictionary *headers;
@property (nonatomic, strong) id<RNFEndpointConfiguration> configuration;

//Attached behaviors
@property (nonatomic, weak) id<RNFLogger> logger;

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
        
        //TODO Load the other attributes...
        
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
    for (id<RNFOperation> operation in self.operations)
    {
        if([[operation name] isEqualToString:name])
            return operation;
    }
    
    return nil;
}

#pragma mark - Runtime machinery

- (const char *) methodSignatureForMethodWithArguments:(NSUInteger)argsCount
{
	NSMutableString *buildingSignature = [[NSMutableString alloc] initWithString:@"v@:"];
	
	for (int i=0; i<argsCount; i++)
	{
		[buildingSignature appendString:@"@"];
	}
		
	return [buildingSignature UTF8String];
}

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
	for (NSDictionary *operation in operations) {
		if ([[operation objectForKey:@"runtimeMethod"] isEqualToString:selectorAsString]) {
			found = YES;
			break;
		} else
			i++;
	}
	
	if(!found)
		return self;

	NSDictionary *operationConfiguration = [operations objectAtIndex:i];
	NSUInteger argsCount = [[selectorAsString componentsSeparatedByString:@":"] count] - 1;
    
    class_replaceMethod([self class], aSelector, imp_implementationWithBlock(^(RNFEndpoint *endpointSelf, ...){
        //1. Create the RNFOperation with the given configuration
		NSURL *operationURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[self baseURL].absoluteString,operationConfiguration[@"URL"]]];
		
		NSLog(@"URL to call: %@",operationURL);
		
        RNFBaseOperation *operation = [[RNFBaseOperation alloc] initWithURL:operationURL method:@"GET"];
		
        //2. If the cacheHandler has a cached response already, start calling the given completion block
        //3. Serialize the parameters based on the configuration
        //4. Enqueue the RNFOperation in the RNFOperationQueue
        //5.0 Search the completion block
        va_list args;
        va_start(args, endpointSelf);
        
        id arg;
		RNFCompletionBlock completion;
		for(int i=0; i<argsCount; i++)
		{
            arg = va_arg(args, id);
            NSLog(@"arg: %@",arg);
            
            if ([arg isKindOfClass:NSClassFromString(@"NSBlock")]) {
                NSLog(@"FOUND BLOCK");
				completion = arg;
            }
        }
		
        va_end(args);
        
        //5. Setup the completion block.
		[operation startWithCompletionBlock:^(id response, id<RNFOperation> operation, NSUInteger statusCode, BOOL cached) {
			if(completion)
				completion(response, operation, statusCode, cached);
		} errorBlock:^(id response, NSError *error, NSUInteger statusCode) {
			NSLog(@"Something went wrong: %@",error);
		}];
        //5.1 If error is not nil, call the given completion block
        //5.2 If error is nil, deserialize the response with the responseDeserializer
        //5.3 If the RNFOperation has a dataDeserializer, deserialize the response
        //5.4 Call the given completion block
        //5.5 Eventually cache the response with the cacheHandler
    }), [self methodSignatureForMethodWithArguments:argsCount]);
    
    return self;
}

@end
