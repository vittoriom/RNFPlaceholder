//
// Created by Vittorio Monaco on 09/02/14.
// Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RNFResponseDeserializer <NSObject>

/**
 *  This method will be called when the network request completes
 *  This method is also called if cached data is available for the operation
 *
 *  @param response The NSData to deserialize
 *
 *  @return The deserialized object
 */
- (id) deserializeResponse:(NSData *)response;

@end