//
//  RNFValueTransformer.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 11/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RNFValueTransformer <NSObject>

/**
 *
 *  @param originalValue The original value, usually a String, Number, Date, Array or Dictionary
 *
 *  @return The processed value as it should be used for data deserialization or for further processing
 */
- (id) transformedValueFromOriginalValue:(id)originalValue;

@end
