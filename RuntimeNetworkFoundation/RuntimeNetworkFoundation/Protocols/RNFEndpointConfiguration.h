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

static const NSString * kRNFConfigurationEndpointBaseURL = @"baseURL";
static const NSString * kRNFConfigurationEndpointOperations = @"operations";
static const NSString * kRNFConfigurationEndpointName = @"name";
static const NSString * kRNFConfigurationEndpointDefaultHeaders = @"headers";
static const NSString * kRNFConfigurationEndpointResponseDeserializer = @"responseDeserializer";
static const NSString * kRNFConfigurationEndpointOperationClass = @"operationClass";
static const NSString * kRNFConfigurationEndpointOperationQueueClass = @"operationQueueClass";
static const NSString * kRNFConfigurationEndpointShouldCacheResults = @"cacheResults";
static const NSString * kRNFConfigurationEndpointCacheClass = @"cacheClass";
static const NSString * kRNFConfigurationEndpointLoggerClass = @"loggerClass";
static const NSString * kRNFConfigurationEndpointPortNumber = @"port";
static const NSString * kRNFConfigurationEndpointDefaultQueryStringParameters = @"queryString";

@protocol RNFEndpointConfiguration <NSObject>

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
 *  The port number to reach the endpoint
 *
 *  @discussion this parameter is optional, so it may return nil or a default number
 *
 *  @return the port number to reach the endpoint, or nil if not configured
 */
- (NSNumber *) portNumber;

/**
 *  The default query string parameters to add to all the operations on this endpoint
 *
 *  @discussion this parameter is optional, so it may return nil or a default value
 *
 *  @return the dictionary containing the query string parameters
 */
- (NSDictionary *) queryStringParameters;

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
- (Class<RNFResponseDeserializer>) responseDeserializer;

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
- (Class<RNFCacheHandler>) cacheClass;

/**
 *  This parameter is optional, so the method may return nil or a default class
 *
 *  @return The logger instance to use as a logging component, or nil if no logger is specified
 */
- (Class<RNFLogger>) logger;

@end
