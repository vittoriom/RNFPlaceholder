//
//  RNFURLValueTransformer.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 09/03/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNFValueTransformer.h"

/**
 *  A simple RNFValueTransformer that can transform a NSString instance to a NSURL object, if valid.
 */
@interface RNFURLValueTransformer : NSObject <RNFValueTransformer>

@end
