//
//  NSURL+Additions.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 25/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Additions)

/**
 *  Adds a dictionary of query string parameters to the URL
 *
 *  @param parameters the dictionary containing the parameters to include in the URL
 *
 *  @return the new NSURL with the parameters included
 */
- (NSURL *)URLByAppendingQueryStringParameters:(NSDictionary *)parameters;

@end
