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
    RNFEndpoint *endpoint = [[RNFEndpoint alloc] initWithName:@"sampleConfiguration"];
    
    [manager addEndpoint:endpoint];
    
    NSLog(@"Endpoint: %@, manager: %@",endpoint,manager);
    
    [endpoint getAnswersWithMaxResults:@10
                       completionBlock:^(id response, id<RNFOperation> operation, NSUInteger statusCode) {
                           NSLog(@"Raw response: %@ with status code: %d",response,statusCode);
//						   NSLog(@"Cached ? %@",cached ? @"YES":@"NO");
                           NSLog(@"Operation was: %@",operation);
                       }];
    
    return YES;
}

@end