//
//  RNFParameterMerger.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 22/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "RNFUnifiedConfiguration.h"

@interface RNFUnifiedConfiguration ()

@property (nonatomic, weak) id<RNFOperationConfiguration> operationConfiguration;
@property (nonatomic, weak) id<RNFEndpointConfiguration> endpointConfiguration;

@end

@implementation RNFUnifiedConfiguration

- (instancetype) initWithEndpointConfiguration:(id<RNFEndpointConfiguration>)endpoint operationConfiguration:(id<RNFOperationConfiguration>)operation
{
    self = [self init];
    
    self.operationConfiguration = operation;
    self.endpointConfiguration = endpoint;
    
    return self;
}

- (NSString *) name
{
    return [self.operationConfiguration name];
}

- (NSString *) baseURL
{
    return [self.endpointConfiguration baseURL];
}

- (NSArray *) operations
{
    return [self.endpointConfiguration operations];
}

- (id<RNFResponseValidator>) responseValidator
{
    if ([self.operationConfiguration respondsToSelector:@selector(responseValidator)])
    {
        id validator = [self.operationConfiguration responseValidator];
        if (validator)
        {
            return validator;
        }
    }
    if ([self.endpointConfiguration respondsToSelector:@selector(responseValidator)])
    {
        return [self.endpointConfiguration responseValidator];
    } else
        return nil;
}

- (NSString *) URL
{
    NSString *component1 = [self baseURL] ?: nil;
    NSString *component2 = [self.operationConfiguration URL] ?: @"";
    
    if(!component1)
        return nil;
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",
                           component1,
                           component2];
    
    return urlString;
}

- (Class<RNFOperation>) operationClass
{
    if ([self.operationConfiguration respondsToSelector:@selector(operationClass)])
    {
        id operationClass = [self.operationConfiguration operationClass];
        if (operationClass)
        {
            return operationClass;
        }
    }
    
    return [self.endpointConfiguration operationClass];
}

- (NSString *) HTTPMethod
{
    if ([self.operationConfiguration respondsToSelector:@selector(HTTPMethod)])
    {
        return [self.operationConfiguration HTTPMethod];
    } else
        return @"GET";
}

- (NSData *) HTTPBody
{
    if([self.operationConfiguration respondsToSelector:@selector(HTTPBody)])
    {
        return [self.operationConfiguration HTTPBody];
    } else
        return nil;
}

- (id<RNFDataDeserializer>) dataDeserializer
{
    if ([self.operationConfiguration respondsToSelector:@selector(dataDeserializer)])
    {
        return [self.operationConfiguration dataDeserializer];
    } else
        return nil;
}

- (id<RNFDataSerializer>) dataSerializer
{
    if ([self.operationConfiguration respondsToSelector:@selector(dataSerializer)])
    {
        return [self.operationConfiguration dataSerializer];
    } else
        return nil;
}

- (NSDictionary *) queryStringParameters
{
    if ([self.endpointConfiguration respondsToSelector:@selector(queryStringParameters)])
    {
        return [self.endpointConfiguration queryStringParameters];
    } else
        return nil;
}

- (NSDictionary *) headers
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    if ([self.endpointConfiguration respondsToSelector:@selector(headers)])
    {
        [parameters addEntriesFromDictionary:[self.endpointConfiguration headers]];
    }
    
    if([self.operationConfiguration respondsToSelector:@selector(headers)])
    {
        [parameters addEntriesFromDictionary:[self.operationConfiguration headers]];
    }
    
    return parameters;
}

- (id<RNFResponseDeserializer>) responseDeserializer
{
    if ([self.operationConfiguration respondsToSelector:@selector(responseDeserializer)])
    {
        id deserializer = [self.operationConfiguration responseDeserializer];
        if (deserializer)
        {
            return deserializer;
        }
    }
    if([self.endpointConfiguration respondsToSelector:@selector(responseDeserializer)])
    {
        return [self.endpointConfiguration responseDeserializer];
    } else
        return nil;
}

- (id<RNFLogger>) logger
{
    if([self.endpointConfiguration respondsToSelector:@selector(logger)])
        return [self.endpointConfiguration logger];
    else
        return nil;
}

- (Class<RNFOperationQueue>) operationQueueClass
{
    if ([self.endpointConfiguration respondsToSelector:@selector(operationQueueClass)])
    {
        return [self.endpointConfiguration operationQueueClass];
    } else
        return nil;
}

- (id<RNFRequestAuthentication>) authenticationHandler
{
    if ([self.operationConfiguration respondsToSelector:@selector(authenticationHandler)])
    {
        id handler = [self.operationConfiguration authenticationHandler];
        if (handler)
        {
            return handler;
        }
    }
    if ([self.endpointConfiguration respondsToSelector:@selector(authenticationHandler)])
    {
        return [self.endpointConfiguration authenticationHandler];
    } else
        return nil;
}

- (BOOL) cacheResults
{
    BOOL operation = YES, endpoint = YES;
    if ([self.operationConfiguration respondsToSelector:@selector(cacheResults)])
    {
        operation = [self.operationConfiguration cacheResults];
    }
    if([self.endpointConfiguration respondsToSelector:@selector(cacheResults)])
    {
        endpoint = [self.endpointConfiguration cacheResults];
    }
    
    return endpoint && operation;
}

- (Class<RNFCacheHandler>) cacheClass
{
    if ([self.endpointConfiguration cacheClass])
    {
        return [self.endpointConfiguration cacheClass];
    } else
        return nil;
}

@end
