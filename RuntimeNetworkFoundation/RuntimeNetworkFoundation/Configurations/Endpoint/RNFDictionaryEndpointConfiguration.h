//
//  RNFDictionaryConfiguration.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 10/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNFBaseEndpointConfiguration.h"
#import "RNFUserDefinedConfigurationParameters.h"

static const NSString * kRNFConfigurationEndpointBaseURL = @"baseURL";
static const NSString * kRNFConfigurationEndpointOperations = @"operations";
static const NSString * kRNFConfigurationEndpointName = @"name";
static const NSString * kRNFConfigurationEndpointDefaultHeaders = @"headers";
static const NSString * kRNFConfigurationEndpointResponseDeserializer = @"responseDeserializer";
static const NSString * kRNFConfigurationEndpointOperationClass = @"operationClass";
static const NSString * kRNFConfigurationEndpointOperationQueueClass = @"operationQueueClass";
static const NSString * kRNFConfigurationEndpointShouldCacheResults = @"cacheResults";
static const NSString * kRNFConfigurationEndpointCacheClass = @"cacheClass";
static const NSString * kRNFConfigurationEndpointLogger = @"loggerClass";
static const NSString * kRNFConfigurationEndpointDefaultQueryStringParameters = @"queryString";
static const NSString * kRNFConfigurationEndpointAuthenticationHandler = @"authHandler";
static const NSString * kRNFConfigurationEndpointResponseValidator = @"responseValidator";
static const NSString * kRNFConfigurationEndpointUserDefinedParameters = @"userDefined";

@interface RNFDictionaryEndpointConfiguration : RNFBaseEndpointConfiguration <RNFUserDefinedConfigurationParameters>

/**
 *  Initializes an instance of RNFConfiguration based on a backing NSDictionary with the given dictionary values
 *
 *  @param dictionary the given key-value pairs to use as a configuration source
 *
 *  @return the initialized RNFConfiguration
 * 
 *  @throws RNFMalformedConfiguration if the dictionary is missing mandatory keys
 */
- (instancetype) initWithDictionary:(NSDictionary *)dictionary;

@end
