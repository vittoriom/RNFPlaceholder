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

@property (nonatomic, strong, readwrite) NSString *uniqueIdentifier;

@end

@implementation RNFBaseOperation

#pragma mark - Initializers

- (instancetype) initWithURL:(NSURL *)url method:(NSString *)method
{
    self = [self init];
    
    _operationState = RNFOperationStateIdle;
	_url = url;
	_method = method;
    
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

- (NSString *) uniqueIdentifier
{
    //TODO make smarter method here
    return nil;
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

- (void) startWithCompletionBlock:(RNFCompletionBlockComplete)completion errorBlock:(RNFErrorBlock)error
{
	NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
		if(connectionError)
			error(data, connectionError, [connectionError code]);
		else
			completion(data, self, 200, NO);
	}];
}

@end
