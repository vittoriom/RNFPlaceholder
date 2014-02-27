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

- (instancetype) initWithEndpointConfiguration:(id<RNFEndpointConfiguration>)endpoint operationConfiguration:(id<RNFOperationConfiguration>)operation;

@end
