//
//  NSArray+Blocks.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 15/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "NSArray+RNFBlocks.h"

@implementation NSArray (RNFBlocks)

- (id) rnf_objectPassingTest:(RNFPassingTest)test
{
    if (!test)
    {
        return nil;
    }

    for (id object in self)
    {
        if (test(object))
        {
            return object;
        }
    }

    return nil;
}

@end
