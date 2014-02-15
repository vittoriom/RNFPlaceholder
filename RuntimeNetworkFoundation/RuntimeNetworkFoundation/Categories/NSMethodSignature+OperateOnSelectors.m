//
//  NSMethodSignature+OperateOnSelectors.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 13/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "NSMethodSignature+OperateOnSelectors.h"

@implementation NSMethodSignature (OperateOnSelectors)

+ (NSUInteger) numberOfArgumentsForSelector:(SEL)aSelector
{
    NSString *selectorAsString = NSStringFromSelector(aSelector);
    NSUInteger argsCount = [[selectorAsString componentsSeparatedByString:@":"] count] - 1;
    
    return argsCount;
}

+ (const char *) methodSignatureForMethodWithArguments:(NSUInteger)argsCount
{
	NSMutableString *buildingSignature = [[NSMutableString alloc] initWithString:@"@@:"];
	
	for (int i=0; i<argsCount; i++)
	{
		[buildingSignature appendString:@"@"];
	}
    
	return [buildingSignature UTF8String];
}

@end
