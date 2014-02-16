
//
//  NSCache+RNFCacheHandler.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 16/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "NSCache+RNFCacheHandler.h"

@implementation NSCache (RNFCacheHandler)

- (id) cachedObjectWithKey:(NSString *)key
{
    return [self objectForKey:key];
}

- (void) cacheObject:(id)object withKey:(NSString *)key withCost:(NSUInteger)cost
{
    [self setObject:object forKey:key cost:cost];
}

- (id) initWithCapacity:(NSUInteger)maxCost
{
    self = [self init];
    
    [self setTotalCostLimit:maxCost];
    
    return self;
}

@end
