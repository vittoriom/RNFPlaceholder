//
//  RNFDictionaryConfiguration.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 10/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNFConfiguration.h"

@interface RNFDictionaryConfiguration : NSObject <RNFConfiguration>

/**
 *  Initializes an instance of RNFConfiguration based on a backing NSDictionary with the given dictionary values
 *
 *  @param dictionary the given key-value pairs to use as a configuration source
 *
 *  @return the initialized RNFConfiguration
 * 
 *  @throws RNFMalformedConfiguration if the dictionary is missing mandatory keys
 */
- (instancetype) initWithDictionary:(NSDictionary *)dictionary;

@end
