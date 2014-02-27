//
//  RNFParametersParser.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 15/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "RNFParametersParser.h"
#import "RNF.h"

@implementation RNFParametersParser

- (BOOL) objectIsSerializable:(id)argObject
{
    return ([argObject isKindOfClass:[NSNumber class]] ||
            [argObject isKindOfClass:[NSString class]] ||
            [argObject isKindOfClass:[NSDictionary class]] ||
            [argObject conformsToProtocol:@protocol(RNFSerializable)]);
}

- (NSString *) parseString:(NSString *)source withArguments:(NSArray *)arguments
{
    NSRegularExpression *curlyBraces = [NSRegularExpression regularExpressionWithPattern:@"\\{\\{([^}])\\}\\}"
                                                                                 options:0
                                                                                   error:nil];
    
    NSArray *matches = [curlyBraces matchesInString:source
                                            options:0
                                              range:NSMakeRange(0, [source length])];
    
    NSMutableString *result = [[NSMutableString alloc] initWithString:source];
    
    for (NSTextCheckingResult *match in [[matches reverseObjectEnumerator] allObjects])
    {
        NSRange completePlaceholderRange = [match rangeAtIndex:0];
        NSRange placeholderValueRange = [match rangeAtIndex:1];
        
        NSInteger argIndex = [[result substringWithRange:placeholderValueRange] integerValue];
        
        if(argIndex >= [arguments count])
            @throw [RNFParametersParserError exceptionWithName:NSStringFromClass([RNFParametersParserError class])
                                           reason:[NSString stringWithFormat:@"Placeholder %@ references an object out of the arguments array bounds",NSStringFromRange(completePlaceholderRange)]
                                         userInfo:nil];
        
        id argObject = arguments[argIndex];
        
        NSString *serializedObject = [argObject conformsToProtocol:@protocol(RNFSerializable)] ? [(id<RNFSerializable>)argObject serialize] : [argObject description];
        
        if(![self objectIsSerializable:argObject])
            @throw [RNFParametersParserError exceptionWithName:NSStringFromClass([RNFParametersParserError class])
                                           reason:[NSString stringWithFormat:@"Object %@ is not serializable",argObject]
                                         userInfo:nil];
        
        [result replaceCharactersInRange:completePlaceholderRange
                              withString:serializedObject];
    }
    
    return [result copy];
}

@end
