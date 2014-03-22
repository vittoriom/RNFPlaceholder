//
//  NSString+Additions.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 25/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

- (NSString *) URLStringByAppendingQueryStringParameters:(NSDictionary *)parameters
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
    
    return [NSString stringWithFormat:@"%@%@%@", self,
            [self rangeOfString:@"?"].location != NSNotFound ? @"&" : @"?", [params componentsJoinedByString:@"&"]];
}

- (NSString *) URLEncodedString
{
	return (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                               (CFStringRef)self,
                                                               NULL,
                                                               (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                               CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
}

@end
