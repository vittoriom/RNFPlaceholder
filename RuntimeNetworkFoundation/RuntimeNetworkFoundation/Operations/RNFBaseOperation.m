//
//  RNFDefaultOperation.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 09/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "RNFBaseOperation.h"

@interface RNFBaseOperation ()

@property (nonatomic, strong, readwrite) NSString *name;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) NSDictionary *headers;
@property (nonatomic, strong) NSData *body;

@property (nonatomic, copy) RNFCompletionBlockGeneric completionBlock;
@property (nonatomic, copy) RNFErrorBlock errorBlock;

@end

@implementation RNFBaseOperation

#pragma mark - Initializers

- (instancetype) initWithURL:(NSURL *)url method:(NSString *)method
{
    return [self init];
}

#pragma mark - Properties

- (NSString *) name
{
    return nil;
}

- (void) setHeaders:(NSDictionary *)headers
{
    
}

- (void) setBody:(NSData *)body
{
    
}

#pragma mark - NSOperation related methods

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

#pragma mark - RNFOperation

- (void) startWithCompletionBlock:(RNFCompletionBlockGeneric)completion errorBlock:(RNFErrorBlock)error
{
    
}

@end
