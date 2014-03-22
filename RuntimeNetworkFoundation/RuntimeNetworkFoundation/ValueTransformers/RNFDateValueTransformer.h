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

@interface RNFDateValueTransformer : NSObject <RNFValueTransformer, RNFInitializableWithDictionary>

@end
