//
//  RNFResponseValidator.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 27/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNFOperation.h"

@protocol RNFResponseValidator <NSObject>

/**
 *  Asks the validator if a given deserializer response (for example a JSON Dictionary) is valid, according to its own rules
 *
 *  @param deserializedResponse The deserialized object
 *  @param operation            The operation
 *  @param statusCode           The HTTP status code
 *
 *  @return nil if the response is valid and should be further processed, a valid NSError object if the call should fallback to the failing block
 */
- (NSError *) responseIsValid:(id)deserializedResponse forOperation:(id<RNFOperation>)operation withStatusCode:(NSInteger)statusCode;

@end
