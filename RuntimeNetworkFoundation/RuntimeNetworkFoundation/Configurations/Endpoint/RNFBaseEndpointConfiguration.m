//
//  RNFDefaultConfiguration.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 11/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "RNFBaseEndpointConfiguration.h"
#import "RNFMalformedConfiguration.h"
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

- (Class<RNFResponseValidator>) responseValidator
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

- (NSNumber *) portNumber
{
    return nil;
}

- (NSDictionary *) headers
{
    return nil;
}

- (Class<RNFResponseDeserializer>) responseDeserializer
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

- (Class<RNFLogger>) logger
{
    return nil;
}

@end
