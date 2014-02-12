#import "RNFDictionaryEndpointConfiguration.h"

SPEC_BEGIN(RNFDictionaryEndpointConfigurationTests)

describe(@"Dictionary configuration", ^{
    context(@"when initialized with an improper configuration", ^{
        it(@"should raise if baseURL is missing", ^{
            [[theBlock(^{
                id dummy = [[RNFDictionaryEndpointConfiguration alloc] initWithDictionary:@{kRNFConfigurationEndpointOperations : @[ @1 ]}];
                [dummy description];
            }) should] raise];
        });
        
        it(@"should raise if operations are missing", ^{
            [[theBlock(^{
                id dummy = [[RNFDictionaryEndpointConfiguration alloc] initWithDictionary:@{kRNFConfigurationEndpointBaseURL : @"http://google.it"}];
                [dummy description];
            }) should] raise];
        });
        
        it(@"should raise if operations array is empty", ^{
            [[theBlock(^{
                id dummy = [[RNFDictionaryEndpointConfiguration alloc] initWithDictionary:@{
                                                                                    kRNFConfigurationEndpointBaseURL : @"http://google.it",
                                                                                    kRNFConfigurationEndpointOperations : @[ ]}];
                [dummy description];
            }) should] raise];
        });
    });
});

SPEC_END