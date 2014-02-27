//
//  RNFDictionaryOperationConfiguration.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 13/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "RNFDictionaryOperationConfiguration.h"
#import "RNFMalformedConfiguration.h"

@interface RNFDictionaryOperationConfiguration ()

@property (nonatomic, strong) NSDictionary *internalDictionary;

@end

@implementation RNFDictionaryOperationConfiguration

#pragma mark - Initializers

- (instancetype) initWithDictionary:(NSDictionary *)dictionary
{
    self = [self init];
    
    _internalDictionary = dictionary;
    
    [self performSanityCheckOnDictionary:dictionary];
    
    return self;
}

#pragma mark - Sanity checks

- (void) performSanityCheckOnDictionary:(NSDictionary *)dictionary
{
    NSString *errorMessage = nil;
    
    if (![dictionary objectForKey:kRNFConfigurationOperationName])
    {
        errorMessage = [NSString stringWithFormat:@"No %@ is configured for the operation", kRNFConfigurationOperationName];
    }
    else if(![dictionary objectForKey:kRNFConfigurationOperationURL])
    {
        errorMessage = [NSString stringWithFormat:@"No %@ is configured for the operation",kRNFConfigurationOperationURL];
    }
    
    if(errorMessage)
        @throw [[RNFMalformedConfiguration alloc] initWithName:NSStringFromClass([RNFMalformedConfiguration class])
                                                        reason:errorMessage
                                                      userInfo:nil];
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

- (NSData *) dictionaryToData:(NSDictionary *)dictionary
{
    NSArray *keys = [dictionary allKeys];
    NSMutableArray *keysAndValues = [NSMutableArray new];
    
    for (NSString *key in keys)
    {
        [keysAndValues addObject:[NSString stringWithFormat:@"%@=%@",key, dictionary[key]]];
    }
    
    NSString *finalString = [keysAndValues componentsJoinedByString:@"&"];
    
    return [finalString dataUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark - Getters

- (NSString *) name
{
    return [self.internalDictionary objectForKey:kRNFConfigurationOperationName];
}

- (NSString *) URL
{
    return [self.internalDictionary objectForKey:kRNFConfigurationOperationURL];
}

- (NSString *) HTTPMethod
{
    return [self.internalDictionary objectForKey:kRNFConfigurationOperationHTTPMethod] ?: [super HTTPMethod];
}

- (NSData *) HTTPBody
{
    NSDictionary *bodyDictionary = [self.internalDictionary objectForKey:kRNFConfigurationOperationHTTPBody];
    
    if(!bodyDictionary)
        return [super HTTPBody];
    
    return [self dictionaryToData:bodyDictionary];
}

- (id<RNFDataDeserializer>) dataDeserializer
{
    Class deserializerClass = [self classFromKey:kRNFConfigurationOperationDataDeserializer];
    if(deserializerClass)
        return [deserializerClass new];
    else
        return [super dataDeserializer];
}

- (Class<RNFResponseValidator>) responseValidator
{
    if ([self.internalDictionary objectForKey:kRNFConfigurationOperationResponseValidator])
        return [self classFromKey:kRNFConfigurationOperationResponseValidator];
    else
        return [super responseValidator];
}

- (id<RNFDataSerializer>) dataSerializer
{
    Class serializerClass = [self classFromKey:kRNFConfigurationOperationDataSerializer];
    if(serializerClass)
        return [serializerClass new];
    else
        return [super dataSerializer];
}

- (Class<RNFResponseDeserializer>) responseDeserializer
{
    Class deserializerClass = [self classFromKey:kRNFConfigurationOperationResponseDeserializer];
    return deserializerClass ?: [super responseDeserializer];
}

- (Class<RNFOperation>) operationClass
{
    Class operationClass = [self classFromKey:kRNFConfigurationOperationOperationClass];
    return operationClass ?: [super operationClass];
}

- (BOOL) cacheResults
{
    if([self.internalDictionary objectForKey:kRNFConfigurationOperationShouldCacheResults])
        return [[self.internalDictionary objectForKey:kRNFConfigurationOperationShouldCacheResults] boolValue];
    else
        return [super cacheResults];
}

- (NSDictionary *) headers
{
    return [self.internalDictionary objectForKey:kRNFConfigurationOperationHeaders] ?: [super headers];
}

@end
