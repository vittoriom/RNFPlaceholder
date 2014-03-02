//
//  RNFDictionaryDataDeserializer.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 02/03/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "RNFDictionaryDataDeserializer.h"
#import "RNFDictionaryConfigurationHelper.h"

@interface RNFDictionaryDataDeserializer ()

@property (nonatomic, strong) NSDictionary *mappings;
@property (nonatomic, strong) Class targetClass;
@property (nonatomic, strong) NSDictionary *transforms; //Unused for now
@property (nonatomic, assign) BOOL onlyDeserializeMappedKeys;

@end

@implementation RNFDictionaryDataDeserializer

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
    self = [self init];
    
    _mappings = [dict objectForKey:kRNFDictionaryDataDeserializerMappings];
    
    _transforms = [dict objectForKey:kRNFDictionaryDataDeserializerTransforms]; //TODO Add sanity checks afterwards
    
    NSString *tClass = [dict objectForKey:kRNFDictionaryDataDeserializerTargetClass];
    _targetClass = tClass ? NSClassFromString(tClass) : nil;
    
    _onlyDeserializeMappedKeys = [[dict objectForKey:kRNFDictionaryDataDeserializerOnlyDeserializedMappedKeys] boolValue];
    
    return self;
}

- (id) deserializeData:(id)sourceData
{
    //TODO sourceData can be an array, too. In this case we should deserialize each object of the array
    
    NSMutableDictionary *toProcess = self.onlyDeserializeMappedKeys ? [NSMutableDictionary new] : [sourceData mutableCopy];
    
    [self.mappings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id intermediateResult = [sourceData objectForKey:key];
        
        if ([obj isKindOfClass:[NSDictionary class]])
        {
            //Process nested deserialization
            id<RNFDataDeserializer> deserializer = [RNFDictionaryConfigurationHelper objectConformToProtocol:@protocol(RNFDataDeserializer) forKey:key inDictionary:self.mappings];
            intermediateResult = [deserializer deserializeData:[sourceData objectForKey:key]];
            [toProcess setObject:intermediateResult forKey:key];
        } else
        {
            [toProcess setObject:intermediateResult forKey:obj];
        }
        
        if ([toProcess objectForKey:key] && ![obj isKindOfClass:[NSDictionary class]])
            [toProcess removeObjectForKey:key];
    }];
    
    //Process transforms here
    //...
    
    id result = nil;
    
    if(self.targetClass)
    {
        if ([self.targetClass conformsToProtocol:@protocol(RNFInitializableWithDictionary)])
        {
            result = [[self.targetClass alloc] initWithDictionary:toProcess];
        } else
        {
            result = [self.targetClass new];
            [toProcess enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                [result setValue:obj forKey:key];
            }];
        }
    } else
    {
        result = [toProcess copy];
    }
    
    return result;
}

@end
