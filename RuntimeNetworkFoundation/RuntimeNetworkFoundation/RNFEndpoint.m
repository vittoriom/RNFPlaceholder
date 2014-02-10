//
//  RNFEndpoint.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 09/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "RNFEndpoint.h"
#import "RNFOperationQueue.h"
#import "RNFResponseDeserializer.h"
#import "RNFOperation.h"
#import "RNFCacheHandler.h"
#import "RNFConfigurationLoader.h"
#import "RNFLogger.h"

@interface RNFEndpoint ()

@property (nonatomic, strong) Class<RNFOperation> operationClass;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSURL *baseURL;
@property (nonatomic, strong) NSDictionary *headers;
@property (nonatomic, strong) id<RNFResponseDeserializer> responseDeserializer;
@property (nonatomic, strong) id<RNFOperationQueue> networkQueue;
@property (nonatomic, strong) id<RNFCacheHandler> cacheHandler;
@property (nonatomic, assign) BOOL cacheResults;
@property (nonatomic, strong) NSArray *operations;
@property (nonatomic, strong) id<RNFConfigurationLoader> configurator;
@property (nonatomic, weak) id<RNFLogger> logger;

@end

@implementation RNFEndpoint

@dynamic operationClass;
//@dynamic name;
@dynamic baseURL;
@dynamic headers;
@dynamic cacheResults;

+ (BOOL) resolveInstanceMethod:(SEL)sel
{
    //1. Do we have a cached configuration already? If yes, get the name from there
    //1.1 If not, try to load the configuration
    //1.1.1 If loading fails, return NO
    //1.1.2 Cache the configuration
    
    //2. If the configuration doesn't contain the method, return NO
    
    //3. Create a IMP block with the following steps:
    
        //1. Create the RNFOperation with the given configuration
    
        //2. If the cacheHandler has a cached response already, start calling the given completion block
    
        //3. Serialize the parameters based on the configuration
    
        //4. Enqueue the RNFOperation in the RNFOperationQueue
    
        //5. Setup the completion block.
        //5.1 If error is not nil, call the given completion block
        //5.2 If error is nil, deserialize the response with the responseDeserializer
        //5.3 If the RNFOperation has a dataDeserializer, deserialize the response
        //5.4 Call the given completion block
        //5.5 Eventually cache the response with the cacheHandler
    
    //4. Add the IMP block as an instance selector to the self class
    
    //5. Return YES
    return YES;
}

@end
