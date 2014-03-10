//
//  RNFEndpointManager.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 09/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RNFEndpoint;

@interface RNFEndpointManager : NSObject

/**
 Retrieve a specified endpoint from the RNFEndpointManager instance.
 This method should be used as a convenience method when a call to a particular endpoint is needed.
 Using this method lets you use the same RNFEndpoint instance for all the calls to one endpoint.
 In particular, by doing this the RNFEndpoint will use the same instance of RNFOperationQueue for enqueueing RNFOperations.
 You can also initialize the RNFEndpoint when you need it, but every time you will use a new instance of RNFOperationQueue,
 losing any benefit of a RNFOperationQueue.
 You can manage the RNFEndpoint yourself, too.
 
 @param the name of the endpoint to retrieve. 
 The name should be the same as the one contained in the endpoint configuration
 
 @return the given endpoint if found. nil otherwise
 */
- (RNFEndpoint *) endpointWithName:(NSString *)name;

/**
 Adds a RNFEndpoint to the list of the Endpoints managed by this RNFEndpointManager instance.
 
 @param the RNFEndpoint you want to manage
 
 @return YES if the endpoint has been successfully added
 NO if the endpoint is misconfigured, or if an RNFEndpoint with the same name already exists.
 */
- (BOOL) addEndpoint:(RNFEndpoint *)endpoint;

/**
 *  Convenience method to get the singleton RNFEndpointManager of your application
 *
 *  @return The shared RNFEndpointManager instance that manages all the endpoints
 */
+ (instancetype) sharedManager;

@end
