#import "NSURL+Additions.h"

SPEC_BEGIN(NSURLAdditionsTests)

describe(@"NSURL+Additions category", ^{
    context(@"when building a URL with an empty dictionary", ^{
        it(@"should return the same URL", ^{
            NSURL *origin = [NSURL URLWithString:@"http://www.google.it"];
            [[[origin URLByAppendingQueryStringParameters:@{}] should] equal:origin];
        });
    });
    
    context(@"when building a URL with a nil dictionary", ^{
        it(@"should return the same URL", ^{
            NSURL *origin = [NSURL URLWithString:@"http://www.google.it"];
            [[[origin URLByAppendingQueryStringParameters:nil] should] equal:origin];
        });
    });
    
    context(@"when building a URL from an empty URL", ^{
        it(@"should return a malformed URL", ^{
            NSURL *origin = [NSURL URLWithString:@""];
            NSURL *URL = [origin URLByAppendingQueryStringParameters:@{ @"q" : @"test" }];
            [[[URL absoluteString] should] equal:@"?q=test"];
        });
    });
    
    context(@"when building a URL from a partial URL", ^{
        it(@"should return a URL with the appended parameters", ^{
            NSURL *origin = [NSURL URLWithString:@"http://www.google.it"];
            NSURL *URL = [origin URLByAppendingQueryStringParameters:@{ @"lang" : @"it", @"adv" : @1 }];
            BOOL chance1 = [[URL absoluteString] isEqualToString:@"http://www.google.it?lang=it&adv=1"];
            BOOL chance2 = [[URL absoluteString] isEqualToString:@"http://www.google.it?adv=1&lang=it"];
            [[theValue(chance2 || chance1) should] beTrue];
        });
    });
    
    context(@"when building a URL from a URL containing queryString parameters", ^{
        it(@"should return a URL with the parameters appended to the original string", ^{
            NSURL *origin = [NSURL URLWithString:@"http://www.google.it?q=test"];
            NSURL *URL = [origin URLByAppendingQueryStringParameters:@{ @"lang" : @"it", @"adv" : @1 }];
            BOOL chance1 = [[URL absoluteString] isEqualToString:@"http://www.google.it?q=test&lang=it&adv=1"];
            BOOL chance2 = [[URL absoluteString] isEqualToString:@"http://www.google.it?q=test&adv=1&lang=it"];
            [[theValue(chance2 || chance1) should] beTrue];
        });
    });
});

SPEC_END