//
//  NSURL+Additions.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 25/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "NSURL+Additions.h"

@implementation NSURL (Additions)

- (NSURL *) URLByAppendingQueryStringParameters:(NSDictionary *)parameters
{
    if (!parameters || [parameters allKeys].count == 0)
    {
        return self;
    }
    
    NSMutableArray *params = [NSMutableArray new];
    
    for (NSString *key in parameters.allKeys)
    {
        [params addObject:[NSString stringWithFormat:@"%@=%@",key,parameters[key]]];
    }
    
    NSString *URLString = [[NSString alloc] initWithFormat:@"%@%@%@", [self absoluteString],
                           [self query] ? @"&" : @"?", [params componentsJoinedByString:@"&"]];
    NSURL *theURL = [NSURL URLWithString:URLString];
    
    return theURL;
}

@end
