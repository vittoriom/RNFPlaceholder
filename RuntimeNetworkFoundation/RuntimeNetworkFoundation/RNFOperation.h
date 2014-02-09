//
// Created by Vittorio Monaco on 09/02/14.
// Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNF.h"

@class RNFEndpoint;

@protocol RNFOperation <NSObject>

- (id) initWithURL:(NSURL *)url
            method:(NSString *)method;

- (void) startWithCompletionBlock:(RNFCompletionBlockGeneric)completion;

@property (nonatomic, readonly) NSString *name;

@end