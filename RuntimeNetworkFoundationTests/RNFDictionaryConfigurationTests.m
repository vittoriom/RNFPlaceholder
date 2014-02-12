#import "RNFDictionaryConfiguration.h"

SPEC_BEGIN(RNFDictionaryConfigurationTests)

describe(@"Dictionary configuration", ^{
    context(@"when initialized with an improper configuration", ^{
        it(@"should raise if baseURL is missing", ^{
            [[theBlock(^{
                id dummy = [[RNFDictionaryConfiguration alloc] initWithDictionary:@{kRNFConfigurationEndpointOperations : @[ @1 ]}];
                [dummy description];
            }) should] raise];
        });
        
        it(@"should raise if operations are missing", ^{
            [[theBlock(^{
                id dummy = [[RNFDictionaryConfiguration alloc] initWithDictionary:@{kRNFConfigurationEndpointBaseURL : @"http://google.it"}];
                [dummy description];
            }) should] raise];
        });
        
        it(@"should raise if operations array is empty", ^{
            [[theBlock(^{
                id dummy = [[RNFDictionaryConfiguration alloc] initWithDictionary:@{
                                                                                    kRNFConfigurationEndpointBaseURL : @"http://google.it",
                                                                                    kRNFConfigurationEndpointOperations : @[ ]}];
                [dummy description];
            }) should] raise];
        });
    });
});

SPEC_END