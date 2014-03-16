//
//  RNFURLValueTransformer.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 09/03/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "RNFURLValueTransformer.h"

@implementation RNFURLValueTransformer

- (id) transformedValue:(id)originalValue
{
    if ([originalValue isKindOfClass:[NSString class]])
    {
        return [NSURL URLWithString:originalValue];
    } else
    {
        NSLog(@"<%@> Cannot transform %@, it's not a NSString",NSStringFromClass([self class]),originalValue);
        return originalValue;
    }
}

@end
