//
//  AFHTTPRequestOperation+RNFOperation.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 23/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "AFHTTPRequestOperation+RNFOperation.h"
#import <objc/runtime.h>

@implementation AFHTTPRequestOperation (RNFOperation)

- (instancetype) initWithURL:(NSURL *)url
                      method:(NSString *)method
                     headers:(NSDictionary *)headers
                        body:(NSData *)body
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = method;
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:body];

    return [self initWithRequest:request];
}

- (void) setCompletionBlock:(RNFCompletionBlockComplete)completionBlock
                       errorBlock:(RNFErrorBlock)errorBlock
{
    __weak id<RNFOperation> weakOperation = self;
    [self setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completionBlock(responseObject, weakOperation, operation.response.statusCode, NO);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(operation.responseData, error, operation.response.statusCode);
    }];
}

- (NSString *) uniqueIdentifier
{
    //TODO smarter method here
    return nil;
}

@end