//
// Created by Vittorio Monaco on 09/02/14.
// Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RNFOperation;

@protocol RNFOperationQueue <NSObject>

/**
 *  Asks the operation queue to add a RNFOperation to the queue (but your implementation may immediately start the operation as well)
 *
 *  @param operation The RNFOperation to execute immediately or later
 */
- (void) enqueueOperation:(NSOperation<RNFOperation> *)operation;

@end