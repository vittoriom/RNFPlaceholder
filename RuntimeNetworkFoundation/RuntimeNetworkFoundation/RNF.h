//
//  RNF.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 09/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

//Protocols
#import "RNFCacheHandler.h"
#import "RNFDataDeserializer.h"
#import "RNFDataSerializer.h"
#import "RNFOperation.h"
#import "RNFOperationQueue.h"
#import "RNFRequestAuthentication.h"
#import "RNFResponseDeserializer.h"
#import "RNFSerializable.h"
#import "RNFEndpointConfiguration.h"
#import "RNFConfigurationLoader.h"
#import "RNFLogger.h"
#import "RNFEndpoint.h"
#import "RNFEndpointManager.h"
#import "RNFValueTransformer.h"
#import "RNFOperationSerializer.h"
#import "RNFOperationConfiguration.h"
#import "RNFResponseValidator.h"
#import <RNFCommons/RNFInitializableWithDictionary.h>
#import "RNFUserDefinedConfigurationParameters.h"
#import "RNFTypes.h"

//Categories
#import "NSMethodSignature+OperateOnSelectors.h"
#import "NSArray+RNFBlocks.h"
#import "NSCache+RNFCacheHandler.h"
#import "NSString+Additions.h"
#import "NSURL+Additions.h"
#import "NSValueTransformer+RNFValueTransformer.h"
#import "NSObject+RNFSerializable.h"

//Exceptions
#import "RNFConfigurationNotFound.h"
#import "RNFMalformedConfiguration.h"
#import "RNFParametersParserError.h"