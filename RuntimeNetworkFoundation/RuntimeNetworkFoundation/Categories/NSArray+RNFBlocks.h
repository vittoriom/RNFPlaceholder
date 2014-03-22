//
//  NSArray+Blocks.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 15/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL (^RNFPassingTest)(id object);

@interface NSArray (RNFBlocks)

/**
 *  Inspects the elements of the NSArray in a linear fashion, to find one passing the specified test
 *
 *  @param test the test the object should pass
 *
 *  @return the object passing the test
 */
- (id) rnf_objectPassingTest:(RNFPassingTest)test;

@end
