//
//  RNFBaseOperationConfiguration.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 13/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "RNFBaseOperationConfiguration.h"
#import "RNFMalformedConfiguration.h"

@implementation RNFBaseOperationConfiguration

- (NSString *) name
{
    @throw [[RNFMalformedConfiguration alloc] initWithName:NSStringFromClass([RNFMalformedConfiguration class])
                                                    reason:NSLocalizedString(@"If you got here, something is wrong in your subclass", @"")
                                                  userInfo:nil];
}

- (NSURL *) URL
{
    @throw [[RNFMalformedConfiguration alloc] initWithName:NSStringFromClass([RNFMalformedConfiguration class])
                                                    reason:NSLocalizedString(@"If you got here, something is wrong in your subclass", @"")
                                                  userInfo:nil];
}

- (NSString *) HTTPMethod
{
    return @"GET";
}

- (NSDictionary *) HTTPBody
{
    return nil;
}

- (id<RNFResponseDeserializer>) responseDeserializer
{
    return nil;
}

- (id<RNFDataSerializer>) dataSerializer
{
    return nil;
}

- (id<RNFDataDeserializer>) dataDeserializer
{
    return nil;
}

@end
