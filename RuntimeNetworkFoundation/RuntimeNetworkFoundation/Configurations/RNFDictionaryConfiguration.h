//
//  RNFDictionaryConfiguration.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 10/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNFConfiguration.h"

@interface RNFDictionaryConfiguration : NSObject <RNFConfiguration>

- (instancetype) initWithDictionary:(NSDictionary *)dictionary;

@end
