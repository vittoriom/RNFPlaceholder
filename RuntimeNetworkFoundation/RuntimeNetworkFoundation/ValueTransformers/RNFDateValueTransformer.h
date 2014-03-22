//
//  RNFDateValueTransformer.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 09/03/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNFInitializableWithDictionary.h"
#import "RNFValueTransformer.h"

static const NSString * kRNFDateValueTransformerFormat = @"format";

/**
 *  This class lets you transform timestamps (in the form of NSNumbers) and NSStrings representing dates in NSDate objects, optionally using a dateFormat that you can set with the kRNFDateValueTransformerFormat key in a dictionary and pass it to the RNFInitializableWithDictionary initializer
 */
@interface RNFDateValueTransformer : NSObject <RNFValueTransformer, RNFInitializableWithDictionary>

@end
