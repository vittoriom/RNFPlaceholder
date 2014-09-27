//
//  RNFParameterMerger.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 22/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNFOperationConfiguration.h"
#import "RNFEndpointConfiguration.h"

@interface RNFUnifiedConfiguration : NSObject <RNFOperationConfiguration, RNFEndpointConfiguration>

/**
 *  Creates an instance of a unified configuration. This lets you have a single object to query when you want to get configuration values for an operation on a specific endpoint, without having to care about combining the results or querying the single configurations
 *
 *  @param endpoint  The endpoint configuration
 *  @param operation The operation configuration. Can safely be nil
 *
 *  @return An instance of a RNFUnifiedConfiguration with the two specified configurations merged
 */
- (instancetype) initWithEndpointConfiguration:(id<RNFEndpointConfiguration>)endpoint
                        operationConfiguration:(id<RNFOperationConfiguration>)operation;

@end
