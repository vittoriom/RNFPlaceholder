//
//  NSString+Additions.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 25/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

/**
 *  Adds a dictionary of query string parameters to the NSString representing a URL
 *
 *  @param parameters the dictionary containing the parameters to include in the URL
 *
 *  @return the new NSString with the parameters included
 */
- (NSString *) URLStringByAppendingQueryStringParameters:(NSDictionary *)parameters;

/**
 *
 *  @return a URL-encoded version of the string
 */
- (NSString *) URLEncodedString;

@end
