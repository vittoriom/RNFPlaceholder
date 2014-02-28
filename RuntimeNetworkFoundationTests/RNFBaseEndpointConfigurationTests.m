#import "RNFBaseEndpointConfiguration.h"
#import "RNFUserDefinedConfigurationParameters.h"

SPEC_BEGIN(RNFBaseEndpointConfigurationTests)

describe(@"Base configuration",^{
    __block RNFBaseEndpointConfiguration *_configuration;
    
    beforeAll(^{
        _configuration = [RNFBaseEndpointConfiguration new];
    });
    
    it(@"should raise if asked for base URL",^{
        [[theBlock(^{
            [_configuration baseURL];
        }) should] raise];
    });
    
    it(@"should raise if asked for operations", ^{
        [[theBlock(^{
            [_configuration operations];
        }) should] raise];
    });
    
    context(@"when asked for optional parameters", ^{
        it(@"should return nil for name", ^{
            [[[_configuration name] should] beNil];
        });
        
        it(@"should return nil for headers", ^{
            [[[_configuration headers] should] beNil];
        });
        
        it(@"should return nil for deserializer", ^{
            id deserializer = [_configuration responseDeserializer];
            [[deserializer should] beNil];
        });
        
        it(@"should return nil for logger", ^{
            id logger = [_configuration logger];
            [[logger should] beNil];
        });
        
        it(@"should return a NSOperation subclass for operationClass", ^{
            Class operationClass = [_configuration operationClass];
            id dummyObject = [operationClass new];
            [[theValue([dummyObject isKindOfClass:[NSOperation class]]) should] beTrue];
        });
        
        it(@"should return a NSOperationQueue subclass for operationQueueClass", ^{
            Class operationQueueClass = [_configuration operationQueueClass];
            id dummyObject = [operationQueueClass new];
            [[theValue([dummyObject isKindOfClass:[NSOperationQueue class]]) should] beTrue];
        });
        
        it(@"should return empty query string parameters dictionary", ^{
            [[[_configuration queryStringParameters] should] equal:@{}];
        });
        
        it(@"should cache results", ^{
            [[theValue([_configuration cacheResults]) should] beTrue];
        });
        
        it(@"should return a class for cacheClass", ^{
            Class cacheClass = [_configuration cacheClass];
            [[theValue(cacheClass) shouldNot] beNil];
        });
        
        it(@"should return a port number", ^{
            [[[_configuration portNumber] should] beNil];
        });
        
        it(@"should return nil user defined configuration", ^{
            id obj = [_configuration userDefinedConfiguration];
            [[obj should] beNil];
        });
    });
});

SPEC_END