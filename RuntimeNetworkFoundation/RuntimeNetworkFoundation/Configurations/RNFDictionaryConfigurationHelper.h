//
//  RNFDictionaryConfigurationHelper.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 01/03/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  This class is mainly meant to be used internally, not subclassed and not used by external classes.
 *  If you want to subclass RNFDictionary{Endpoint,Operation}Configuration, anyway, you may find it handy
 */
@interface RNFDictionaryConfigurationHelper : NSObject

/**
 *  Handy method to perform a sanity check and retrieve a valid object from a configuration dictionary given a key and a protocol you want the object to conform to
 *
 *  @param protocol                The protocol the object should conform to, to be valid
 *  @param key                     The key to lookup in the dictionary
 *  @param configurationDictionary The reference configuration dictionary
 *
 *  @return If configurationDictionary[key] is a string, this method returns an instance of the class returned by classFromKey:inDictionary: only if the given Class conforms to the protocol passed as a parameter. Otherwise it throws a RNFMalformedConfiguration;
     If configurationDictionary[key] is a dictionary itself, this method returns an instance of the class specified in configurationDictionary[key][@"objectClass"], initialized with the remaining key-value pairs, only if the given Class conforms to RNFInitializableWithDictionary, and the resulting object conforms to the given protocol. If one of these two requirements is not met, RNFMalformedConfiguration is thrown. An exception is also thrown if configurationDictionary[key][@"objectClass"] is not specified or it doesn't represent a valid Class.
 *
 *  @throws RNFMalformedConfiguration in one of the cases described above, listed below:
 *  1) If configurationDictionary[key] is a string but the class it represents doesn't conform to the given protocol
 *  2) If configurationDictionary[key] is a dictionary, but configurationDictionary[key][@"objectClass"] represents a Class that doesn't conform to the given protocol
 *  3) If configurationDictionary[key] is a dictionary, but configurationDictionary[key][@"objectClass"] represents a Class that doesn't conform to RNFInitializableWithDictionary, and so it can't be initialized
 *  4) If configurationDictionary[key] is a dictionary, but configurationDictionary[key][@"objectClass"] is not speified or it is not a Class
 */
+ (id) objectConformToProtocol:(Protocol *)protocol forKey:(const NSString *)key inDictionary:(NSDictionary *)configurationDictionary;

/**
 *  Given a configuration dictionary, this method returns the Class represented by the value for the given key
 *
 *  @param key                     The key to lookup in the dictionary
 *  @param configurationDictionary The configuration dictionary to lookup into
 *
 *  @return The Class represented by configurationDictionary[key]
 */
+ (Class) classFromKey:(const NSString *)key inDictionary:(NSDictionary *)configurationDictionary;

/**
 *  Converts a NSDictionary instance into a NSData object
 *
 *  @param dictionary The dictionary to convert
 *
 *  @return The NSData instance containing the UTF8 representation in the form of key=value&key2=value2 of the dictionary
 */
+ (NSData *) dictionaryToData:(NSDictionary *)dictionary;

@end
