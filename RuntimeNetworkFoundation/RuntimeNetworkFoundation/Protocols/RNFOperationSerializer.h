//
//  RNFOperationSerializer.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 13/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNFOperation.h"

@protocol RNFOperationSerializer <NSObject>

- (void) serializeOperation:(id<RNFOperation>)operation;
- (NSArray *) deserializeOperations;

@optional

@end
