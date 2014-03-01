//
//  RNFDictionaryUserDefinedParameters.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 01/03/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "RNFDictionaryUserDefinedParameters.h"

@interface RNFDictionaryUserDefinedParameters ()

@property (nonatomic, strong) NSMutableDictionary *internalDictionary;

@end

@implementation RNFDictionaryUserDefinedParameters

- (instancetype) initWithDictionary:(NSDictionary *)startingDictionary
{
    self = [super init];
    
    _internalDictionary = [startingDictionary mutableCopy];
    
    return self;
}

- (instancetype) init
{
    self = [super init];
    
    _internalDictionary = [NSMutableDictionary new];
    
    return self;
}

- (id) valueForUserDefinedParameter:(NSString *)key
{
    return [self.internalDictionary objectForKey:key];
}

- (void) setValue:(id)value forUserDefinedParameter:(NSString *)key
{
    [self.internalDictionary setObject:value forKey:key];
}

@end
