//
//  RNFPlistConfigurationLoader.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 10/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "RNFPlistConfigurationLoader.h"
#import "RNFEndpointConfiguration.h"
#import "RNFConfigurationNotFound.h"
#import "RNFDictionaryEndpointConfiguration.h"

@interface RNFPlistConfigurationLoader ()

@property (nonatomic, strong) id<RNFEndpointConfiguration> configuration;

@end

@implementation RNFPlistConfigurationLoader

- (instancetype) initWithPlistName:(NSString *)plistName
{
    self = [self init];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    
    if(!filePath)
        @throw [[RNFConfigurationNotFound alloc] initWithName:NSStringFromClass([RNFConfigurationNotFound class])
                                                       reason: [NSString stringWithFormat:NSLocalizedString(@"No plist configuration has been found for plist file with name %@", @""), plistName]
                                                     userInfo:nil];
    //Read the plist
    NSDictionary *plistContents = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    
    _configuration = [[RNFDictionaryEndpointConfiguration alloc] initWithDictionary:plistContents];
    
    return self;
}

+ (id<RNFConfigurationLoader>) RNFConfigurationLoaderForEndpointWithName:(NSString *)name
{
    return [[RNFPlistConfigurationLoader alloc] initWithPlistName:name];
}

- (id<RNFEndpointConfiguration>) endpointAttributes
{
    return self.configuration;
}

@end
