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

- (NSURL *) baseURL
{
    return [self.endpointConfiguration baseURL];
}

- (NSArray *) operations
{
    return [self.endpointConfiguration operations];
}

- (Class<RNFResponseValidator>) responseValidator
{
    if ([self.operationConfiguration respondsToSelector:@selector(responseValidator)])
    {
        return [self.operationConfiguration responseValidator];
    } else if ([self.endpointConfiguration respondsToSelector:@selector(responseValidator)])
    {
        return [self.endpointConfiguration responseValidator];
    } else
        return nil;
}

- (NSString *) URL
{
    NSString *component1 = [self baseURL] ? [self baseURL].absoluteString : nil;
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
        return [self.operationConfiguration operationClass];
    } else
    {
        return [self.endpointConfiguration operationClass];
    }
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

- (NSNumber *) portNumber
{
    if ([self.endpointConfiguration respondsToSelector:@selector(portNumber)])
    {
        return [self.endpointConfiguration portNumber];
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

- (Class<RNFResponseDeserializer>) responseDeserializer
{
    if ([self.operationConfiguration respondsToSelector:@selector(responseDeserializer)])
    {
        return [self.operationConfiguration responseDeserializer];
    } else if([self.endpointConfiguration respondsToSelector:@selector(responseDeserializer)])
    {
        return [self.endpointConfiguration responseDeserializer];
    } else
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

- (BOOL) cacheResults
{
    if ([self.operationConfiguration respondsToSelector:@selector(cacheResults)])
    {
        return [self.operationConfiguration cacheResults];
    } else if([self.endpointConfiguration respondsToSelector:@selector(cacheResults)])
    {
        return [self.endpointConfiguration cacheResults];
    } else
        return NO;
}

- (Class<RNFCacheHandler>) cacheClass
{
    if ([self.endpointConfiguration cacheClass])
    {
        return [self.endpointConfiguration cacheClass];
    } else
        return nil;
}

- (Class<RNFLogger>) logger
{
    if([self.endpointConfiguration respondsToSelector:@selector(logger)])
        return [self.endpointConfiguration logger];
    else
        return nil;
}

@end
