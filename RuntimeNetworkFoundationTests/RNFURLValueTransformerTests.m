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
    
    it(@"should transform array of strings", ^{
        NSArray *arrayTest = @[@"http://www.google.it",@"http://www.github.com"];
        NSArray *transformedArray = [transformer transformedValue:arrayTest];
        [[transformedArray should] haveCountOf:2];
        [[[transformedArray firstObject] should] equal:[NSURL URLWithString:@"http://www.google.it"]];
        [[[transformedArray objectAtIndex:1] should] equal:[NSURL URLWithString:@"http://www.github.com"]];
    });
    
    it(@"should add also invalid objects in a array", ^{
        NSArray *arrayTest = @[@"http://www.google.it", @2, @"http://www.github.com"];
        NSArray *transformedArray = [transformer transformedValue:arrayTest];
        [[transformedArray should] haveCountOf:3];
        [[[transformedArray firstObject] should] equal:[NSURL URLWithString:@"http://www.google.it"]];
        [[[transformedArray objectAtIndex:1] should] equal:@2];
    });
    
    it(@"should transform nested arrays", ^{
        NSArray *arrayTest = @[@"http://www.google.it",@"http://www.github.com",@[@"http://www.facebook.com",@"http://www.twitter.com"]];
        NSArray *transformedArray = [transformer transformedValue:arrayTest];
        [[transformedArray should] haveCountOf:3];
        [[[transformedArray firstObject] should] equal:[NSURL URLWithString:@"http://www.google.it"]];
        [[[transformedArray objectAtIndex:1] should] equal:[NSURL URLWithString:@"http://www.github.com"]];
        NSArray *nested = transformedArray[2];
        [[nested should] haveCountOf:2];
        [[[nested firstObject] should] equal:[NSURL URLWithString:@"http://www.facebook.com"]];
        [[[nested objectAtIndex:1] should] equal:[NSURL URLWithString:@"http://www.twitter.com"]];
    });
});

SPEC_END