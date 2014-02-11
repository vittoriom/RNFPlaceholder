//
//  RNFDefaultConfiguration.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 11/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "RNFDefaultConfiguration.h"
#import "RNFMalformedConfiguration.h"
#import "RNFDefaultOperation.h"

@implementation RNFDefaultConfiguration

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

- (NSString *) name
{
    return nil;
}

- (NSDictionary *) headers
{
    return nil;
}

- (id<RNFResponseDeserializer>) deserializer
{
    return nil;
}

- (Class<RNFOperation>) operationClass
{
    return [RNFDefaultOperation class];
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
