//
//  RNFTypes.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 12/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#ifndef RuntimeNetworkFoundation_RNFTypes_h
#define RuntimeNetworkFoundation_RNFTypes_h

static NSString * RNFErrorDomain = @"RNFErrorDomain";

@protocol RNFOperation;

/**
 *  Completion block that includes three parameters
 *
 *  @param response   The real response from the network call
 *  @param operation  The operation that generated this response
 *  @param statusCode The HTTP status code
 */
typedef void(^RNFCompletionBlock)(id response, id<RNFOperation> operation, NSUInteger statusCode);

/**
 *  The basic completion block, for when you don't actually care a lot :)
 *
 *  @param response The real response from the network call
 */
typedef void(^RNFCompletionBlockBasic)(id response);

/**
 *  The most complete completion block
 *
 *  @param response   The real response from the network call
 *  @param operation  The operation that generated this response
 *  @param statusCode The HTTP status code
 *  @param cached     YES if the response was cached, NO if it's fresh from the web
 */
typedef void(^RNFCompletionBlockComplete)(id response, id<RNFOperation> operation, NSUInteger statusCode, BOOL cached);

/**
 *  The error block called when something goes wrong
 *
 *  @param response   The real response (if any)
 *  @param error      The error
 *  @param statusCode The HTTP status code
 */
typedef void(^RNFErrorBlock)(id response, NSError *error, NSUInteger statusCode);

#endif
