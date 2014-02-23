//
//  NSOperationQueue+RNFOperationQueue.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 23/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "NSOperationQueue+RNFOperationQueue.h"

@implementation NSOperationQueue (RNFOperationQueue)

- (void) enqueueOperation:(id<RNFOperation>)op
{
    id operation = op;
    if ([operation isKindOfClass:[NSOperation class]])
    {
        [self addOperation:operation];
    }
}

@end
