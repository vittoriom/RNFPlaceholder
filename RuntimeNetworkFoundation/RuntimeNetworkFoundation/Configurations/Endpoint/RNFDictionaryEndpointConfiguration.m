//
//  RNFDictionaryConfiguration.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 10/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "RNFDictionaryEndpointConfiguration.h"
#import "RNFMalformedConfiguration.h"
#import "RNFDictionaryUserDefinedParameters.h"
#import "RNFDictionaryOperationConfiguration.h"

@interface RNFDictionaryEndpointConfiguration ()

@property (nonatomic, strong) NSMutableDictionary *internalDictionary;
@property (nonatomic, strong) id<RNFResponseDeserializer> cachedDeserializer;
@property (nonatomic, strong) id<RNFLogger> cachedLogger;
@property (nonatomic, strong) RNFDictionaryUserDefinedParameters *userDefinedParameters;

@end

@implementation RNFDictionaryEndpointConfiguration

#pragma mark - Initializers

- (instancetype) initWithDictionary:(NSDictionary *)dictionary
{
    self = [self init];
    
    _internalDictionary = [dictionary mutableCopy];
    
    [self performSanityCheckOnDictionary:dictionary];
    
    _userDefinedParameters = [[RNFDictionaryUserDefinedParameters alloc] initWithDictionary:[self.internalDictionary objectForKey:kRNFConfigurationEndpointUserDefinedParameters]];
    
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
    NSMutableSet *operationNamesSet = [NSMutableSet set];
    for (NSDictionary *operationDictionary in operations)
    {
        RNFDictionaryOperationConfiguration *operationConfiguration = [[RNFDictionaryOperationConfiguration alloc] initWithDictionary:operationDictionary];
        
        NSString *operationName = operationConfiguration.name;
        
        if ([operationNamesSet containsObject:operationName])
        {
            errorMessage = [NSString stringWithFormat:@"There is more than one operation named %@", operationName];
            break;
        }
        
        [operationNamesSet addObject:operationName];
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

- (NSDictionary *) queryStringParameters
{
    return self.internalDictionary[kRNFConfigurationEndpointDefaultQueryStringParameters] ?: [super queryStringParameters];
}

- (NSArray *) operations
{
    return self.internalDictionary[kRNFConfigurationEndpointOperations];
}

- (id<RNFUserDefinedConfigurationParameters>) userDefinedConfiguration
{
    return [self.internalDictionary objectForKey:kRNFConfigurationEndpointUserDefinedParameters] ? self : [super userDefinedConfiguration];
}

- (NSString *) name
{
    return [self.internalDictionary objectForKey:kRNFConfigurationEndpointName] ?: [super name];
}

- (id<RNFResponseValidator>) responseValidator
{
    if ([self.internalDictionary objectForKey:kRNFConfigurationEndpointResponseValidator])
        return [[self classFromKey:kRNFConfigurationEndpointResponseValidator] new];
    else
        return [super responseValidator];
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

- (id<RNFResponseDeserializer>) responseDeserializer
{
    return [[self classFromKey:kRNFConfigurationEndpointResponseDeserializer] new];
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

- (Class<RNFLogger>) logger
{
    return [self classFromKey:kRNFConfigurationEndpointLoggerClass];
}

#pragma mark - UserDefined parameters

- (id) valueForUserDefinedParameter:(NSString *)key
{
    return [self.userDefinedParameters valueForUserDefinedParameter:key];
}

- (void) setValue:(id)value forUserDefinedParameter:(NSString *)key
{
    [self.userDefinedParameters setValue:value forUserDefinedParameter:key];
}

@end
