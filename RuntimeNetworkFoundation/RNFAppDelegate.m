//
//  RNFAppDelegate.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 09/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "RNFAppDelegate.h"
#import "RNF.h"
#import "RNFEndpoint+test.h"

@implementation RNFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    RNFEndpointManager *manager = [RNFEndpointManager new];
    RNFEndpoint *endpoint = [[RNFEndpoint alloc] initWithName:@"runtimeTest"];
    
    [[endpoint.configuration userDefinedConfiguration] setValue:@"MyToken" forUserDefinedParameter:@"ACCESS_TOKEN"];
    
    [manager addEndpoint:endpoint];
    
    id<RNFOperation> createdOperation = [endpoint getAnswersWithMaxResults:@2
                       completionBlock:^(id response, id<RNFOperation> operation, NSUInteger statusCode, BOOL cached) {
                           NSLog(@"JSON Response: %@",response);
                           NSLog(@"Operation was: %@",operation);
                           NSLog(@"Cached: %d",cached);
                           NSLog(@"Status code: %d",statusCode);
                       } errorBlock:^(id response, NSError *error, NSUInteger statusCode) {
                           NSLog(@"Oops: %@",error);
                       }];
    
    NSLog(@"Operation is: %@",createdOperation);
    
    return YES;
}

@end