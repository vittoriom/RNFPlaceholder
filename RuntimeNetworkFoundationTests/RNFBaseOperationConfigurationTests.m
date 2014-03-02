#import "RNFBaseOperationConfiguration.h"

SPEC_BEGIN(RNFBaseOperationConfigurationTests)

describe(@"Base operation configuration",^{
    __block RNFBaseOperationConfiguration *configuration;
    
    beforeAll(^{
        configuration = [[RNFBaseOperationConfiguration alloc] init];
    });
    
    it(@"should raise if asked for the name", ^{
        [[theBlock(^{
            [configuration name];
        }) should] raise];
    });
    
    it(@"should not return headers", ^{
        [[theBlock(^{
            [configuration headers];
        }) should] raise];
    });
    
    it(@"should raise if asked for URL", ^{
        [[theBlock(^{
            [configuration URL];
        }) should] raise];
    });
    
    it(@"should not know whether to cache results", ^{
        [[theBlock(^{
            [configuration cacheResults];
        }) should] raise];
    });
    
    it(@"should not know which operation class to use", ^{
        [[theBlock(^{
            [configuration operationClass];
        }) should] raise];
    });
    
    it(@"should return GET for HTTP method", ^{
        [[[configuration HTTPMethod] should] equal:@"GET"];
    });
    
    it(@"should return a nil body", ^{
        [[[configuration HTTPBody] should] beNil];
    });
    
    it(@"should not know which response validator to use", ^{
        [[theBlock(^{
            [configuration responseValidator];
        }) should] raise];
    });
    
    it(@"should not know which response deserializer to use", ^{
        [[theBlock(^{
            [configuration responseDeserializer];
        }) should] raise];
    });
    
    it(@"should return a nil data deserializer", ^{
        id deserializer = [configuration dataDeserializer];
        [[deserializer should] beNil];
    });
    
    it(@"should return a nil data serializer", ^{
        id serializer = [configuration dataSerializer];
        [[serializer should] beNil];
    });
});

SPEC_END