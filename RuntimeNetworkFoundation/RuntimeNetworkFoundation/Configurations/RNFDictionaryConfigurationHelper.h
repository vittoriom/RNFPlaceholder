//
//  RNFDictionaryConfigurationHelper.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 01/03/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RNFDictionaryConfigurationHelper : NSObject

+ (id) objectConformToProtocol:(Protocol *)protocol forKey:(const NSString *)key inDictionary:(NSDictionary *)configurationDictionary;

+ (Class) classFromKey:(const NSString *)key inDictionary:(NSDictionary *)configurationDictionary;

+ (NSData *) dictionaryToData:(NSDictionary *)dictionary;

@end
