//
// Created by Vittorio Monaco on 09/02/14.
// Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RNFDataDeserializer <NSObject>

@optional

- (NSDictionary *) mappings;

- (NSDictionary *) transforms;

- (Class) targetClass;

- (id) deserializeData:(id)sourceData;

- (id) deserializeData:(id)sourceData
          usingMapping:(NSDictionary *)mapping
            transforms:(NSDictionary *)transforms
             intoClass:(Class)targetClass;

@end