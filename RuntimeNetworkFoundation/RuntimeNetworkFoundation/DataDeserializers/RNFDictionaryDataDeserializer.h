//
//  RNFDictionaryDataDeserializer.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 02/03/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNFDataDeserializer.h"
#import "RNFInitializableWithDictionary.h"

static const NSString * kRNFDictionaryDataDeserializerMappings = @"mappings";
static const NSString * kRNFDictionaryDataDeserializerTransforms = @"transforms";
static const NSString * kRNFDictionaryDataDeserializerTargetClass = @"targetClass";
static const NSString * kRNFDictionaryDataDeserializerOnlyDeserializedMappedKeys = @"skipNotMapped";
static const NSString * kRNFDictionaryDataDeserializerMapTo = @"mapResultTo";

@interface RNFDictionaryDataDeserializer : NSObject <RNFDataDeserializer, RNFInitializableWithDictionary>

@end
