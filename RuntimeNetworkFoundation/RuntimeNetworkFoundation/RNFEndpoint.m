//
//  RNFEndpoint.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 09/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "RNFEndpoint.h"
#import "RNFOperationQueue.h"
#import "RNFResponseDeserializer.h"
#import "RNFOperation.h"
#import "RNFCacheHandler.h"
#import "RNFConfigurationLoader.h"
#import "RNFLogger.h"
#import "RNFEndpointConfiguration.h"
#import "RNFConfigurationNotFound.h"
#import "RNFPlistConfigurationLoader.h"

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

- (id) forwardingTargetForSelector:(SEL)aSelector
{
    NSString *selectorAsString = NSStringFromSelector(aSelector);
    
    if(!self.configuration)
    {
        [self loadConfigurationForConfigurator:self.configurator];
    }
    
    NSArray *operations = [self.configuration operations];
    
    if(![operations containsObject:selectorAsString])
        return nil;
    
    
    //3. Create a IMP block with the following steps:
    
        //1. Create the RNFOperation with the given configuration
    
        //2. If the cacheHandler has a cached response already, start calling the given completion block
    
        //3. Serialize the parameters based on the configuration
    
        //4. Enqueue the RNFOperation in the RNFOperationQueue
    
        //5. Setup the completion block.
        //5.1 If error is not nil, call the given completion block
        //5.2 If error is nil, deserialize the response with the responseDeserializer
        //5.3 If the RNFOperation has a dataDeserializer, deserialize the response
        //5.4 Call the given completion block
        //5.5 Eventually cache the response with the cacheHandler
    
    //4. Add the IMP block as an instance selector to the self class
    
    //5. Return self
    return self;
}

@end
