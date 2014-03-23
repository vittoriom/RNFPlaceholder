#import "RNFDateValueTransformer.h"

SPEC_BEGIN(RNFDateValueTransformerTests)

describe(@"RNFDateValueTransformer", ^{
    __block RNFDateValueTransformer *transformer;
    
    it(@"should not work if initialized directly", ^{
        transformer = [RNFDateValueTransformer new];
        [[[transformer transformedValue:@"10/03/2014"] should] beNil];
    });
    
    context(@"when initialized properly", ^{
        beforeEach(^{
            transformer = [[RNFDateValueTransformer alloc] initWithDictionary:@{
                                                                                kRNFDateValueTransformerFormat : @"dd/MM/yyyy"
                                                                                }];
        });
        
        it(@"should correctly transform dates from strings", ^{
            NSDate *date = [transformer transformedValue:@"10/03/2014"];
            NSDateFormatter *formatter = [NSDateFormatter new];
            [formatter setDateFormat:@"dd/MM/yyyy"];
            [[[formatter stringFromDate:date] should] equal:@"10/03/2014"];
        });
        
        it(@"should also support empty formats", ^{
            transformer = [[RNFDateValueTransformer alloc] initWithDictionary:@{}];
            NSDateFormatter *formatter = [NSDateFormatter new];
            NSDate *date = [transformer transformedValue:@"03/10/14"];
            [formatter setDateFormat:@"MM/dd/yy"];
            [[[formatter stringFromDate:date] should] equal:@"03/10/14"];
        });
        
        it(@"should also convert timestamps", ^{
            transformer = [[RNFDateValueTransformer alloc] initWithDictionary:@{}];
            NSDateFormatter *formatter = [NSDateFormatter new];
            NSDate *date = [transformer transformedValue:@1395005030];
            [formatter setDateFormat:@"MM/dd/yy"];
            [[[formatter stringFromDate:date] should] equal:@"03/16/14"];
        });
        
        it(@"should return the original value if not supported", ^{
            [[[transformer transformedValue:@{@"1" : @2}] should] equal:@{@"1" : @2}];
        });
        
        it(@"should transform array of values", ^{
            transformer = [[RNFDateValueTransformer alloc] initWithDictionary:@{}];
            NSDateFormatter *formatter = [NSDateFormatter new];
            NSArray *result = [transformer transformedValue:@[@1395005030, @1395360000]];
            [formatter setDateFormat:@"MM/dd/yy"];
            [[result should] haveCountOf:2];
            [[[formatter stringFromDate:result[0]] should] equal:@"03/16/14"];
            [[[formatter stringFromDate:result[1]] should] equal:@"03/21/14"];
        });
        
        it(@"should also include invalid values", ^{
            transformer = [[RNFDateValueTransformer alloc] initWithDictionary:@{}];
            NSDateFormatter *formatter = [NSDateFormatter new];
            NSArray *result = [transformer transformedValue:@[@1395005030, @{}, @1395360000]];
            [formatter setDateFormat:@"MM/dd/yy"];
            [[result should] haveCountOf:3];
            [[[formatter stringFromDate:result[0]] should] equal:@"03/16/14"];
            [[theValue([result[1] isKindOfClass:[NSDictionary class]]) should] beTrue];
            [[[formatter stringFromDate:result[2]] should] equal:@"03/21/14"];
        });
        
        it(@"should transform nested arrays of values", ^{
            transformer = [[RNFDateValueTransformer alloc] initWithDictionary:@{}];
            NSDateFormatter *formatter = [NSDateFormatter new];
            NSArray *result = [transformer transformedValue:@[@1395005030, @1395360000, @[@1367280000]]];
            [formatter setDateFormat:@"MM/dd/yy"];
            [[result should] haveCountOf:3];
            [[[formatter stringFromDate:result[0]] should] equal:@"03/16/14"];
            [[[formatter stringFromDate:result[1]] should] equal:@"03/21/14"];
            NSArray *nested = result[2];
            [[nested should] haveCountOf:1];
            [[[formatter stringFromDate:nested[0]] should] equal:@"04/30/13"];
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