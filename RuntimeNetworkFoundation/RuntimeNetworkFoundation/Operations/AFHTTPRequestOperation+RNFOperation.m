//
//  AFHTTPRequestOperation+RNFOperation.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 23/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#if defined(__has_include)
#if __has_include(<AFNetworking/AFHTTPRequestOperation.h>)
#import "AFHTTPRequestOperation+RNFOperation.h"

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
        if (completionBlock)
            completionBlock(responseObject, weakOperation, operation.response.statusCode, NO, operation.response);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (errorBlock)
            errorBlock(operation.responseData, error, operation.response.statusCode);
        else
            completionBlock(nil, operation, operation.response.statusCode, NO, operation.response);
    }];
}

- (NSString *) uniqueIdentifier
{
    return [[[NSString stringWithFormat:@"%@%@",self.request.URL.absoluteString,self.request.HTTPMethod] dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
}

@end

#endif
#endif
