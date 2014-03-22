//
//  RNFStatusCodeResponseValidator.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 01/03/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNFResponseValidator.h"
#import "RNFInitializableWithDictionary.h"

static const NSString * kRNFStatusCodeResponseValidatorAcceptedCodes = @"accepted";
static const NSString * kRNFStatusCodeResponseValidatorRejectedCodes = @"rejected";
static const NSString * kRNFStatusCodeResponseValidatorAcceptIfNoneMatches = @"ifNone";

/**
 *  A response validator that can be configured through a list of accepted and rejected status codes, plus a policy to adopt when the status code is in neither set.
 *  The status codes can be specified as single values (e.g. 200) or as ranges (e.g. 200-204), and they can be NSStrings or NSNumbers. 
 *  The validator also conforms to RNFInitializableWithDictionary, so you can use the above keys and pass your configuration values to the initializer
 */
@interface RNFStatusCodeResponseValidator : NSObject <RNFResponseValidator, RNFInitializableWithDictionary>

@end
