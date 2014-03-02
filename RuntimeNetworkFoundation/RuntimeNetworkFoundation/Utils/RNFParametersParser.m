//
//  RNFParametersParser.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 15/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "RNFParametersParser.h"
#import "RNF.h"
#import "NSString+Additions.h"

@implementation RNFParametersParser

- (BOOL) objectIsSerializable:(id)argObject
{
    return ([argObject isKindOfClass:[NSNumber class]] ||
            [argObject isKindOfClass:[NSString class]] ||
            [argObject isKindOfClass:[NSDictionary class]] ||
            [argObject conformsToProtocol:@protocol(RNFSerializable)]);
}

- (NSMutableString *) parseString:(NSMutableString *)source withArguments:(NSArray *)arguments
{
    NSRegularExpression *curlyBraces = [NSRegularExpression regularExpressionWithPattern:@"\\{\\{([^}])\\}\\}"
                                                                                 options:0
                                                                                   error:nil];
    
    NSArray *matches = [curlyBraces matchesInString:source
                                            options:0
                                              range:NSMakeRange(0, [source length])];
    
    NSMutableString *result = source;
    
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
        
        serializedObject = [serializedObject URLEncodedString];
        
        if(![self objectIsSerializable:argObject])
            @throw [RNFParametersParserError exceptionWithName:NSStringFromClass([RNFParametersParserError class])
                                                        reason:[NSString stringWithFormat:@"Object %@ is not serializable",argObject]
                                                      userInfo:nil];
        
        [result replaceCharactersInRange:completePlaceholderRange
                              withString:serializedObject];
    }
    
    return result;
}

- (NSMutableString *) parseString:(NSMutableString *)source withUserDefinedParametersProvider:(id)provider
{
    NSRegularExpression *curlyBraces = [NSRegularExpression regularExpressionWithPattern:@"\\{([^}]+)\\}"
                                                                                 options:0
                                                                                   error:nil];
    
    NSArray *matches = [curlyBraces matchesInString:source
                                            options:0
                                              range:NSMakeRange(0, [source length])];
    
    NSMutableString *result = source;
    
    for (NSTextCheckingResult *match in [[matches reverseObjectEnumerator] allObjects])
    {
        NSRange completePlaceholderRange = [match rangeAtIndex:0];
        NSRange placeholderValueRange = [match rangeAtIndex:1];
        
        NSString *serializedObject;
        NSString *key = [source substringWithRange:placeholderValueRange];
        id providedValue = [provider valueForUserDefinedParameter:key];
        
        if (providedValue && [self objectIsSerializable:providedValue])
        {
            serializedObject = [providedValue conformsToProtocol:@protocol(RNFSerializable)] ? [(id<RNFSerializable>)providedValue serialize] : [providedValue description];
            
            [result replaceCharactersInRange:completePlaceholderRange
                                  withString:serializedObject];
        } else {
            @throw [RNFParametersParserError exceptionWithName:NSStringFromClass([RNFParametersParserError class])
                                                        reason:[NSString stringWithFormat:@"Provider %@ did not provide a valid value for key %@, returned %@",provider, key, providedValue]
                                                      userInfo:nil];
        }
    }
    
    return result;
}

- (NSString *) parseString:(NSString *)source withArguments:(NSArray *)arguments userDefinedParametersProvider:(id)provider
{
    NSMutableString *result = [[NSMutableString alloc] initWithString:source];
    
    result = [self parseString:result withArguments:arguments];
    
    result = [self parseString:result withUserDefinedParametersProvider:provider];
    
    return [result copy];
}

- (NSDictionary *) parseDictionary:(NSDictionary *)source withArguments:(NSArray *)arguments userDefinedParametersProvider:(id<RNFUserDefinedConfigurationParameters>)provider
{
    NSMutableDictionary *result = [source mutableCopy];
    
    for (NSString *key in result.allKeys)
    {
        NSMutableString *parsedValue = [result[key] mutableCopy];
        parsedValue = [self parseString:parsedValue withArguments:arguments];
        parsedValue = [self parseString:parsedValue withUserDefinedParametersProvider:provider];
        [result setObject:parsedValue forKey:key];
    }
    
    return result;
}

@end
