#import "NSString+Additions.h"

SPEC_BEGIN(NSStringAdditionTests)

describe(@"NSString+Additions category", ^{
    context(@"when building a URL with an empty dictionary", ^{
        it(@"should return the same string", ^{
            NSString *origin = @"OriginalString";
            [[[origin URLStringByAppendingQueryStringParameters:@{}] should] equal:origin];
        });
    });
    
    context(@"when building a URL with a nil dictionary", ^{
        it(@"should return the same string", ^{
            NSString *origin = @"OriginalString";
            [[[origin URLStringByAppendingQueryStringParameters:nil] should] equal:origin];
        });
    });
    
    context(@"when building a URL from an empty string", ^{
        it(@"should return a malformed URL", ^{
            NSString *empty = @"";
            NSString *URL = [empty URLStringByAppendingQueryStringParameters:@{ @"test" : @"value" }];
            [[URL should] equal:@"?test=value"];
        });
    });
    
    context(@"when building a URL from a partial URL", ^{
        it(@"should return a string with the appended parameters", ^{
            NSString *partialURL = @"http://www.google.it";
            NSString *URL = [partialURL URLStringByAppendingQueryStringParameters:@{ @"test" : @"value", @"test2" : @2 }];
            BOOL chance1 = [URL isEqualToString:@"http://www.google.it?test=value&test2=2"];
            BOOL chance2 = [URL isEqualToString:@"http://www.google.it?test2=2&test=value"];
            [[theValue(chance1 || chance2) should] beTrue];
        });
    });
    
    context(@"when building a URL from a URL containing queryString parameters", ^{
        it(@"should return a string with the parameters appended to the original string", ^{
            NSString *fullURL = @"http://www.google.it?q=test";
            NSString *URL = [fullURL URLStringByAppendingQueryStringParameters:@{ @"test" : @"value", @"test2" : @2 }];
            BOOL chance1 = [URL isEqualToString:@"http://www.google.it?q=test&test=value&test2=2"];
            BOOL chance2 = [URL isEqualToString:@"http://www.google.it?q=test&test2=2&test=value"];
            [[theValue(chance1 || chance2) should] beTrue];
        });
    });
});

SPEC_END