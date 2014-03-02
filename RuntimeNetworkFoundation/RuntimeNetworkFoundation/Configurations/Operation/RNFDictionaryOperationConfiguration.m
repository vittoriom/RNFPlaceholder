//
//  RNFDictionaryOperationConfiguration.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 13/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "RNFDictionaryOperationConfiguration.h"
#import "RNFMalformedConfiguration.h"
#import "RNFInitializableWithDictionary.h"
#import "RNFDictionaryConfigurationHelper.h"

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
    
    return [RNFDictionaryConfigurationHelper dictionaryToData:bodyDictionary];
}

- (id<RNFDataDeserializer>) dataDeserializer
{
    id dataDeserializer = [RNFDictionaryConfigurationHelper objectConformToProtocol:@protocol(RNFDataDeserializer)
                                                                             forKey:kRNFConfigurationOperationDataDeserializer
                                                                       inDictionary:self.internalDictionary];
    return dataDeserializer ?: [super dataDeserializer];
}

- (id<RNFResponseValidator>) responseValidator
{
    id responseValidator = [RNFDictionaryConfigurationHelper objectConformToProtocol:@protocol(RNFResponseValidator)
                                                                              forKey:kRNFConfigurationOperationResponseValidator
                                                                        inDictionary:self.internalDictionary];
    return responseValidator;
}

- (id<RNFDataSerializer>) dataSerializer
{
    id dataSerializer = [RNFDictionaryConfigurationHelper objectConformToProtocol:@protocol(RNFDataSerializer)
                                                                           forKey:kRNFConfigurationOperationDataSerializer
                                                                     inDictionary:self.internalDictionary];
    return dataSerializer ?: [super dataSerializer];
}

- (id<RNFResponseDeserializer>) responseDeserializer
{
    id responseDeserializer = [RNFDictionaryConfigurationHelper objectConformToProtocol:@protocol(RNFResponseDeserializer)
                                                                                 forKey:kRNFConfigurationOperationResponseDeserializer
                                                                           inDictionary:self.internalDictionary];
    return responseDeserializer;
}

- (Class<RNFOperation>) operationClass
{
    return [RNFDictionaryConfigurationHelper classFromKey:kRNFConfigurationOperationOperationClass
                                             inDictionary:self.internalDictionary];
}

- (BOOL) cacheResults
{
    if([self.internalDictionary objectForKey:kRNFConfigurationOperationShouldCacheResults])
        return [[self.internalDictionary objectForKey:kRNFConfigurationOperationShouldCacheResults] boolValue];
    else
        return YES;
}

- (NSDictionary *) headers
{
    return [self.internalDictionary objectForKey:kRNFConfigurationOperationHeaders];
}

@end
