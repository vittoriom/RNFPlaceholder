//
// Created by Vittorio Monaco on 09/02/14.
// Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RNFEndpoint;
@class RNFUnifiedConfiguration;

@protocol RNFCacheHandler <NSObject>

/**
 *  Asks the cache to cache data
 *
 *  @param object     The data to cache (usually a NSData instance)
 *  @param key        The key for the data to cache (usually the uniqueIdentifier of the operation)
 *  @param cost       The cost of the cached data (usually the lenght in bytes)
 *  @param validUntil The expiration date of the object (usually the value taken from the headers of the response, if any). It can be nil if the object immediately expires
 */
- (void) cacheObject:(id)object withKey:(NSString *)key withCost:(NSNumber *)cost validUntil:(NSDate *)validUntil;

/**
 *  Asks the cache to retrieve data with a specified key
 *
 *  @param key The key for the cached data
 *
 *  @return The cached data (usually a NSData instance) or nil, if no cached data with the specified key is present
 */
- (id) cachedObjectWithKey:(NSString *)key;

/**
 *  This method is called to check whether a cached object is still valid or not.  
 *  If the object is still valid, no further network request will be made after serving the cached data.
 *  If it's not valid, the cached data will be used just as a placeholder
 *
 *  @param key the key used to store the object previously
 *
 *  @return YES if the data is still valid, NO otherwise
 */
- (BOOL) cachedDataIsValidWithKey:(NSString *)key;

/**
 *  Initializes a new instance of a RNFCacheHandler with a specified capacity
 *
 *  @param maxCost The capacity for the newly created cache
 *
 *  @return The initialized RNFCacheHandler instance
 */
- (id) initWithCapacity:(NSUInteger)maxCost;

/**
 *  The CacheHandler is sent this method before accessing the cache to read a previously cached response, and after a network response to eventually write the data to the cache.
 *
 *  @param operationConfiguration The unified configuration of the operation
 *
 *  @return YES if the operation response should be cached, NO otherwise
 */
- (BOOL) operationConfigurationCanBeCached:(RNFUnifiedConfiguration *)operationConfiguration;

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