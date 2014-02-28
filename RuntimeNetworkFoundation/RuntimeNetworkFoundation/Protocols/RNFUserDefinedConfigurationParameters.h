//
//  RNFUserDefinedConfigurationParameters.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 28/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  By conforming to this protocol, you can provide runtime (or constant) values for given parameters that you can use in the endpoint/operations configuration, such as headers and queryString.
 */
@protocol RNFUserDefinedConfigurationParameters <NSObject>

/**
 *  A getter method to access the underlying configuration of user-defined parameters
 *
 *  @param key The user-defined parameter
 *
 *  @return The value for the specified key in the user-defined configuration
 */
- (id) valueForUserDefinedParameter:(NSString *)key;

/**
 *  A setter method to modify the user-defined parameters
 *
 *  @param value The value to set for a given key
 *  @param key   The key
 */
- (void) setValue:(id)value forUserDefinedParameter:(NSString *)key;

@end
