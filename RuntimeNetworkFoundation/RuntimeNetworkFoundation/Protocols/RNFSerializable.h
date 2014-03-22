//
// Created by Vittorio Monaco on 09/02/14.
// Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RNFSerializable <NSObject>

/**
 *  Asks the string representation of an object (for example to put the representation in the body of a request
 *
 *  @return the string representation of the object
 */
- (NSString *) serialize;

@end