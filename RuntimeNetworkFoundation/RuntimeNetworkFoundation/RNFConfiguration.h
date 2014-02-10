//
//  RNFConfiguration.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 10/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RNFOperation;
@protocol RNFResponseDeserializer;
@protocol RNFOperationQueue;
@protocol RNFCacheHandler;
@protocol RNFLogger;

@protocol RNFConfiguration <NSObject>

- (NSURL *) baseURL;

- (NSArray *) operations;

@optional

- (NSString *) name;

- (NSDictionary *) headers;

- (id<RNFResponseDeserializer>) deserializer;

- (Class<RNFOperation>) operationClass;

- (Class<RNFOperationQueue>) operationQueueClass;

- (BOOL) cacheResults;

- (id<RNFCacheHandler>) cacheClass;

- (id<RNFLogger>) logger;

@end
