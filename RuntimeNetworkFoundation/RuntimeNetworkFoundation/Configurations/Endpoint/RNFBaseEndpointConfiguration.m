//
//  RNFDefaultConfiguration.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 11/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "RNFBaseEndpointConfiguration.h"
#import "RNFMalformedConfiguration.h"
#import "RNFRequestAuthentication.h"
#import "RNFBaseOperation.h"

@implementation RNFBaseEndpointConfiguration

- (NSURL *) baseURL
{
    @throw [[RNFMalformedConfiguration alloc] initWithName:NSStringFromClass([RNFMalformedConfiguration class])
                                                    reason:NSLocalizedString(@"If you got here, something is wrong in your subclass", @"")
                                                  userInfo:nil];
}

- (NSArray *) operations
{
    @throw [[RNFMalformedConfiguration alloc] initWithName:NSStringFromClass([RNFMalformedConfiguration class])
                                                    reason:NSLocalizedString(@"If you got here, something is wrong in your subclass", @"")
                                                  userInfo:nil];
}

- (id<RNFUserDefinedConfigurationParameters>) userDefinedConfiguration
{
    return nil;
}

- (id<RNFResponseValidator>) responseValidator
{
    return nil;
}

- (NSDictionary *) queryStringParameters
{
    return @{};
}

- (NSString *) name
{
    return nil;
}

- (NSDictionary *) headers
{
    return nil;
}

- (id<RNFResponseDeserializer>) responseDeserializer
{
    return nil;
}

- (id<RNFRequestAuthentication>) authenticationHandler
{
    return nil;
}

- (Class<RNFOperation>) operationClass
{
    return [RNFBaseOperation class];
}

- (Class<RNFOperationQueue>) operationQueueClass
{
    return [NSOperationQueue class];
}

- (BOOL) cacheResults
{
    return YES;
}

- (Class<RNFCacheHandler>) cacheClass
{
    return [NSCache class];
}

- (id<RNFLogger>) logger
{
    return nil;
}

@end
