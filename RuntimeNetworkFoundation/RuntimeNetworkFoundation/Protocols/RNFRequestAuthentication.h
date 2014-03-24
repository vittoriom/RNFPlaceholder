//
//  RNFRequestAuthentication.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 09/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RNFRequestAuthentication <NSObject>

/**
 *  Asks the authentication handler a NSURLCredential instance to handle a possible authentication challenge
 *
 *  @return The NSURLCredential with the username and password to use for the basic authentication
 */
- (NSURLCredential *) credentialObject;

@end
