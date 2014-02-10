//
//  RNFDefaultOperation.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 09/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "RNFDefaultOperation.h"

@interface RNFDefaultOperation ()

@property (nonatomic, strong, readwrite) NSString *name;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) RNFEndpoint *endpoint;
@property (nonatomic, strong) NSDictionary *headers;
@property (nonatomic, strong) NSDictionary *body;

@property (nonatomic, copy) RNFCompletionBlockGeneric completionBlock;

@end

@implementation RNFDefaultOperation

- (void) start
{
    
}

- (BOOL) isConcurrent
{
    return NO;
}

- (void) cancel
{
    
}

- (BOOL) isExecuting
{
    return NO;
}

- (BOOL) isFinished
{
    return NO;
}

- (void) startWithCompletionBlock:(RNFCompletionBlockGeneric)completion
{
    
}

@end
