//
//  NSURL+RNFSerializable.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 16/03/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNFSerializable.h"

/**
 NSURL category that conforms to RNFSerializable. This lets you pass NSURL instances to runtime calls on RNFEndpoint objects, so that they can be successfully serialized.
 */
@interface NSURL (RNFSerializable) <RNFSerializable>

@end
