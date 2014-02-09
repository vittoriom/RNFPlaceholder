//
// Created by Vittorio Monaco on 09/02/14.
// Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RNFResponseDeserializer <NSObject>

- (id) deserializeResponse:(NSData *)response;

@end