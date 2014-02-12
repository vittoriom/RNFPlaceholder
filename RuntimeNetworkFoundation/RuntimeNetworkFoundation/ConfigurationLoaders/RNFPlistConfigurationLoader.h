//
//  RNFPlistConfigurationLoader.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 10/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNFConfigurationLoader.h"

@protocol RNFEndpointConfiguration;

@interface RNFPlistConfigurationLoader : NSObject <RNFConfigurationLoader>

/**
 *  Initializes a new instance of RNFPlistConfigurationLoader with a given plist
 *
 *  @param plistName the name of the plist file to load from the main bundle
 *
 *  @return a configured instance of RNFConfigurationLoader
 *
 *  @throws RNFConfigurationNotFound if the plist can't be found
 */
- (instancetype) initWithPlistName:(NSString *)plistName;

@end
