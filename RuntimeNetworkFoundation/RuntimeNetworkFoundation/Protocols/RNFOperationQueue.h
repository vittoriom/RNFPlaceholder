//
// Created by Vittorio Monaco on 09/02/14.
// Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RNFOperation;

@protocol RNFOperationQueue <NSObject>

- (void) enqueueOperation:(NSOperation<RNFOperation> *)operation;

@end