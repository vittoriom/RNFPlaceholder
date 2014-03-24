//
//  RNFDictionaryOperationConfiguration.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 13/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "RNFBaseOperationConfiguration.h"

static const NSString * kRNFConfigurationOperationURL = @"URL";
static const NSString * kRNFConfigurationOperationName = @"name";
static const NSString * kRNFConfigurationOperationHTTPMethod = @"HTTPMethod";
static const NSString * kRNFConfigurationOperationHTTPBody = @"body";
static const NSString * kRNFConfigurationOperationResponseDeserializer = @"responseDeserializer";
static const NSString * kRNFConfigurationOperationDataDeserializer = @"dataDeserializer";
static const NSString * kRNFConfigurationOperationDataSerializer = @"dataSerializer";
static const NSString * kRNFConfigurationOperationAuthenticationHandler = @"authenticationHandler";
static const NSString * kRNFConfigurationOperationHeaders = @"headers";
static const NSString * kRNFConfigurationOperationShouldCacheResults = @"cacheResults";
static const NSString * kRNFConfigurationOperationOperationClass = @"operationClass";
static const NSString * kRNFConfigurationOperationResponseValidator = @"responseValidator";

@interface RNFDictionaryOperationConfiguration : RNFBaseOperationConfiguration

- (instancetype) initWithDictionary:(NSDictionary *)dictionary;

@end
