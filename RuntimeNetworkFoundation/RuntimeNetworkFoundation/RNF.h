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

#import "RNFCacheHandler.h"
#import "RNFCacheStrategy.h"
#import "RNFDataDeserializer.h"
#import "RNFDataSerializer.h"
#import "RNFOperation.h"
#import "RNFOperationQueue.h"
#import "RNFRequestAuthentication.h"
#import "RNFResponseDeserializer.h"
#import "RNFSerializable.h"
#import "RNFConfiguration.h"
#import "RNFConfigurationLoader.h"
#import "RNFLogger.h"
#import "RNFEndpoint.h"
#import "RNFEndpointManager.h"

//Exceptions
#import "RNFConfigurationNotFound.h"