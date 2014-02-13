//
//  RNFDictionaryOperationConfiguration.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 13/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "RNFDictionaryOperationConfiguration.h"

@interface RNFDictionaryOperationConfiguration ()

@property (nonatomic, strong) NSDictionary *internalDictionary;

@end

@implementation RNFDictionaryOperationConfiguration

#pragma mark - Initializers

- (instancetype) initWithDictionary:(NSDictionary *)dictionary
{
    self = [self init];
    
    _internalDictionary = dictionary;
    
    return self;
}

#pragma mark - Sanity checks

- (void) performSanityCheckOnDictionary:(NSDictionary *)dictionary
{
}

#pragma mark - Helpers

- (Class) classFromKey:(const NSString *)key
{
    NSString *className = [self.internalDictionary objectForKey:key];
    if (className)
    {
        Class result = NSClassFromString(className);
        return result;
    } else {
        return nil;
    }
}

#pragma mark - Getters

- (NSString *) runtimeMethodName
{
    return [self.internalDictionary objectForKey:kRNFConfigurationOperationRuntimeMethodName];
}

- (NSURL *) URL
{
    return [NSURL URLWithString:[self.internalDictionary objectForKey:kRNFConfigurationOperationURL]];
}

- (NSString *) HTTPMethod
{
    return [self.internalDictionary objectForKey:kRNFConfigurationOperationHTTPMethod] ?: [super HTTPMethod];
}

- (NSDictionary *) HTTPBody
{
    return [self.internalDictionary objectForKey:kRNFConfigurationOperationHTTPBody] ?: [super HTTPBody];
}

- (id<RNFDataDeserializer>) dataDeserializer
{
    Class deserializerClass = [self classFromKey:kRNFConfigurationOperationDataDeserializer];
    if(deserializerClass)
        return [deserializerClass new];
    else
        return [super dataDeserializer];
}

- (id<RNFDataSerializer>) dataSerializer
{
    Class serializerClass = [self classFromKey:kRNFConfigurationOperationDataSerializer];
    if(serializerClass)
        return [serializerClass new];
    else
        return [super dataSerializer];
}

- (id<RNFResponseDeserializer>) responseDeserializer
{
    Class deserializerClass = [self classFromKey:kRNFConfigurationOperationResponseDeserializer];
    if(deserializerClass)
        return [deserializerClass new];
    else
        return [super responseDeserializer];
}

@end
