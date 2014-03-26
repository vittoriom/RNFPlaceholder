//
//  AFHTTPRequestOperation+RNFOperationSpec.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 25/03/14.
//  Copyright 2014 Vittorio Monaco. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "AFHTTPRequestOperation+RNFOperation.h"
#import <OHHTTPStubs/OHHTTPStubs.h>

SPEC_BEGIN(AFHTTPRequestOperation_RNFOperationSpec)

describe(@"AFHTTPRequestOperation+RNFOperation", ^{
    context(@"when creating a new operation", ^{
        __block AFHTTPRequestOperation *operation;
        
        beforeAll(^{
            operation = [[AFHTTPRequestOperation alloc] initWithURL:[NSURL URLWithString:@"http://www.github.com"] method:@"GET" headers:@{ @"X-RNF-Version" : @"1.0" } body:[NSJSONSerialization dataWithJSONObject:@{ @"key" : @"value" } options:0 error:nil]];
        });
        
        it(@"should not be nil", ^{
            [[operation shouldNot] beNil];
        });
        
        it(@"should have the required properties set", ^{
            [[operation.request.URL.absoluteString should] equal:@"http://www.github.com"];
            [[operation.request.HTTPMethod should] equal:@"GET"];
            [[operation.request.allHTTPHeaderFields should] equal:@{ @"X-RNF-Version" : @"1.0" }];
            [[[NSJSONSerialization JSONObjectWithData:operation.request.HTTPBody options:0 error:nil] should] equal:@{ @"key" : @"value" }];
        });
    });
    
    context(@"when generating a unique identifier", ^{
        __block AFHTTPRequestOperation *op1;
        __block AFHTTPRequestOperation *op2;
        
        it(@"should generate the same identifier for the same object", ^{
            op1 = [[AFHTTPRequestOperation alloc] initWithURL:[NSURL URLWithString:@"http://www.github.com"] method:@"GET" headers:@{ @"X-RNF-Version" : @"1.0" } body:[NSJSONSerialization dataWithJSONObject:@{ @"key" : @"value" } options:0 error:nil]];
            op2 = op1;
            
            [[[op1 uniqueIdentifier] should] equal:[op2 uniqueIdentifier]];
        });
        
        it(@"should generate the same identifier for two GET requests with the same URL", ^{
            op1 = [[AFHTTPRequestOperation alloc] initWithURL:[NSURL URLWithString:@"http://www.github.com"] method:@"GET" headers:@{ @"X-RNF-Version" : @"1.0" } body:nil];
            op2 = [[AFHTTPRequestOperation alloc] initWithURL:[NSURL URLWithString:@"http://www.github.com"] method:@"GET" headers:@{ @"X-RNF-Version" : @"1.0" } body:nil];
            
            [[[op1 uniqueIdentifier] should] equal:[op2 uniqueIdentifier]];
        });
        
        it(@"should generate two different identifiers for non-GET requests", ^{
            op1 = [[AFHTTPRequestOperation alloc] initWithURL:[NSURL URLWithString:@"http://www.github.com/v2"] method:@"POST" headers:@{ @"X-RNF-Version" : @"1.0" } body:nil];
            op2 = [[AFHTTPRequestOperation alloc] initWithURL:[NSURL URLWithString:@"http://www.github.com"] method:@"PUT" headers:@{ @"X-RNF-Version" : @"1.0" } body:nil];
            
            [[[op1 uniqueIdentifier] shouldNot] equal:[op2 uniqueIdentifier]];
        });
        
        it(@"should generate two different identifiers for GET requests with different URLs", ^{
            op1 = [[AFHTTPRequestOperation alloc] initWithURL:[NSURL URLWithString:@"http://www.github.com/v1"] method:@"GET" headers:@{ @"X-RNF-Version" : @"1.0" } body:nil];
            op2 = [[AFHTTPRequestOperation alloc] initWithURL:[NSURL URLWithString:@"http://www.github.com/v2"] method:@"GET" headers:@{ @"X-RNF-Version" : @"1.0" } body:nil];
            
            [[[op1 uniqueIdentifier] shouldNot] equal:[op2 uniqueIdentifier]];
        });
        
        it(@"should generate two different identifiers for two requests with the same URL but different verb", ^{
            op1 = [[AFHTTPRequestOperation alloc] initWithURL:[NSURL URLWithString:@"http://www.github.com"] method:@"POST" headers:@{ @"X-RNF-Version" : @"1.0" } body:nil];
            op2 = [[AFHTTPRequestOperation alloc] initWithURL:[NSURL URLWithString:@"http://www.github.com"] method:@"PUT" headers:@{ @"X-RNF-Version" : @"1.0" } body:nil];
            
            [[[op1 uniqueIdentifier] shouldNot] equal:[op2 uniqueIdentifier]];
        });
    });
    
    context(@"when executing the operation", ^{
        context(@"when the operation requires basic auth", ^{
            it(@"should fail if no credential is provided", ^{
                //TODO: I need a ws with a basic auth request
            });
            
            it(@"should succeed if a valid credential is provided", ^{
                //TODO: I need a ws with a basic auth request
            });
        });
        
        context(@"when the internet is not reachable", ^{
            it(@"should call the failure block", ^{
                [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                    return [request.HTTPMethod isEqualToString:@"GET"] &&
                    [request.URL.absoluteString isEqualToString:@"http://www.github.com/noConnection"];
                } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                    return [OHHTTPStubsResponse responseWithError:[NSError errorWithDomain:NSURLErrorDomain code:kCFURLErrorNotConnectedToInternet userInfo:nil]];
                }];
                
                __block NSNumber *sentinel = @0;
                AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithURL:[NSURL URLWithString:@"http://www.github.com/noConnection"] method:@"GET" headers:@{ @"X-RNF-Version" : @"1.0" } body:nil];
                operation.responseSerializer = [AFJSONResponseSerializer new];
                [operation setCompletionBlock:^(id response, id<RNFOperation> operation, NSUInteger statusCode, BOOL cached, NSURLResponse *urlResponse) {
                    sentinel = @(-1);
                } errorBlock:^(id response, NSError *error, NSUInteger statusCode) {
                    sentinel = @1;
                }];
                
                [operation start];
                
                [[expectFutureValue(sentinel) shouldEventuallyBeforeTimingOutAfter(1)] equal:@1];
            });
        });
        
        context(@"when the request fails", ^{
            it(@"should call the failure block", ^{
                [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                    return [request.HTTPMethod isEqualToString:@"GET"] &&
                    [request.URL.absoluteString isEqualToString:@"http://www.github.com/failure"];
                } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                    return [OHHTTPStubsResponse responseWithError:[NSError errorWithDomain:NSURLErrorDomain code:kCFURLErrorBadServerResponse userInfo:nil]];
                }];
                
                __block NSNumber *sentinel = @0;
                AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithURL:[NSURL URLWithString:@"http://www.github.com/failure"] method:@"GET" headers:@{ @"X-RNF-Version" : @"1.0" } body:nil];
                [operation setCompletionBlock:^(id response, id<RNFOperation> operation, NSUInteger statusCode, BOOL cached, NSURLResponse *urlResponse) {
                    sentinel = @(-1);
                } errorBlock:^(id response, NSError *error, NSUInteger statusCode) {
                    sentinel = @1;
                }];
                
                [operation start];
                
                [[expectFutureValue(sentinel) shouldEventuallyBeforeTimingOutAfter(1)] equal:@1];
            });
        });
        
        context(@"when the internet is reachable", ^{
            it(@"should call the completion block", ^{
                [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                    return [request.HTTPMethod isEqualToString:@"GET"] &&
                           [request.URL.absoluteString isEqualToString:@"http://www.github.com"];
                } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                    return [OHHTTPStubsResponse responseWithData:[NSJSONSerialization dataWithJSONObject:@{
                                                                                                           @"test" : @"OK"
                                                                                                           } options:0 error:nil] statusCode:200 headers:@{ @"Content-Type" : @"application/json" }];
                }];
                
                __block NSDictionary *sentinel = nil;
                AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithURL:[NSURL URLWithString:@"http://www.github.com"] method:@"GET" headers:@{ @"X-RNF-Version" : @"1.0" } body:nil];
                operation.responseSerializer = [AFJSONResponseSerializer new];
                [operation setCompletionBlock:^(id response, id<RNFOperation> operation, NSUInteger statusCode, BOOL cached, NSURLResponse *urlResponse) {
                    sentinel = response;
                } errorBlock:^(id response, NSError *error, NSUInteger statusCode) {
                    sentinel = nil;
                }];
                
                [operation start];
                
                [[expectFutureValue(sentinel) shouldEventuallyBeforeTimingOutAfter(1)] equal:@{ @"test" : @"OK" }];
            });
        });
    });
});

SPEC_END
