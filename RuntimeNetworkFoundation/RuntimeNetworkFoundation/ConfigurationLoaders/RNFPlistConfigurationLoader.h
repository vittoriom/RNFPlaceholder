//
//  RNFPlistConfigurationLoader.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 10/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNFConfigurationLoader.h"

@protocol RNFConfiguration;

@interface RNFPlistConfigurationLoader : NSObject <RNFConfigurationLoader>

- (id) initWithPlistName:(NSString *)plistName;

@end
