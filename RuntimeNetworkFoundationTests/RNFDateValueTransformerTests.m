#import "RNFDateValueTransformer.h"

SPEC_BEGIN(RNFDateValueTransformerTests)

describe(@"RNFDateValueTransformer", ^{
    __block RNFDateValueTransformer *transformer;
    
    it(@"should not work if initialized directly", ^{
        transformer = [RNFDateValueTransformer new];
        [[[transformer transformedValueFromOriginalValue:@"10/03/2014"] should] beNil];
    });
    
    context(@"when initialized properly", ^{
        beforeAll(^{
            transformer = [[RNFDateValueTransformer alloc] initWithDictionary:@{
                                                                                kRNFDateValueTransformerFormat : @"dd/MM/yyyy"
                                                                                }];
        });
        
        it(@"should correctly transform dates from strings", ^{
            NSDate *date = [transformer transformedValueFromOriginalValue:@"10/03/2014"];
            NSDateFormatter *formatter = [NSDateFormatter new];
            [formatter setDateFormat:@"dd/MM/yyyy"];
            [[[formatter stringFromDate:date] should] equal:@"10/03/2014"];
        });
        
        it(@"should also support empty formats", ^{
            //TODO
        });
        
        it(@"should also convert timestamps", ^{
            //TODO
        });
        
        it(@"should return the original value if not supported", ^{
            [[[transformer transformedValueFromOriginalValue:@[@1, @2]] should] equal:@[@1,@2]];
        });
    });
    
    context(@"when not initialized properly", ^{
        it(@"should raise", ^{
            [[theBlock(^{
                transformer = [[RNFDateValueTransformer alloc] initWithDictionary:@{
                                                                                    kRNFDateValueTransformerFormat : @10
                                                                                }];
            }) should] raise];
        });
    });
});

SPEC_END