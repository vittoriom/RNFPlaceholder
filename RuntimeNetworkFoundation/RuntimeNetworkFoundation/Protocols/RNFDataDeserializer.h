//
// Created by Vittorio Monaco on 09/02/14.
// Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RNFDataDeserializer <NSObject>

/**
 *  This method asks the data deserializer to deserialize a given response, based on its internal parameters.
 *  For example, a dictionary-backed data deserializer could have mappings, transforms and a target class already set with the RNFInitializableWithDictionary protocol. A custom deserializer unique for a given operation, on the other hand, wouldn't need any additional information other than the response object itself
 *
 *  @param sourceData The response object, usually a dictionary, or a raw NSData object
 *
 *  @return The deserialized object, usually a model instance
 */
- (id) deserializeData:(id)sourceData;

@end