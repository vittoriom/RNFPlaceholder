#import "RNFURLValueTransformer.h"

SPEC_BEGIN(RNFURLValueTransformerTests)

describe(@"RNFURLValueTransformer", ^{
    __block RNFURLValueTransformer *transformer;
    
    beforeAll(^{
        transformer = [RNFURLValueTransformer new];
    });
    
    it(@"should correctly return a NSURL for valid URL strings", ^{
        NSURL *urlFromString = [NSURL URLWithString:@"http://www.google.it?q=test"];
        [[[transformer transformedValue:@"http://www.google.it?q=test"] should] equal:urlFromString];
    });
    
    it(@"should return nil if the URL string is malformed", ^{
        [[[transformer transformedValue:@"malformed?{}"] should] beNil];
    });
    
    it(@"should not raise if the value is not a string", ^{
        [[theBlock(^{
            [[[transformer transformedValue:@{
                                                             @"URL" : @"http://www.google.it"
                                                             }] should] equal:@{
                                                                                @"URL" : @"http://www.google.it"
                                                                                }];
        }) shouldNot] raise];
    });
});

SPEC_END