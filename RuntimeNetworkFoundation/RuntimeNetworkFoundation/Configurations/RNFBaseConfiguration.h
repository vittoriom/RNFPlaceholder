//
//  RNFDefaultConfiguration.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 11/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNFConfiguration.h"

/**
 *  Provides default values for optional parameters in a configuration
 *  If you're providing your own RNFConfiguration implementation,
 *  please subclass this class
 */
@interface RNFBaseConfiguration : NSObject <RNFConfiguration>

@end
