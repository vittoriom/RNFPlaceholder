#import "RNFDictionaryUserDefinedParameters.h"

SPEC_BEGIN(RNFDictionaryUserDefinedParameterTests)

describe(@"Dictionary-based user-defined parameter implementation", ^{
    __block RNFDictionaryUserDefinedParameters *sut;
    
    context(@"when initialized with a nil dictionary", ^{
        beforeAll(^{
            sut = [[RNFDictionaryUserDefinedParameters alloc] initWithDictionary:nil];
        });
        
        it(@"should correctly write user-defined parameters", ^{
            [sut setValue:@"test" forUserDefinedParameter:@"TEST_SERVER_KEY"];
            [[[sut valueForUserDefinedParameter:@"TEST_SERVER_KEY"] should] equal:@"test"];
        });
    });
    
    context(@"when initialized with an empty dictionary", ^{
        beforeAll(^{
            sut = [[RNFDictionaryUserDefinedParameters alloc] initWithDictionary:@{}];
        });
        
        it(@"should correctly write user-defined parameters", ^{
            [sut setValue:@"test" forUserDefinedParameter:@"TEST_SERVER_KEY"];
            [[[sut valueForUserDefinedParameter:@"TEST_SERVER_KEY"] should] equal:@"test"];
        });
    });
    
    context(@"when initialized with the normal initialier", ^{
        beforeAll(^{
            sut = [[RNFDictionaryUserDefinedParameters alloc] init];
        });
        
        it(@"should correctly write user-defined parameters", ^{
            [sut setValue:@"test" forUserDefinedParameter:@"TEST_SERVER_KEY"];
            [[[sut valueForUserDefinedParameter:@"TEST_SERVER_KEY"] should] equal:@"test"];
        });
    });
    
    context(@"when initialized with a pre-filled dictionary", ^{
        beforeAll(^{
            sut = [[RNFDictionaryUserDefinedParameters alloc] initWithDictionary:@{
                                                                                   @"TEST_SERVER_KEY" : @"TEST",
                                                                                   @"test2" : @2
                                                                                   }];
        });
        
        it(@"should correctly read user-defined parameters", ^{
            [[[sut valueForUserDefinedParameter:@"test2"] should] equal:@2];
        });
        
        it(@"should correctly write user-defined parameters", ^{
            [sut setValue:@"test" forUserDefinedParameter:@"TEST_SERVER_KEY"];
            [[[sut valueForUserDefinedParameter:@"TEST_SERVER_KEY"] should] equal:@"test"];
        });
    });
});

SPEC_END