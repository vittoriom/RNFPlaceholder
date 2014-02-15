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

/**
 *  @param argsCount the number of arguments for the selector
 *
 *  @return a const char * signature with encoded types for a method that returns an object, and takes only object parameters
 */
+ (const char *) methodSignatureForMethodWithArguments:(NSUInteger)argsCount;

@end
