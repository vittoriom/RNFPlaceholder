//
//  NSObject+RNFSerializable.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 16/03/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "NSObject+RNFSerializable.h"

@implementation NSObject (RNFSerializable)

- (BOOL) isSerializable
{
    return ([self isKindOfClass:[NSNumber class]] ||
            [self isKindOfClass:[NSString class]] ||
//            [self isKindOfClass:[NSDictionary class]] ||
            [self conformsToProtocol:@protocol(RNFSerializable)]);
}

- (NSString *) serialize
{
    return [self description];
}

@end
