//
//  AFHTTPRequestOperation+RNFOperation.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 23/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#if defined(__has_include)
#if __has_include(<AFNetworking/AFHTTPRequestOperation.h>)
#import <AFNetworking/AFHTTPRequestOperation.h>
#import "RNFOperation.h"

@interface AFHTTPRequestOperation (RNFOperation) <RNFOperation>

@end

#endif
#endif
