//
// Created by Vittorio Monaco on 09/02/14.
// Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RNFEndpoint;

@protocol RNFCacheHandler <NSObject>

- (void) cacheObject:(id)object withKey:(NSString *)key withCost:(NSUInteger)cost;

- (id) initWithCapacity:(NSUInteger)maxCost;

- (id) cachedObjectWithKey:(NSString *)key;

@optional

+ (id<RNFCacheHandler>) cacheHandlerForEndpoint:(RNFEndpoint *)endpoint;

@end