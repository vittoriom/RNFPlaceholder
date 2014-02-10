//
//  RNFPlistConfigurationLoader.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 10/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "RNFPlistConfigurationLoader.h"
#import "RNFConfiguration.h"
#import "RNFDictionaryConfiguration.h"

@implementation RNFPlistConfigurationLoader

- (NSArray *) operations
{
    return @[];
}

- (id) initWithPlistName:(NSString *)plistName
{
    self = [self init];
    
    return self;
}

+ (id<RNFConfigurationLoader>) RNFConfigurationLoaderForEndpointWithName:(NSString *)name
{
    return [[RNFPlistConfigurationLoader alloc] initWithPlistName:name];
}

- (id<RNFConfiguration>) endpointAttributes
{
    return [[RNFDictionaryConfiguration alloc] init];
}

@end
