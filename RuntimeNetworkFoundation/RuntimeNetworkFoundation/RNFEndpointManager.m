//
//  RNFEndpointManager.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 09/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "RNFEndpointManager.h"
#import "RNFEndpoint.h"

@interface RNFEndpointManager ()

@property (nonatomic, strong) NSMutableDictionary *endpoints;

@end

@implementation RNFEndpointManager

#pragma mark - Initialization

+ (instancetype) sharedManager
{
    static RNFEndpointManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[RNFEndpointManager alloc] init];
    });
    
    return manager;
}

- (id) init
{
    self = [super init];
    
    if(self)
    {
        _endpoints = [NSMutableDictionary new];
    }
    
    return self;
}

#pragma mark - Managing endpoints

- (BOOL) addEndpoint:(RNFEndpoint *)endpoint
{
    NSString *endpointName = endpoint.name;
    if(!endpointName || [self.endpoints objectForKey:endpointName])
    {
        return NO;
    }
    
    self.endpoints[endpointName] = endpoint;
    return YES;
}

- (RNFEndpoint *) endpointWithName:(NSString *)name
{
    return [self.endpoints objectForKey:name];
}

@end
