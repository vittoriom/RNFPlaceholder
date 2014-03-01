//
//  RNFDictionaryUserDefinedParameters.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 01/03/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNFUserDefinedConfigurationParameters.h"

@interface RNFDictionaryUserDefinedParameters : NSObject <RNFUserDefinedConfigurationParameters>

/**
 *  Initializes a simple dictionary-based user-defined parameters handler through a dictionary of existing user-defined key-value pairs
 *
 *  @param startingDictionary The dictionary to be used as a starting point for user-defined key-value pairs
 *
 *  @return A initialized instance of RNFDictionaryUserDefinedParameters
 */
- (instancetype) initWithDictionary:(NSDictionary *)startingDictionary;

@end
