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

@interface RNFStatusCodeResponseValidator : NSObject <RNFResponseValidator, RNFInitializableWithDictionary>

@end
