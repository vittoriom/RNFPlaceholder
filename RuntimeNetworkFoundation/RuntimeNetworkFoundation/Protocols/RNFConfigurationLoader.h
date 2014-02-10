//
//  RNFConfigurationLoader.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 10/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RNFConfiguration;

@protocol RNFConfigurationLoader <NSObject>

- (id<RNFConfiguration>) endpointAttributes;

- (NSArray *) operations;

@optional

- (void) load;

+ (id<RNFConfigurationLoader>) RNFConfigurationLoaderForEndpointWithName:(NSString *)name;

@end
