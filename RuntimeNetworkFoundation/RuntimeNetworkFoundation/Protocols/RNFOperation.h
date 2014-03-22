//
// Created by Vittorio Monaco on 09/02/14.
// Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNFTypes.h"
#import "RNFRunnable.h"

@class RNFEndpoint;

@protocol RNFOperation <RNFRunnable>

/**
 *  Initializes an RNFOperation with a given url and HTTP method
 *
 *  @param url    The complete URL that this RNFOperation should call
 *  @param method The HTTP method (GET, POST, PUT, DELETE, TRACE, HEAD, CONNECT, OPTIONS) to use
 *  @param headers The NSDictionary containing the key-value pairs headers of the operation
 *  @param body The NSData instance representing the body of the operation
 *
 *  @return a initialized RNFOperation
 */
- (instancetype) initWithURL:(NSURL *)url
                      method:(NSString *)method
                     headers:(NSDictionary *)headers
                        body:(NSData *)body;

/**
 *  Sets completion and error blocks for the RNFOperation
 *  When the operation is completed, RNFCompletionBlockGeneric is called
 *  If the operation failed, RNFErrorBlock is called instead
 *
 *  @param completion the completion block to call if the operation succeeds
 *  @param error      the completion block to call if the operation fails
 *
 */
- (void) setCompletionBlock:(RNFCompletionBlockComplete)completion
                       errorBlock:(RNFErrorBlock)error;

/**
 *  The uniqueIdentifier of the operation
 *  This can be overriden in your implementation if you have special needs
 */
@property (nonatomic, readonly) NSString *uniqueIdentifier;

@end