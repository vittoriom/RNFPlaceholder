
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

//static const NSUInteger RNFMemoryCacheDefaultSize = 10 * 1024 * 1024; //10 MB
//static const NSUInteger RNFDiskCacheDefaultSize = 30 * 1024 * 1024; //30 MB
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
    if([self cachedDataIsValidWithKey:key])
    {
        return [self objectForKey:key];
    } else
    {
        return nil;
    }
}

- (void) cacheObject:(id)object withKey:(NSString *)key withCost:(NSNumber *)cost validUntil:(NSDate *)validUntil
{
    if ([validUntil timeIntervalSinceNow] > 0)
    {
        [self setObject:object forKey:key cost:[cost integerValue]];
        NSMutableDictionary *index = [self associatedIndex];
        [index setObject:validUntil forKey:key];
    }
}

- (instancetype) initWithCapacity:(NSUInteger)maxCost
{
    self = [self init];

    [self setTotalCostLimit:maxCost];
    
    return self;
}

- (BOOL) cachedDataIsValidWithKey:(NSString *)key
{
    NSMutableDictionary *index = [self associatedIndex];
    NSDate *validUntil = [index objectForKey:key];
    
    if([validUntil timeIntervalSinceNow] > 0)
    {
        return YES;
    } else
    {
        [index removeObjectForKey:key];
        return NO;
    }
}

@end
