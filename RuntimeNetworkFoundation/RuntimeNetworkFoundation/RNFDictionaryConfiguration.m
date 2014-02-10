//
//  RNFDictionaryConfiguration.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 10/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "RNFDictionaryConfiguration.h"

@implementation RNFDictionaryConfiguration

- (NSURL *) baseURL
{
    return [NSURL URLWithString:@"http://vittoriomonaco.it/api"];
}

- (NSArray *) operations
{
    return @[];
}

@end
