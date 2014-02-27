//
//  RNFInitializableWithDictionary.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 26/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RNFInitializableWithDictionary <NSObject>

/**
 *  Initializes a new instance of the object with the given NSDictionary
 *
 *  @param dict The dictionary containing the data needed to initialize the object. 
 *  for example, this could be fed by a RNFDataDeserializer, if the targetClass conforms to the protocol
 *
 *  @return A initialized instance of the object
 */
- (instancetype) initWithDictionary:(NSDictionary *)dict;

@end
