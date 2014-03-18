
//
//  NSCache+RNFCacheHandler.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 16/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "NSCache+RNFCacheHandler.h"
#import "RNFUnifiedConfiguration.h"
#import <objc/runtime.h>

static void * NSCacheAssociatedIndex = &NSCacheAssociatedIndex;

@implementation NSCache (RNFCacheHandler)

- (NSMutableDictionary *) associatedIndex
{
    NSMutableDictionary *index = objc_getAssociatedObject(self, NSCacheAssociatedIndex);
    
    if (!index)
    {
        index = [NSMutableDictionary new];
        objc_setAssociatedObject(self, NSCacheAssociatedIndex, index, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return index;
}

- (BOOL) operationConfigurationCanBeCached:(RNFUnifiedConfiguration *)operationConfiguration
{
    return  [[operationConfiguration HTTPMethod] isEqualToString:@"GET"];
}

- (id) cachedObjectWithKey:(NSString *)key
{
    return [self objectForKey:key];
}

- (void) cacheObject:(id)object withKey:(NSString *)key withCost:(NSNumber *)cost validUntil:(NSDate *)validUntil
{
    if ([validUntil timeIntervalSinceNow] < 0)
    {
        [self setObject:object forKey:key cost:[cost integerValue]];
        NSMutableDictionary *index = [self associatedIndex];
        [index setObject:validUntil forKey:key];
    }
}

- (id) initWithCapacity:(NSUInteger)maxCost
{
    self = [self init];
    
    [self setTotalCostLimit:maxCost];
    
    return self;
}

- (BOOL) cachedDataIsValidWithKey:(NSString *)key
{
    NSDictionary *index = [self associatedIndex];
    
    return [[index objectForKey:key] timeIntervalSinceNow] < 0;
}

@end
