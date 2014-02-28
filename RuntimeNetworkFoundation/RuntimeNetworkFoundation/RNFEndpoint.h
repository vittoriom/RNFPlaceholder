//
//  RNFEndpoint.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 09/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RNFEndpointConfiguration;
@protocol RNFOperation;
@protocol RNFConfigurationLoader;

@interface RNFEndpoint : NSObject

/**
 *  The base URL of this endpoint instance
 */
- (NSURL *) baseURL;

/**
 *  A descriptive name for this endpoint instance
 */
- (NSString *) endpointName;

/**
 *
 *  @return The configuration of the endpoint
 */
- (id<RNFEndpointConfiguration>) configuration;

/**
 *  Creates a new RNFEndpoint instance with a given RNFConfigurationLoader
 *  This method adopts lazy loading of the configuration. 
 *  This means the RNFConfiguration is not actually loaded until the first method call comes to the instance
 *
 *  @param configurator The RNFConfigurationLoader instance used to load the RNFConfiguration
 *
 *  @return an RNFEndpoint instance
 */
- (id) initWithConfigurator:(id<RNFConfigurationLoader>)configurator;

/**
 *  Creates a new RNFEndpoint instance with a given name
 *  This method eagerly loads the RNFConfiguration, using a RNFPlistConfigurationLoader
 *  This means the method will create a new instance of RNFPlistConfigurationLoader with the given name, 
 *  throwing an exception if no configuration is found with the given name.
 *
 *  @param name The name of the configuration to load, using a RNFPlistConfigurationLoader
 *
 *  @return an RNFEndpoint instance
 *
 *  @throws RNFConfigurationNotFound if no plist configuration is found with the given name
 */
- (id) initWithName:(NSString *)name;

/**
 *  Executes a linear search into the operations array, looking for a RNFOperation with the given name
 *
 *  @param name The name of the operation to retrieve
 *
 *  @return an RNFOperation instance if found, nil otherwise
 */
- (id<RNFOperation>) operationWithName:(NSString *)name;

@end
