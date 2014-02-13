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
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    RNFEndpointManager *manager = [RNFEndpointManager new];
    RNFEndpoint *endpoint = [[RNFEndpoint alloc] initWithName:@"runtimeTest"];
    
    [manager addEndpoint:endpoint];
    
    [endpoint getAnswersWithMaxResults:@10
                       completionBlock:^(id response, id<RNFOperation> operation, NSUInteger statusCode) {
                           NSLog(@"JSON Response: %@",[NSJSONSerialization JSONObjectWithData:response
																					  options:NSJSONReadingAllowFragments
																						error:nil]);
                           NSLog(@"Operation was: %@",operation);
                       }];
    
    return YES;
}

@end