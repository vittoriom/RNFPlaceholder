
//
//  NSCache+RNFCacheHandler.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 16/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "NSCache+RNFCacheHandler.h"
#import "RNFUnifiedConfiguration.h"

@implementation NSCache (RNFCacheHandler)

- (BOOL) operationConfigurationCanBeCached:(RNFUnifiedConfiguration *)operationConfiguration
{
    return  [[operationConfiguration HTTPMethod] isEqualToString:@"GET"];
}

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

- (BOOL) cachedDataIsValidWithKey:(NSString *)key
{
    return NO;
}

@end
