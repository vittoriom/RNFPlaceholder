//
//  RNFValueTransformer.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 11/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RNFValueTransformer <NSObject>

- (id) transformedValueForOriginalValue:(id)originalValue;

@end
