//
//  RNFConfiguration.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 10/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RNFOperation;
@protocol RNFResponseDeserializer;
@protocol RNFOperationQueue;
@protocol RNFCacheHandler;
@protocol RNFLogger;

@protocol RNFConfiguration <NSObject>

/**
 *  The baseURL of the configured endpoint
 *
 *  @discussion this parameter is mandatory, so the method will NEVER return nil
 *
 *  @return the baseURL of the endpoint
 */
- (NSURL *) baseURL;

/**
 *  The operations array of the configured endpoint
 *
 *  @discussion this parameter is mandatory, so the method will NEVER return nil or an empty array
 *
 *  @return the operations of the endpoint
 */
- (NSArray *) operations;

@optional

/**
 *  This parameter is optional, so the method may return nil
 *
 *  @return the name of the endpoint, or nil if no name is configured
 *
 *  @discussion please note that if no name is configured for a given endpoint, it could not be used through a RNFEndpointManager
 */
- (NSString *) name;

/**
 *  This parameter is optional, so the method may return nil
 *
 *  @return the default headers to use for all the operations on the given endpoint, or nil if no default headers are specified
 */
- (NSDictionary *) headers;

/**
 *  This parameter is optional, so the method may return nil
 *
 *  @return the deserializer to use for responses to the operations for the given endpoint, or nil if no deserialization should be provided. In this case, the completion blocks will get raw NSData objects, if no data deserializer is specified
 */
- (id<RNFResponseDeserializer>) deserializer;

/**
 *  This parameter is optional, so the method may return nil or a default class
 *
 *  @return The class to use for the operations on the given endpoint, or nil if no specific class is configured.
 *  The method may also return a default class used when no configuration is provided
 */
- (Class<RNFOperation>) operationClass;

/**
 *  This parameter is optional, so the method may return nil or a default class
 *
 *  @return The class to use for queueing operations on the given endpoint, or nil if no specific class is configured.
 *  The method may also return a default class (such as NSOperationQueue) when no configuration is provided
 */
- (Class<RNFOperationQueue>) operationQueueClass;

/**
 *  This parameter is optional, so the method may return a default value
 *
 *  @return Whether the endpoint should cache results or not. By default the value is YES
 */
- (BOOL) cacheResults;

/**
 *  This parameter is optional, so the method may return nil or a default class
 *
 *  @return If cacheResults is YES, the class to use as a cache handler. By default the value is NSCache
 */
- (id<RNFCacheHandler>) cacheClass;

/**
 *  This parameter is optional, so the method may return nil or a default class
 *
 *  @return The logger instance to use as a logging component, or nil if no logger is specified
 */
- (id<RNFLogger>) logger;

@end
