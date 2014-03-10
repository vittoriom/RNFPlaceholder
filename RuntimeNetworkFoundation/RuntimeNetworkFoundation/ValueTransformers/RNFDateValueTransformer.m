//
//  RNFDateValueTransformer.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 09/03/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "RNFDateValueTransformer.h"
#import "RNFMalformedConfiguration.h"

@interface RNFDateValueTransformer ()

@property (nonatomic, strong) NSDateFormatter *formatter;

@end

@implementation RNFDateValueTransformer

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
    self = [self init];
    
    _formatter = [NSDateFormatter new];
    
    id format = [dict objectForKey:kRNFDateValueTransformerFormat];
    if ([format isKindOfClass:[NSString class]])
    {
        [_formatter setDateFormat:format];
    } else if(!format)
    {
        [_formatter setDateStyle:NSDateFormatterMediumStyle];
    } else
    {
        @throw [[RNFMalformedConfiguration alloc] initWithName:NSStringFromClass([RNFMalformedConfiguration class])
                                                        reason:[NSString stringWithFormat:@"Value %@ is not a valid date format",format]
                                                      userInfo:nil];
    }
    
    return self;
}

- (id) transformedValueFromOriginalValue:(id)originalValue
{
    if ([originalValue isKindOfClass:[NSString class]])
    {
        return [_formatter dateFromString:originalValue];
    } else if([originalValue isKindOfClass:[NSNumber class]])
    {
        return [NSDate dateWithTimeIntervalSince1970:[originalValue integerValue]];
    } else
    {
        NSLog(@"<%@> Cannot transform %@, it's not a NSString or a NSNumber",NSStringFromClass([self class]),originalValue);
        return originalValue;
    }
}

@end