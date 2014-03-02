#import "RNFStatusCodeResponseValidator.h"

SPEC_BEGIN(RNFStatusCodeResponseValidatorTests)

describe(@"Status-code response validator", ^{
    __block RNFStatusCodeResponseValidator *validator;
    
    context(@"when initialized with a malformed dictionary", ^{
        it(@"should raise if the codes value is not an array", ^{
            [[theBlock(^{
                validator = [[RNFStatusCodeResponseValidator alloc] initWithDictionary:@{
                                                                                         kRNFStatusCodeResponseValidatorAcceptedCodes : @"200"
                                                                                         }];
            }) should] raise];
        });
        
        it(@"should raise if the dictionary contains a non-integer value", ^{
            [[theBlock(^{
                validator = [[RNFStatusCodeResponseValidator alloc] initWithDictionary:@{
                                                                                         kRNFStatusCodeResponseValidatorAcceptedCodes : @[
                                                                                                 @"200",
                                                                                                 @"test"
                                                                                                 ]
                                                                                         }];
            }) should] raise];
        });
        
        it(@"should not raise if the dictionary is nil or empty", ^{
            [[theBlock(^{
                validator = [[RNFStatusCodeResponseValidator alloc] initWithDictionary:nil];
                validator = [[RNFStatusCodeResponseValidator alloc] initWithDictionary:@{}];
            }) shouldNot] raise];
        });
        
        it(@"should raise if the dictionary contains an inverse range", ^{
            [[theBlock(^{
                validator = [[RNFStatusCodeResponseValidator alloc] initWithDictionary:@{
                                                                                         kRNFStatusCodeResponseValidatorRejectedCodes : @[
                                                                                                 @"205-200"
                                                                                                 ]
                                                                                         }];
            }) should] raise];
        });
        
        it(@"should raise if the dictionary contains a comma-separated list of values", ^{
            [[theBlock(^{
                validator = [[RNFStatusCodeResponseValidator alloc] initWithDictionary:@{
                                                                                         kRNFStatusCodeResponseValidatorRejectedCodes : @[
                                                                                                 @"200,202"
                                                                                                 ]
                                                                                         }];
            }) should] raise];
        });
    });
    
    context(@"when initialized with a proper dictionary", ^{
        beforeAll(^{
            validator = [[RNFStatusCodeResponseValidator alloc] initWithDictionary:@{
                                                                                     kRNFStatusCodeResponseValidatorAcceptedCodes : @[
                                                                                             @"200",
                                                                                             @205
                                                                                             ],
                                                                                     kRNFStatusCodeResponseValidatorRejectedCodes : @[
                                                                                             @"400-409"
                                                                                             ],
                                                                                     kRNFStatusCodeResponseValidatorAcceptIfNoneMatches : @YES
                                                                                     }];
        });
        
        it(@"should correctly return whether a status code is contained in a range or not", ^{
            [[[validator responseIsValid:nil forOperation:nil withStatusCode:405] shouldNot] beNil];
        });
        
        it(@"should correctly give priority to the accepted status codes, then the rejected ones", ^{
            [[[validator responseIsValid:nil forOperation:nil withStatusCode:205] should] beNil];
        });
        
        it(@"should correctly return a response based on ifNone value", ^{
            [[[validator responseIsValid:nil forOperation:nil withStatusCode:100] should] beNil];
        });
    });
});

SPEC_END