//
//  RNFStatusCodeResponseValidator.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 01/03/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "RNFStatusCodeResponseValidator.h"
#import "RNFMalformedConfiguration.h"
#import "RNFTypes.h"

@interface RNFStatusCodeResponseValidator ()

@property (nonatomic, strong) NSArray *acceptedStatusCodes;
@property (nonatomic, strong) NSArray *rejectedStatusCodes;
@property (nonatomic, assign) BOOL acceptIfNoneMatches;

@end

@implementation RNFStatusCodeResponseValidator

- (NSRange) rangeFromItem:(NSString *)item
{
    //Possible values: <number>, <number>-<number>
    NSRange range;
    
    if ([item isKindOfClass:[NSNumber class]])
    {
        range.location = [item integerValue];
        range.length = 0;
        return range;
    }
    
    NSArray *components = [item componentsSeparatedByString:@"-"];
    
    if ([item rangeOfString:@","].location != NSNotFound)
    {
        range.location = NSNotFound;
        return range;
    }
    
    if (components.count > 2 || components.count == 0)
    {
        range.location = NSNotFound;
    } else
    {
        NSInteger startingValue = [[components firstObject] integerValue];
        NSInteger endingValue = startingValue;
        
        range.location = startingValue;
        
        if (components.count == 2)
        {
            endingValue = [[components objectAtIndex:1] integerValue];
        }
        
        if(endingValue < startingValue || (startingValue == 0 && endingValue == 0))
        {
            range.location = NSNotFound;
        }
        
        range.length = endingValue - startingValue;
    }
    
    return range;
}

- (BOOL) sanityCheckOnRanges:(NSArray *)ranges
{
    BOOL rangesAreSane = YES;
    id failingItem = nil;
    
    for (id item in ranges)
    {
        //Check that item is a string or a number
        if(![item isKindOfClass:[NSString class]] && ![item isKindOfClass:[NSNumber class]])
        {
            rangesAreSane = NO;
            failingItem = item;
            break;
        }
        
        NSRange range = [self rangeFromItem:item];
        if (range.location == NSNotFound)
        {
            rangesAreSane = NO;
            failingItem = item;
            break;
        }
    }
    
    if(!rangesAreSane)
        @throw [[RNFMalformedConfiguration alloc] initWithName:NSStringFromClass([RNFMalformedConfiguration class])
                                                        reason:[NSString stringWithFormat:@"Array of status codes is malformed, %@. Failing item: %@",ranges, failingItem]
                                                      userInfo:nil];
    else
        return YES;
}

- (BOOL) code:(NSInteger)statusCode isContainedInRanges:(NSArray *)ranges
{
    NSRange range;
    
    for (id item in ranges)
    {
        range = [self rangeFromItem:item];
        if (statusCode >= range.location && statusCode <= range.location + range.length)
        {
            return YES;
        }
    }
    
    return NO;
}

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    id dictObject = [dict objectForKey:kRNFStatusCodeResponseValidatorAcceptedCodes];
    if ([dictObject isKindOfClass:[NSArray class]])
    {
        _acceptedStatusCodes = dictObject;
        [self sanityCheckOnRanges:_acceptedStatusCodes];
    } else if(dictObject)
    {
        @throw [[RNFMalformedConfiguration alloc] initWithName:NSStringFromClass([RNFMalformedConfiguration class])
                                                        reason:[NSString stringWithFormat:@"Accepted status codes is not an array, %@",dictObject]
                                                      userInfo:nil];
    }
    
    dictObject = [dict objectForKey:kRNFStatusCodeResponseValidatorRejectedCodes];
    if ([dictObject isKindOfClass:[NSArray class]])
    {
        _rejectedStatusCodes = dictObject;
        [self sanityCheckOnRanges:_rejectedStatusCodes];
    } else if (dictObject)
    {
        @throw [[RNFMalformedConfiguration alloc] initWithName:NSStringFromClass([RNFMalformedConfiguration class])
                                                        reason:[NSString stringWithFormat:@"Rejected status codes is not an array, %@",dictObject]
                                                      userInfo:nil];
    }
    
    if ([dict objectForKey:kRNFStatusCodeResponseValidatorAcceptIfNoneMatches])
    {
        _acceptIfNoneMatches = [[dict objectForKey:kRNFStatusCodeResponseValidatorAcceptIfNoneMatches] boolValue];
    } else
    {
        if(_acceptedStatusCodes && !_rejectedStatusCodes)
        {
            _acceptIfNoneMatches = NO; //If only accepted status codes are specified, everything else is rejected
        } else if(_rejectedStatusCodes && !_acceptedStatusCodes)
        {
            _acceptIfNoneMatches = YES; //If only rejected status codes are specified, everything else is accepted
        } else
        {
            _acceptIfNoneMatches = NO; //We don't know what to do here actually, but take the safe path to NO
        }
    }
    
    return self;
}

- (NSError *) responseIsValid:(id)deserializedResponse
                 forOperation:(id<RNFOperation>)operation
               withStatusCode:(NSInteger)statusCode
{
    NSError *error = nil;
    
    if ([self code:statusCode isContainedInRanges:self.acceptedStatusCodes])
    {
    } else if ([self code:statusCode isContainedInRanges:self.rejectedStatusCodes])
    {
        error = [NSError errorWithDomain:RNFErrorDomain
                                     code:statusCode
                                 userInfo:@{
                                            NSLocalizedDescriptionKey : @"Response has been rejected",
                                            NSLocalizedFailureReasonErrorKey : [NSString stringWithFormat:@"%ld status code is configured to be rejected",(long)statusCode]
                                            }];
    } else if ([self acceptIfNoneMatches])
    {
    } else
    {
        error = [NSError errorWithDomain:RNFErrorDomain
                                             code:statusCode
                                         userInfo:@{
                                                    NSLocalizedDescriptionKey : @"Response has been rejected",
                                                    NSLocalizedFailureReasonErrorKey : [NSString stringWithFormat:@"%ld status code is unknown and %@ is NO",(long)statusCode,kRNFStatusCodeResponseValidatorAcceptIfNoneMatches]
                                                    }];
    }
    
    return error;
}

@end
