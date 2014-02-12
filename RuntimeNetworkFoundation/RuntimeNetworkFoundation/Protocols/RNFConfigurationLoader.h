//
//  RNFConfigurationLoader.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 10/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RNFEndpointConfiguration;

@protocol RNFConfigurationLoader <NSObject>

/**
 *
 *  @return The RNFConfiguration object representing the endpoint Attributes
 *  Please see the wiki for the complete list of mandatory and optional attributes for endpoints
 */
- (id<RNFEndpointConfiguration>) endpointAttributes;

@optional

/**
 *  Loads the configuration.
 *  This method is optional since some RNFConfigurationLoaders (e.g. RNFPlistConfigurationLoader)
 *  eagerly load the configuration as soon as they are initialized.
 *  If you are implementing a lazy loader, please also implement load.
 */
- (void) load;

/**
 *  Factory method to get a RNFConfigurationLoader instance
 *
 *  @param name the name of the endpoint you want to get the configuration for
 *
 *  @return a RNFConfigurationLoader instance based on the endpoint specified
 */
+ (id<RNFConfigurationLoader>) RNFConfigurationLoaderForEndpointWithName:(NSString *)name;

@end
