//
//  RNFDictionaryConfiguration.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 10/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "RNFDictionaryConfiguration.h"

@interface RNFDictionaryConfiguration ()

@property (nonatomic, strong) NSDictionary *internalDictionary;

@end

@implementation RNFDictionaryConfiguration

- (instancetype) initWithDictionary:(NSDictionary *)dictionary
{
    self = [self init];
    
    _internalDictionary = dictionary;
    
    return self;
}

- (NSURL *) baseURL
{
    return [NSURL URLWithString:[self.internalDictionary objectForKey:@"baseURL"]];
}

- (NSArray *) operations
{
    return @[];
}

@end
