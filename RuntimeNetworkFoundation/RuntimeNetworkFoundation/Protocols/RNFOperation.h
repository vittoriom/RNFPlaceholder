//
// Created by Vittorio Monaco on 09/02/14.
// Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNF.h"

@class RNFEndpoint;

@protocol RNFOperation <NSObject>

/**
 *  <#Description#>
 *
 *  @param url    <#url description#>
 *  @param method <#method description#>
 *
 *  @return <#return value description#>
 */
- (id) initWithURL:(NSURL *)url
            method:(NSString *)method;

/**
 *  <#Description#>
 *
 *  @param completion <#completion description#>
 */
- (void) startWithCompletionBlock:(RNFCompletionBlockGeneric)completion;

/**
 *  <#Description#>
 *
 *  @param headers <#headers description#>
 */
- (void) setHeaders:(NSDictionary *)headers;

/**
 *  <#Description#>
 *
 *  @param body <#body description#>
 */
- (void) setBody:(NSData *)body;

@optional

/**
 *  The name of the operation
 *  This can be used as a convenience hook for getting a specific operation from a RNFEndpoint
 */
@property (nonatomic, readonly) NSString *name;

@end