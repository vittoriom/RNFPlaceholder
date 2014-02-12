//
//  RNFTypes.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 12/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#ifndef RuntimeNetworkFoundation_RNFTypes_h
#define RuntimeNetworkFoundation_RNFTypes_h

@protocol RNFOperation;

typedef void(^RNFCompletionBlockGeneric)(id response, ...);

typedef void(^RNFCompletionBlock)(id response, id<RNFOperation> operation, NSUInteger statusCode);

typedef void(^RNFCompletionBlockComplete)(id response, id<RNFOperation> operation, NSUInteger statusCode, BOOL cached, NSURLResponse *originalResponse);

typedef void(^RNFErrorBlock)(id response, NSError *error, NSUInteger statusCode);

#endif