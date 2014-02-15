//
//  RNFJSONResponseDeserializer.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 15/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "RNFJSONResponseDeserializer.h"

@implementation RNFJSONResponseDeserializer

- (id) deserializeResponse:(NSData *)response
{
    if(!response)
        return nil;
    
    NSError *error;
    id JSONObject = [NSJSONSerialization JSONObjectWithData:response
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    
    if(error)
        return nil;
    
    return JSONObject;
}

@end
