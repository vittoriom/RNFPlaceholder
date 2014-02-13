//
//  RNFOperationConfiguration.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 13/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNFResponseDeserializer.h"
#import "RNFDataSerializer.h"
#import "RNFDataDeserializer.h"

static const NSString * kRNFConfigurationOperationURL = @"URL";
static const NSString * kRNFConfigurationOperationRuntimeMethodName = @"runtimeMethod";
static const NSString * kRNFConfigurationOperationHTTPMethod = @"HTTPMethod";
static const NSString * kRNFConfigurationOperationHTTPBody = @"body";
static const NSString * kRNFConfigurationOperationResponseDeserializer = @"responseDeserializer";
static const NSString * kRNFConfigurationOperationDataDeserializer = @"dataDeserializer";
static const NSString * kRNFConfigurationOperationDataSerializer = @"dataSerializer";
static const NSString * kRNFConfigurationOperationAuthenticationHandler = @"authenticationHandler";

@protocol RNFOperationConfiguration <NSObject>

- (NSString *) runtimeMethodName;

- (NSURL *) URL;

@optional

- (NSString *) HTTPMethod;

- (NSDictionary *) HTTPBody;

//- (id<RNFRequestAuthentication>) authenticationHandler;

- (id<RNFResponseDeserializer>) responseDeserializer;

- (id<RNFDataDeserializer>) dataDeserializer;

- (id<RNFDataSerializer>) dataSerializer;

@end
