//
//  NSValueTransformer+RNFValueTransformer.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 16/03/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNFValueTransformer.h"

/**
 *  This category lets you use any NSValueTransformer as a RNFValueTransformer (this means you can specify NSValueTransformers in a plist as well
 */
@interface NSValueTransformer (RNFValueTransformer) <RNFValueTransformer>

@end
