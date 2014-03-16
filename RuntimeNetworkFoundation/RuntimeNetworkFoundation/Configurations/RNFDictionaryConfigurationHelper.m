//
//  RNFDictionaryConfigurationHelper.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 01/03/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "RNFDictionaryConfigurationHelper.h"
#import "RNFMalformedConfiguration.h"
#import <objc/runtime.h>
#import "RNFInitializableWithDictionary.h"

static const NSString * kRNFDictionaryOperationConfigurationCustomObjectClass = @"objectClass";

@implementation RNFDictionaryConfigurationHelper

#pragma mark - Helpers

+ (id) objectConformToProtocol:(Protocol *)protocol forKey:(const NSString *)key inDictionary:(NSDictionary *)configurationDictionary
{
    id object = [configurationDictionary objectForKey:key];
    
    if ([object isKindOfClass:[NSString class]])
    {
        Class customObjectClass = [self classFromKey:key inDictionary:configurationDictionary];
        if ([customObjectClass conformsToProtocol:protocol])
        {
            return [customObjectClass new];
        } else
        {
            @throw [[RNFMalformedConfiguration alloc] initWithName:NSStringFromClass([RNFMalformedConfiguration class])
                                                            reason:[NSString stringWithFormat:@"Class %@ doesn't conform to protocol %@ required for key %@",NSStringFromClass(customObjectClass),NSStringFromProtocol(protocol),key]
                                                          userInfo:nil];
        }
    }
    else if ([object isKindOfClass:[NSDictionary class]])
    {
        NSString *className = [object objectForKey:kRNFDictionaryOperationConfigurationCustomObjectClass];
        Class customObjectClass;
        if(className && (customObjectClass = NSClassFromString(className)))
        {
            if ([customObjectClass conformsToProtocol:@protocol(RNFInitializableWithDictionary)])
            {
                NSMutableDictionary *configuration = [object mutableCopy];
                [configuration removeObjectForKey:kRNFDictionaryOperationConfigurationCustomObjectClass];
                id result = [[customObjectClass alloc] initWithDictionary:configuration];
                if (![result conformsToProtocol:protocol])
                {
                    @throw [[RNFMalformedConfiguration alloc] initWithName:NSStringFromClass([RNFMalformedConfiguration class])
                                                                    reason:[NSString stringWithFormat:@"Class %@ doesn't conform to protocol %@ required for key %@",NSStringFromClass(customObjectClass),NSStringFromProtocol(protocol),key]
                                                                  userInfo:nil];
                }
                return result;
            } else
            {
                @throw [[RNFMalformedConfiguration alloc] initWithName:NSStringFromClass([RNFMalformedConfiguration class])
                                                                reason:[NSString stringWithFormat:@"Class %@ doesn't conform to RNFInitializableWithDictionary protocol",className]
                                                              userInfo:nil];
            }
        } else
            @throw [[RNFMalformedConfiguration alloc] initWithName:NSStringFromClass([RNFMalformedConfiguration class])
                                                            reason:[NSString stringWithFormat:@"class %@ specified for %@ is not specified or it doesn't exist, check dictionary %@",className,key,object]
                                                          userInfo:nil];
    } else
        return nil;
}

+ (Class) classFromKey:(const NSString *)key inDictionary:(NSDictionary *)configurationDictionary
{
    NSString *className = [configurationDictionary objectForKey:key];
    if (className)
    {
        Class result = NSClassFromString(className);
        return result;
    } else {
        return nil;
    }
}

+ (NSData *) dictionaryToData:(NSDictionary *)dictionary
{
    if(!dictionary)
        return nil;
    
    NSArray *keys = [dictionary allKeys];
    NSMutableArray *keysAndValues = [NSMutableArray new];
    
    for (NSString *key in keys)
    {
        [keysAndValues addObject:[NSString stringWithFormat:@"%@=%@",key, dictionary[key]]];
    }
    
    NSString *finalString = [keysAndValues componentsJoinedByString:@"&"];
    
    return [finalString dataUsingEncoding:NSUTF8StringEncoding];
}

@end
