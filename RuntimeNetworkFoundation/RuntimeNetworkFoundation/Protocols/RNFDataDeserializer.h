//
// Created by Vittorio Monaco on 09/02/14.
// Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RNFDataDeserializer <NSObject>

- (id) deserializeData:(NSDictionary *)sourceData
          usingMapping:(NSDictionary *)mapping
            transforms:(NSDictionary *)transforms
             intoClass:(Class)targetClass;

@end