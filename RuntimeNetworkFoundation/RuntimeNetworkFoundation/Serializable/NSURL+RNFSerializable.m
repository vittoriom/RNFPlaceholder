//
//  NSURL+RNFSerializable.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 16/03/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "NSURL+RNFSerializable.h"

@implementation NSURL (RNFSerializable)

- (NSString *) serialize
{
    return self.absoluteString;
}

@end
