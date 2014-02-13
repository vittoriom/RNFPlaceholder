//
//  RNFEndpoint+test.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 12/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "RNFEndpoint.h"
#import "RNFTypes.h"

@interface RNFEndpoint (test)

- (id<RNFOperation>) getAnswersWithMaxResults:(NSNumber *)maxResults completionBlock:(RNFCompletionBlock)completion;

@end
