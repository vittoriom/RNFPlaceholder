//
//  NSArray+RNFSerializable.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 16/03/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "NSArray+RNFSerializable.h"
#import "NSObject+RNFSerializable.h"

@implementation NSArray (RNFSerializable)

- (BOOL) isSerializable
{
    for (NSObject *element in self)
    {
        if (![element isSerializable])
        {
            return NO;
        }
    }
    
    return YES;
}

- (NSString *) serialize
{
    NSMutableArray *serializedElements = [NSMutableArray array];
    
    for (NSObject *element in self)
    {
        NSString *serializedElement = [(id<RNFSerializable>)element serialize];
        if ([element isKindOfClass:[NSString class]])
        {
            serializedElement = [NSString stringWithFormat:@"\"%@\"",serializedElement];
        }
        [serializedElements addObject:serializedElement];
    }
    
    return [NSString stringWithFormat:@"[%@]", [serializedElements componentsJoinedByString:@","]];
}

@end
