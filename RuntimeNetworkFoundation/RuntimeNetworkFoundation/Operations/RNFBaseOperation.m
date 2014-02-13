//
//  RNFDefaultOperation.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 09/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "RNFBaseOperation.h"

typedef enum {
    RNFOperationStateFinished,
    RNFOperationStateFailed,
    RNFOperationStateCanceled,
    RNFOperationStateIdle,
    RNFOperationStateExecuting
} RNFOperationState;

@interface RNFBaseOperation ()

@property (nonatomic, strong, readwrite) NSString *name;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) NSDictionary *headers;
@property (nonatomic, strong) NSData *body;

@property (nonatomic, copy) RNFCompletionBlock completionBlock;
@property (nonatomic, copy) RNFErrorBlock errorBlock;

@property (nonatomic, assign) RNFOperationState operationState;

@end

@implementation RNFBaseOperation

#pragma mark - Initializers

- (instancetype) initWithURL:(NSURL *)url method:(NSString *)method
{
    self = [self init];
    
    _operationState = RNFOperationStateIdle;
    
    return self;
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
    if([self isCancelled])
        return;
   
    //Start connection
}

- (BOOL) isConcurrent
{
    return YES;
}

- (void) cancel
{
    if([self isFinished])
        return;
    
    self.operationState = RNFOperationStateCanceled;
}

- (BOOL) isReady
{
    return [super isReady] && self.operationState == RNFOperationStateIdle;
}

- (BOOL) isExecuting
{
    return self.operationState == RNFOperationStateExecuting;
}

- (BOOL) isFinished
{
    return self.operationState == RNFOperationStateFinished || self.operationState == RNFOperationStateFailed;
}

#pragma mark - RNFOperation

- (void) startWithCompletionBlock:(RNFCompletionBlock)completion errorBlock:(RNFErrorBlock)error
{
	completion(nil, self, 0, NO);
}

@end
