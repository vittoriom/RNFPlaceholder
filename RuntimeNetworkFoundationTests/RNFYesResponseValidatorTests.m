#import "RNFYesResponseValidator.h"

SPEC_BEGIN(RNFYesResponseValidatorTests)

describe(@"Yes ResponseValidator", ^{
    __block RNFYesResponseValidator *validator;
    
    beforeAll(^{
        validator = [RNFYesResponseValidator new];
    });
    
    it(@"should return YES for all nil parameters", ^{
        [[[validator responseIsValid:nil forOperation:nil withStatusCode:100] should] beNil];
    });
    
    it(@"should return YES for a non nil response", ^{
        [[[validator responseIsValid:@"Test" forOperation:nil withStatusCode:200] should] beNil];
    });
    
    it(@"should return YES for a 404 status code", ^{
        [[[validator responseIsValid:@[@"Test"] forOperation:nil withStatusCode:404] should] beNil];
    });
});

SPEC_END