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
#import "RNFConfiguration.h"
#import "RNFConfigurationNotFound.h"
#import "RNFPlistConfigurationLoader.h"

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
@property (nonatomic, strong) id<RNFConfiguration> configuration;

//Attached behaviors
@property (nonatomic, weak) id<RNFLogger> logger;

@end

@implementation RNFEndpoint

#pragma mark - Initializers

- (id) initWithConfigurator:(id<RNFConfigurationLoader>)configurator
{
    return [self init];
}

- (id) initWithName:(NSString *)name
{
    self = [self init];
    
    _name = name;
    
    //Eagerly load the configuration
    id<RNFConfigurationLoader> configurationLoader = [[RNFPlistConfigurationLoader alloc] initWithPlistName:name];
    _configurator = configurationLoader;
    _configuration = [configurationLoader endpointAttributes];
    
    if(!_configuration)
        @throw [[RNFConfigurationNotFound alloc] initWithName:NSStringFromClass([RNFConfigurationNotFound class])
                                                       reason: [NSString stringWithFormat:NSLocalizedString(@"No plist configuration has been found for plist file with name %@", @""), name]
                                                     userInfo:nil];
    
    [self loadConfigurationForConfigurator:_configurator];
    
    return self;
}

- (id) init
{
    return [super init];
}

- (void) loadConfigurationForConfigurator:(id<RNFConfigurationLoader>)configurator
{
    id<RNFConfiguration> config = [configurator endpointAttributes];
    
    if([config respondsToSelector:@selector(name)])
        self.name = [config name];
    
    self.baseURL = [config baseURL];
    
    //TODO Load the other attributes...
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

+ (BOOL) resolveInstanceMethod:(SEL)sel
{
    //1. Do we have a cached configuration already? If yes, get the name from there
    //1.1 If not, try to load the configuration
    //1.1.1 If loading fails, return NO
    //1.1.2 Cache the configuration
    
    //2. If the configuration doesn't contain the method, return NO
    
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
    
    //5. Return YES
    return YES;
}

@end
