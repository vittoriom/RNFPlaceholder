#import "RNFPlistConfigurationLoader.h"
#import "RNFEndpointConfiguration.h"

SPEC_BEGIN(RNFPlistConfigurationLoaderTests)

describe(@"Plist loading of configuration", ^{
    context(@"when initializing a loader with a non existing file", ^{
        it(@"should raise", ^{
            [[theBlock(^{
                RNFPlistConfigurationLoader *loader = [[RNFPlistConfigurationLoader alloc] initWithPlistName:@"hi"];
                [loader description];
            }) should] raise];
        });
    });
    
    context(@"when initializing a loader with an existing file", ^{
        __block RNFPlistConfigurationLoader *loader;
        
        beforeAll(^{
            loader = [[RNFPlistConfigurationLoader alloc] initWithPlistName:@"sampleConfiguration"];
        });
        
        it(@"should return a non nil object", ^{
            [[loader shouldNot] beNil];
        });
        
        it(@"should return non nil endpoint attributes", ^{
            id attributes = [loader endpointAttributes];
            [[attributes shouldNot] beNil];
        });
     
        it(@"should return valid attributes", ^{
            id<RNFEndpointConfiguration> attributes = [loader endpointAttributes];
            [[[attributes baseURL] should] equal:[NSURL URLWithString:@"http://vittoriomonaco.it/api"]];
            [[[attributes operations] should] haveCountOf:1];
        });
    });
    
    context(@"when initializing a loader with an existing but misconfigured file", ^{
        it(@"should raise", ^{
            [[theBlock(^{
                RNFPlistConfigurationLoader *loader = [[RNFPlistConfigurationLoader alloc] initWithPlistName:@"sampleMisonfiguration"];
                [loader description];
            }) should] raise];
        });
    });
    
    context(@"when initializing through the factory method", ^{
        it(@"should behave the same as the normal initializer when file doesn't exist", ^{
            [[theBlock(^{
                [RNFPlistConfigurationLoader RNFConfigurationLoaderForEndpointWithName:@"hi"];
            }) should] raise];
        });
        
        it(@"should behave the same as the normal initializer when file exists", ^{
            RNFPlistConfigurationLoader *loader = [RNFPlistConfigurationLoader RNFConfigurationLoaderForEndpointWithName:@"sampleConfiguration"];
            [[loader shouldNot] beNil];
            id attributes = [loader endpointAttributes];
            [[attributes shouldNot] beNil];
        });
    });
});

SPEC_END