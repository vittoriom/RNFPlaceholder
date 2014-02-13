//
//  RNFDictionaryConfiguration.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 10/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "RNFDictionaryEndpointConfiguration.h"
#import "RNFMalformedConfiguration.h"
#import "RNFDictionaryOperationConfiguration.h"

@interface RNFDictionaryEndpointConfiguration ()

@property (nonatomic, strong) NSMutableDictionary *internalDictionary;
@property (nonatomic, strong) id<RNFResponseDeserializer> cachedDeserializer;
@property (nonatomic, strong) id<RNFLogger> cachedLogger;

@end

@implementation RNFDictionaryEndpointConfiguration

#pragma mark - Initializers

- (instancetype) initWithDictionary:(NSDictionary *)dictionary
{
    self = [self init];
    
    _internalDictionary = [dictionary mutableCopy];
    
    [self performSanityCheckOnDictionary:dictionary];
    
    return self;
}

#pragma mark - Sanity checks

- (void) performSanityCheckOnDictionary:(NSDictionary *)dictionary
{
    NSString *errorMessage = nil;
    
    if (![dictionary objectForKey:kRNFConfigurationEndpointBaseURL])
    {
        errorMessage = [NSString stringWithFormat:@"No %@ is configured for the endpoint", kRNFConfigurationEndpointBaseURL];
    } else if(![dictionary objectForKey:kRNFConfigurationEndpointOperations])
    {
        errorMessage = [NSString stringWithFormat:@"No %@ are configured for the endpoint", kRNFConfigurationEndpointOperations];
    }
    
    NSArray *operations = self.operations;
    if([operations count] == 0)
    {
        errorMessage = @"Operations array has 0 elements";
    }
    
    NSMutableArray *operationsObjects = [NSMutableArray new];
    for (NSDictionary *operationDictionary in operations)
    {
        RNFDictionaryOperationConfiguration *operationConfiguration = [[RNFDictionaryOperationConfiguration alloc] initWithDictionary:operationDictionary];
        [operationsObjects addObject:operationConfiguration];
    }
    self.internalDictionary[kRNFConfigurationEndpointOperations] = operationsObjects;
    
    NSURL *baseURL = self.baseURL;
    if(!baseURL)
    {
        errorMessage = [NSString stringWithFormat:@"The specified %@ is not valid", kRNFConfigurationEndpointBaseURL];
    }
    
    if(errorMessage)
        @throw [[RNFMalformedConfiguration alloc] initWithName:NSStringFromClass([RNFMalformedConfiguration class])
                                                    reason:errorMessage
                                                  userInfo:nil];
}

#pragma mark - Helpers

- (Class) classFromKey:(const NSString *)key
{
    NSString *className = [self.internalDictionary objectForKey:key];
    if (className)
    {
        Class result = NSClassFromString(className);
        return result;
    } else {
        return nil;
    }
}

#pragma mark - Getters

- (NSURL *) baseURL
{
    return [NSURL URLWithString:self.internalDictionary[kRNFConfigurationEndpointBaseURL]];
}

- (NSArray *) operations
{
    return self.internalDictionary[kRNFConfigurationEndpointOperations];
}

- (NSString *) name
{
    return [self.internalDictionary objectForKey:kRNFConfigurationEndpointName] ?: [super name];
}

- (BOOL) cacheResults
{
    if([self.internalDictionary objectForKey:kRNFConfigurationEndpointShouldCacheResults])
        return [[self.internalDictionary objectForKey:kRNFConfigurationEndpointShouldCacheResults] boolValue];
    else
        return [super cacheResults];
}

- (NSDictionary *) headers
{
    return [self.internalDictionary objectForKey:kRNFConfigurationEndpointDefaultHeaders] ?: [super headers];
}

- (id<RNFResponseDeserializer>) deserializer
{
    @synchronized(self)
    {
        if(!self.cachedDeserializer)
        {
            Class deserializerClass = [self classFromKey:kRNFConfigurationEndpointResponseDeserializer];
            if(!deserializerClass)
                self.cachedDeserializer = [super deserializer];
            else
                self.cachedDeserializer = [deserializerClass new];
        }
        
        return self.cachedDeserializer;
    }
}

- (NSNumber *) portNumber
{
    return [self.internalDictionary objectForKey:kRNFConfigurationEndpointPortNumber] ?: [super portNumber];
}

- (Class<RNFOperation>) operationClass
{
    return [self classFromKey:kRNFConfigurationEndpointOperationClass] ?: [super operationClass];
}

- (Class<RNFOperationQueue>) operationQueueClass
{
    return [self classFromKey:kRNFConfigurationEndpointOperationQueueClass] ?: [super operationQueueClass];
}

- (Class<RNFCacheHandler>) cacheClass
{
    return [self classFromKey:kRNFConfigurationEndpointCacheClass] ?: [super cacheClass];
}

- (id<RNFLogger>) logger
{
    @synchronized(self)
    {
        if(!self.cachedLogger)
        {
            Class loggerClass = [self classFromKey:kRNFConfigurationEndpointLoggerClass];
            if(!loggerClass)
                self.cachedLogger = [super logger];
            else
                self.cachedLogger = [loggerClass new];
        }
        
        return self.cachedLogger;
    }
}

@end
