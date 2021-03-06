//
//  RNFOperationConfiguration.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 13/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNFResponseDeserializer.h"
#import "RNFDataSerializer.h"
#import "RNFDataDeserializer.h"
#import "RNFRequestAuthentication.h"
#import "RNFOperation.h"
#import "RNFResponseValidator.h"

@protocol RNFOperationConfiguration <NSObject>

/**
 *  The name of the operation
 *
 *  @discussion This can be a simple name (e.g. 'getTags') or a string representation of a selector
 *  (e.g. 'getItemsForTag:withCompletionBlock:')
 *  In the first case, the operation will be retrieved through operationWithName: method of RNFEndpoint
 *  In the second case, the operation can be retrieved through operationWithName: but also by just calling
 *  the method on the RNFEndpoint
 *
 *  @return the name of the operation
 */
- (NSString *) name;

/**
 *
 *  @return The URL suffix of the operation.
 *  
 *  @discussion The URL can contain {d} components that will be parsed at runtime
 */
- (NSString *) URL;

@optional

/**
 *  The validator to use for the deserialized response
 *
 *  @return a validator or nil, if none is needed
 */
- (id<RNFResponseValidator>) responseValidator;

/**
 *  @return The headers to use for this operation
 */
- (NSDictionary *) headers;

/**
 *  @return Whether this operation should cache results or not
 */
- (BOOL) cacheResults;

/**
 *  @return The class to use for this operation at runtime
 */
- (Class<RNFOperation>) operationClass;

/**
 *
 *  @return The HTTP method to use for the operation (GET, POST, DELETE, HEAD, PUT, ...)
 */
- (NSString *) HTTPMethod;

/**
 *  @return The HTTP Body that the operation should use (in case of POST requests, for example)
 *
 */
- (NSData *) HTTPBody;

/**
 *  @return The authentication handler to use for the operation, if different from the one specified for the endpoint
 */
- (id<RNFRequestAuthentication>) authenticationHandler;

/**
 *  @return The response deserializer to use after NSData comes from the network
 */
- (id<RNFResponseDeserializer>) responseDeserializer;

/**
 *  @return The data deserializer to use after the response has been eventually deserialized
 */
- (id<RNFDataDeserializer>) dataDeserializer;

/**
 *  @return The data serializer to use to build the request
 */
- (id<RNFDataSerializer>) dataSerializer;

@end
