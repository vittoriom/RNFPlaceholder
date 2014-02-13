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

//http://api.stackexchange.com/2.2/answers?pagesize=10&order=desc&sort=votes&site=stackoverflow
- (void) getAnswersWithMaxResults:(NSNumber *)maxResults completionBlock:(void(^)(id response, id<RNFOperation> operation, NSUInteger statusCode))completion;

@end
