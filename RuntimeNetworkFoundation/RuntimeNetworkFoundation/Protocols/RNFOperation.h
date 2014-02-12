//
// Created by Vittorio Monaco on 09/02/14.
// Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNFTypes.h"

@class RNFEndpoint;

@protocol RNFOperation <NSObject>

/**
 *  Initializes an RNFOperation with a given url and HTTP method
 *
 *  @param url    The complete URL that this RNFOperation should call
 *  @param method The HTTP method (GET, POST, PUT, DELETE, TRACE, HEAD, CONNECT, OPTIONS) to use
 *
 *  @return a initialized RNFOperation
 */
- (instancetype) initWithURL:(NSURL *)url
                      method:(NSString *)method;

/**
 *  Starts the RNFOperation instance
 *  When the operation is completed, RNFCompletionBlockGeneric is called
 *  If the operation failed, RNFErrorBlock is called instead
 *
 *  @param completion the completion block to call if the operation succeeds
 *  @param error      the completion block to call if the operation fails
 *
 *  @discussion If the operation is cached and there is no network connection, the completion block is immediately called with the cached data.
 *              If the operation is cached, network connection is present but connection timeout occurs, the completion block is called with the cached data instead.
 */
- (void) startWithCompletionBlock:(RNFCompletionBlockGeneric)completion
                       errorBlock:(RNFErrorBlock)error;

/**
 *  Sets the headers of the operation
 *
 *  @param headers The NSDictionary containing the key-value pairs headers of the operation
 */
- (void) setHeaders:(NSDictionary *)headers;

/**
 *  Sets the body of the operation
 *
 *  @param body The NSData instance representing the body of the operation
 */
- (void) setBody:(NSData *)body;

@optional

/**
 *  The name of the operation
 *  This can be used as a convenience hook for getting a specific operation from a RNFEndpoint
 */
@property (nonatomic, readonly) NSString *name;

@end