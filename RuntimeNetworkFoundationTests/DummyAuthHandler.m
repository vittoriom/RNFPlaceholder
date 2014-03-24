//
//  DummyAuthHandler.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 24/03/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "DummyAuthHandler.h"

@implementation DummyAuthHandler

- (NSURLCredential *) credentialObject
{
    return [NSURLCredential credentialWithUser:@"admin" password:@"admin" persistence:NSURLCredentialPersistenceForSession];
}

@end
