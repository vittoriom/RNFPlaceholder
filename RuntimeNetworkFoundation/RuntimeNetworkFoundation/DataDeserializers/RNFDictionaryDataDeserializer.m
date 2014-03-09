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
@property (nonatomic, strong) NSString *mapResultTo;

@end

@implementation RNFDictionaryDataDeserializer

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
    self = [self init];
    
    _mappings = [dict objectForKey:kRNFDictionaryDataDeserializerMappings];
    
    _transforms = [dict objectForKey:kRNFDictionaryDataDeserializerTransforms]; //TODO Add sanity checks afterwards
    
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
        
        if ([mapTo isKindOfClass:[NSDictionary class]])
        {
            //Process nested deserialization
            id<RNFDataDeserializer> deserializer = [RNFDictionaryConfigurationHelper objectConformToProtocol:@protocol(RNFDataDeserializer) forKey:mapFrom inDictionary:self.mappings];
            intermediateResult = [deserializer deserializeData:intermediateResult];
            if ([deserializer isKindOfClass:[RNFDictionaryDataDeserializer class]] && [(RNFDictionaryDataDeserializer *)deserializer mapResultTo]) {
                [toProcess setObject:intermediateResult forKey:[(RNFDictionaryDataDeserializer *)deserializer mapResultTo]];
            } else
            {
                [toProcess setObject:intermediateResult forKey:mapFrom];
            }
        } else
        {
            [toProcess setObject:intermediateResult forKey:mapTo];
        }
        
        if ([toProcess objectForKey:mapFrom] && ![mapTo isKindOfClass:[NSDictionary class]] && ![mapFrom isEqualToString:mapTo])
            [toProcess removeObjectForKey:mapFrom];
    }];
}

- (id) deserializeData:(id)sourceData
{
    id toProcess = [self objectForData:sourceData copied:!self.onlyDeserializeMappedKeys];
    
    if ([sourceData isKindOfClass:[NSDictionary class]])
    {
        [self applyMappings:self.mappings onObject:sourceData appendTo:toProcess];
    } else if([sourceData isKindOfClass:[NSArray class]])
    {
        for (id item in sourceData)
        {
            id itemToProcess = [self objectForData:item copied:!self.onlyDeserializeMappedKeys];
            [self applyMappings:self.mappings onObject:item appendTo:itemToProcess];
            if ([toProcess containsObject:item])
            {
                [toProcess replaceObjectAtIndex:[toProcess indexOfObject:item] withObject:itemToProcess];
            } else
            {
                [toProcess addObject:itemToProcess];
            }
        }
    }
    
    //Process transforms here
    //...
    
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
