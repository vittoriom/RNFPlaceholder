//
//  RNFEndpoint.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 09/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RNFOperation;

@interface RNFEndpoint : NSObject

@property (nonatomic, readonly) NSURL *baseURL;
@property (nonatomic, readonly) NSString *name;

- (id) initWithConfiguration:(NSDictionary *)configuration;

- (id) initWithName:(NSString *)name;

- (id<RNFOperation>) operationWithName:(NSString *)name;

@end
