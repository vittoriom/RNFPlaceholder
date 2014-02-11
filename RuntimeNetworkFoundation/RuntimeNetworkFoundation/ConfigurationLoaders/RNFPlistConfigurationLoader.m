//
//  RNFPlistConfigurationLoader.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 10/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "RNFPlistConfigurationLoader.h"
#import "RNFConfiguration.h"
#import "RNFConfigurationNotFound.h"
#import "RNFDictionaryConfiguration.h"

@interface RNFPlistConfigurationLoader ()

@property (nonatomic, strong) id<RNFConfiguration> configuration;

@end

@implementation RNFPlistConfigurationLoader

- (NSArray *) operations
{
    return @[];
}

- (id) initWithPlistName:(NSString *)plistName
{
    self = [self init];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    
    if(!filePath)
        @throw [[RNFConfigurationNotFound alloc] initWithName:NSStringFromClass([RNFConfigurationNotFound class])
                                                       reason: [NSString stringWithFormat:NSLocalizedString(@"No plist configuration has been found for plist file with name %@", @""), plistName]
                                                     userInfo:nil];
    //Read the plist
    NSDictionary *plistContents = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    
    _configuration = [[RNFDictionaryConfiguration alloc] initWithDictionary:plistContents];
    
    return self;
}

+ (id<RNFConfigurationLoader>) RNFConfigurationLoaderForEndpointWithName:(NSString *)name
{
    return [[RNFPlistConfigurationLoader alloc] initWithPlistName:name];
}

- (id<RNFConfiguration>) endpointAttributes
{
    return self.configuration;
}

@end
