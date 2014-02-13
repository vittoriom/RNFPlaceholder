//
//  NSMethodSignature+OperateOnSelectors.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 13/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMethodSignature (OperateOnSelectors)

/**
 *  @param aSelector the SEL you want to get the number of arguments for
 *
 *  @return the number of arguments (calculated by counting the number of ':' in the selector name
 */
+ (NSUInteger) numberOfArgumentsForSelector:(SEL)aSelector;

@end
