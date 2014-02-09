//
//  RNF.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 09/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#ifndef RuntimeNetworkFoundation_RNF_h
#define RuntimeNetworkFoundation_RNF_h

#import <Foundation/Foundation.h>

typedef void(^RNFCompletionBlockGeneric)(id response, ...);

typedef void(^RNFCompletionBlock)(id response, NSError *error, NSUInteger statusCode);

typedef void(^RNFCompletionBlockComplete)(id response, NSError *error, BOOL cached, NSUInteger statusCode, NSURLResponse *originalResponse);

#endif
