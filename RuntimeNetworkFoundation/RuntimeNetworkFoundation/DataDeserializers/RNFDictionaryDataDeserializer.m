//
//  RNFDictionaryDataDeserializer.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 02/03/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "RNFDictionaryDataDeserializer.h"
#import "RNFDictionaryConfigurationHelper.h"
#import "RNFValueTransformer.h"
#import "RNFMalformedConfiguration.h"

@interface RNFDictionaryDataDeserializer ()

@property (nonatomic, strong) NSDictionary *mappings;
@property (nonatomic, strong) Class targetClass;
@property (nonatomic, strong) NSDictionary *transforms;
@property (nonatomic, assign) BOOL onlyDeserializeMappedKeys;
@property (nonatomic, strong) NSString *mapResultTo;

@end

@implementation RNFDictionaryDataDeserializer

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
    self = [self init];
    
    _mappings = [dict objectForKey:kRNFDictionaryDataDeserializerMappings];
    
    _transforms = [dict objectForKey:kRNFDictionaryDataDeserializerTransforms];
    
    NSString *tClass = [dict objectForKey:kRNFDictionaryDataDeserializerTargetClass];
    _targetClass = tClass ? NSClassFromString(tClass) : nil;
    
    _mapResultTo = [dict objectForKey:kRNFDictionaryDataDeserializerMapTo];
    
    _onlyDeserializeMappedKeys = [[dict objectForKey:kRNFDictionaryDataDeserializerOnlyDeserializedMappedKeys] boolValue];
    
    return self;
}

- (id) objectForData:(id)sourceData copied:(BOOL)copyOriginal
{
    id toProcess = nil;
    if(copyOriginal)
        toProcess =[sourceData mutableCopy];
    else
    {
        if ([sourceData isKindOfClass:[NSDictionary class]])
        {
            toProcess = [NSMutableDictionary new];
        } else if([sourceData isKindOfClass:[NSArray class]])
        {
            toProcess = [NSMutableArray array];
        } else
        {
            toProcess = [[sourceData class] new];
        }
    }
    
    return toProcess;
}

- (void) applyMappings:(NSDictionary *)mappings onObject:(id)sourceData appendTo:(id)toProcess
{
    [mappings enumerateKeysAndObjectsUsingBlock:^(id mapFrom, id mapTo, BOOL *stop) {
        id intermediateResult = [sourceData objectForKey:mapFrom];
        
        if ([toProcess objectForKey:mapFrom])
            [toProcess removeObjectForKey:mapFrom];
        
        if ([mapTo isKindOfClass:[NSDictionary class]])
        {
            //Process nested deserialization
            id<RNFDataDeserializer> deserializer = [RNFDictionaryConfigurationHelper objectConformToProtocol:@protocol(RNFDataDeserializer) forKey:mapFrom inDictionary:mappings];
            intermediateResult = [deserializer deserializeData:intermediateResult];
            if ([deserializer isKindOfClass:[RNFDictionaryDataDeserializer class]] && [(RNFDictionaryDataDeserializer *)deserializer mapResultTo])
            {
                [toProcess setObject:intermediateResult forKey:[(RNFDictionaryDataDeserializer *)deserializer mapResultTo]];
            } else
            {
                [toProcess setObject:intermediateResult forKey:mapFrom];
            }
        } else
        {
            [toProcess setObject:intermediateResult forKey:mapTo];
        }
    }];
}

- (void) applyTransforms:(NSDictionary *)transforms onObject:(id)sourceData appendTo:(id)toProcess
{
    [transforms enumerateKeysAndObjectsUsingBlock:^(id transformFrom, id transformTo, BOOL *stop) {
        id intermediateResult = [sourceData objectForKey:transformFrom];
        
        if ([toProcess objectForKey:transformFrom] && ![transformTo isKindOfClass:[NSDictionary class]])
            [toProcess removeObjectForKey:transformFrom];
        
        if ([transformTo isKindOfClass:[NSString class]])
        {
            id<RNFValueTransformer> transformer = [RNFDictionaryConfigurationHelper objectConformToProtocol:@protocol(RNFValueTransformer) forKey:transformFrom inDictionary:transforms];
            intermediateResult = [transformer transformedValue:intermediateResult];
        } else if([transformTo isKindOfClass:[NSDictionary class]])
        {
            id<RNFValueTransformer> transformer = [RNFDictionaryConfigurationHelper objectConformToProtocol:@protocol(RNFValueTransformer) forKey:transformFrom inDictionary:transforms];
            intermediateResult = [transformer transformedValue:intermediateResult];
        } else {
            @throw [[RNFMalformedConfiguration alloc] initWithName:NSStringFromClass([RNFMalformedConfiguration class])
                                                            reason:[NSString stringWithFormat:@"Value %@ for transform %@ is not a known value transformer format",transformTo,transformFrom]
                                                          userInfo:nil];
        }
        
        [toProcess setObject:intermediateResult forKey:transformFrom];
    }];
}

- (id) deserializeData:(id)sourceData
{
    id toProcess = [self objectForData:sourceData copied:!self.onlyDeserializeMappedKeys];
    
    if ([sourceData isKindOfClass:[NSDictionary class]])
    {
        [self applyMappings:self.mappings onObject:sourceData appendTo:toProcess];
        [self applyTransforms:self.transforms onObject:toProcess appendTo:toProcess];
    } else if([sourceData isKindOfClass:[NSArray class]])
    {
        for (id item in sourceData)
        {
            id itemToProcess = [self objectForData:item copied:!self.onlyDeserializeMappedKeys];
            [self applyMappings:self.mappings onObject:item appendTo:itemToProcess];
            [self applyTransforms:self.transforms onObject:itemToProcess appendTo:itemToProcess];
            
            if ([toProcess containsObject:item])
            {
                [toProcess replaceObjectAtIndex:[toProcess indexOfObject:item] withObject:itemToProcess];
            } else
            {
                [toProcess addObject:itemToProcess];
            }
        }
    }
    
    id result = nil;
    
    if(self.targetClass)
    {
        if ([self.targetClass conformsToProtocol:@protocol(RNFInitializableWithDictionary)])
        {
            if ([toProcess isKindOfClass:[NSDictionary class]])
            {
                result = [[self.targetClass alloc] initWithDictionary:toProcess];
            } else if([toProcess isKindOfClass:[NSArray class]])
            {
                result = [NSMutableArray array];
                for (id item in toProcess)
                {
                    id outputItem = [[self.targetClass alloc] initWithDictionary:item];
                    [result addObject:outputItem];
                }
            }
        } else
        {
            result = [self.targetClass new];
            if ([toProcess isKindOfClass:[NSDictionary class]])
            {
                [toProcess enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    [result setValue:obj forKey:key];
                }];
            } else if([toProcess isKindOfClass:[NSArray class]])
            {
                result = [NSMutableArray array];
                for (id item in toProcess)
                {
                    id outputItem = [self.targetClass new];
                    [item enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                        [outputItem setValue:obj forKey:key];
                    }];
                    [result addObject:outputItem];
                }
            }
        }
    } else
    {
        result = [toProcess copy];
    }
    
    return result;
}

@end
