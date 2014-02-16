//
// Created by Vittorio Monaco on 09/02/14.
// Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RNFEndpoint;

@protocol RNFCacheHandler <NSObject>

/**
 *  Asks the cache to cache data
 *
 *  @param object The data to cache (usually a NSData instance)
 *  @param key    The key for the data to cache (usually the uniqueIdentifier of the operation)
 *  @param cost   The cost of the cached data (usually the lenght in bytes)
 */
- (void) cacheObject:(id)object withKey:(NSString *)key withCost:(NSUInteger)cost;

/**
 *  Asks the cache to retrieve data with a specified key
 *
 *  @param key The key for the cached data
 *
 *  @return The cached data (usually a NSData instance) or nil, if no cached data with the specified key is present
 */
- (id) cachedObjectWithKey:(NSString *)key;

/**
 *  Initializes a new instance of a RNFCacheHandler with a specified capacity
 *
 *  @param maxCost The capacity for the newly created cache
 *
 *  @return The initialized RNFCacheHandler instance
 */
- (id) initWithCapacity:(NSUInteger)maxCost;

@optional

/**
 *  A factory method to retrieve a RNFCacheHandler for a given RNFEndpoint
 *
 *  @param endpoint The endpoint for which the RNFCacheHandler is required
 *
 *  @return a RNFCacheHandler instance, or nil
 *
 *  @discussion this method could be implemented to return the same RNFCacheHandler instance for every endpoint, or a different instance for each endpoint
 */
+ (id<RNFCacheHandler>) cacheHandlerForEndpoint:(RNFEndpoint *)endpoint;

@end