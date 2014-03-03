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
    
    it(@"should return a nil set of headers", ^{
        [[[configuration headers] should] beNil];
    });
    
    it(@"should raise if asked for URL", ^{
        [[theBlock(^{
            [configuration URL];
        }) should] raise];
    });
    
    it(@"should tell to cache results", ^{
        [[theValue([configuration cacheResults]) should] beTrue];
    });
    
    it(@"should return a nil operation class", ^{
        id result = [configuration operationClass];
        [[result should] beNil];
    });
    
    it(@"should return GET for HTTP method", ^{
        [[[configuration HTTPMethod] should] equal:@"GET"];
    });
    
    it(@"should return a nil body", ^{
        [[[configuration HTTPBody] should] beNil];
    });
    
    it(@"should return a nil response validator", ^{
        id validator = [configuration responseValidator];
        [[validator should] beNil];
    });
    
    it(@"should return a nil response deserializer", ^{
        id deserializer = [configuration responseDeserializer];
        [[deserializer should] beNil];
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