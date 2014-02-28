//
//  RNFParametersParser.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 15/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNFUserDefinedConfigurationParameters.h"

@interface RNFParametersParser : NSObject

/**
 *  Parses a string containing placeholders, e.g. "questions?tag={{0}}&format=json&token={ACCESS_TOKEN}"
 *
 *  @param source    the string to parse
 *  @param arguments the arguments to use to replace the placeholders
 *  @param provider  the provider for user-defined parameters
 *
 *  @return The parsed string, containing the right values instead of the placeholders
 */
- (NSString *) parseString:(NSString *)source withArguments:(NSArray *)arguments userDefinedParametersProvider:(id<RNFUserDefinedConfigurationParameters>)provider;


/**
 *  Parses a dictionary containing values with placeholders
 *
 *  @param source    the dictionary to parse
 *  @param arguments the arguments to use to replace the placeholders
 *  @param provider  the provider for user-defined parameters
 *
 *  @return The parsed dictionary, containing the right values instead of the placeholders
 */
- (NSDictionary *) parseDictionary:(NSDictionary *)source withArguments:(NSArray *)arguments userDefinedParametersProvider:(id<RNFUserDefinedConfigurationParameters>)provider;

@end
