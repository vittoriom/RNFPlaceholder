//
//  NSObject+RNFSerializable.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 16/03/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNFSerializable.h"

@interface NSObject (RNFSerializable)

/**
 @return YES if the object can be successfully serialized, NO otherwise.
 @discussion For example, a NSArray could return NO if there is at least one of its elements that is not successfully serializable
 */
- (BOOL) isSerializable;

@end
