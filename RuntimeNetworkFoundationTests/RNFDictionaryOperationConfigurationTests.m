#import "RNFDictionaryOperationConfiguration.h"
#import "RNFJSONResponseDeserializer.h"
#import "RNFYesResponseValidator.h"

SPEC_BEGIN(RNFDictionaryOperationConfigurationTests)

describe(@"Dictionary operation configurations", ^{
    __block RNFDictionaryOperationConfiguration *configuration;
    
    context(@"when initialized with a nil dictionary", ^{
        it(@"should raise", ^{
            [[theBlock(^{
                configuration = [[RNFDictionaryOperationConfiguration alloc] initWithDictionary:nil];
            }) should] raise];
        });
    });
    
    context(@"when initialized with an improper dictionary", ^{
        it(@"should raise if the dictionary is empty", ^{
            [[theBlock(^{
                configuration = [[RNFDictionaryOperationConfiguration alloc] initWithDictionary:@{}];
            }) should] raise];
        });
        
        it(@"should raise if the name is missing", ^{
            [[theBlock(^{
                configuration = [[RNFDictionaryOperationConfiguration alloc] initWithDictionary:@{
                                                                                                  kRNFConfigurationOperationURL : @"test"
                                                                                                  }];
            }) should] raise];
        });
        
        it(@"should raise if the URL is missing", ^{
            [[theBlock(^{
                configuration = [[RNFDictionaryOperationConfiguration alloc] initWithDictionary:@{
                                                                                                  kRNFConfigurationOperationName : @"name"
                                                                                                  }];
            }) should] raise];
        });
    });
    
    context(@"when initialized with a proper dictionary", ^{
        beforeAll(^{
            configuration = [[RNFDictionaryOperationConfiguration alloc] initWithDictionary:@{
                                                                                              kRNFConfigurationOperationDataDeserializer : @"NSDictionary",
                                                                                              kRNFConfigurationOperationDataSerializer : @"NSDictionary",
                                                                                              kRNFConfigurationOperationHeaders : @{
                                                                                                      @"accept" : @"gzip"
                                                                                                      },
                                                                                              kRNFConfigurationOperationHTTPBody : @{
                                                                                                      @"param1" : @"value1",
                                                                                                      @"param2" : @2
                                                                                                      },
                                                                                              kRNFConfigurationOperationHTTPMethod : @"POST",
                                                                                              kRNFConfigurationOperationName : @"test",
                                                                                              kRNFConfigurationOperationOperationClass : @"RNFBaseOperation",
                                                                                              kRNFConfigurationOperationResponseDeserializer : @"RNFJSONResponseDeserializer",
                                                                                              kRNFConfigurationOperationShouldCacheResults : @NO,
                                                                                              kRNFConfigurationOperationURL : @"testURL",
                                                                                              kRNFConfigurationOperationResponseValidator : @"RNFYesResponseValidator"
                                                                                              }];
        });
        
        it(@"should parse the response validator", ^{
            id validator = [configuration responseValidator];
            [[theValue([validator isKindOfClass:[RNFYesResponseValidator class]]) should] beTrue];
        });
        
//        it(@"should parse the data deserializer", ^{
//            id dataDeserializer = [configuration dataDeserializer];
//            [[dataDeserializer shouldNot] beNil];
//        });
        
//        it(@"should parse the data serializer", ^{
//            id dataSerializer = [configuration dataSerializer];
//            [[dataSerializer shouldNot] beNil];
//        });
        
        it(@"should parse the headers", ^{
            NSDictionary *headers = [configuration headers];
            [[headers shouldNot] beNil];
            [[headers[@"accept"] should] equal:@"gzip"];
        });
        
        it(@"should parse the body", ^{
            NSData *body = [configuration HTTPBody];
            [[body shouldNot] beNil];
            NSString *bodyString = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
            
            [[bodyString should] equal:@"param1=value1&param2=2"];
        });
        
        it(@"should parse the method", ^{
            [[[configuration HTTPMethod] shouldNot] beNil];
            [[[configuration HTTPMethod] should] equal:@"POST"];
        });
        
        it(@"should parse the name", ^{
            [[[configuration name] shouldNot] beNil];
            [[[configuration name] should] equal:@"test"];
        });
        
        it(@"should parse the URL", ^{
            [[[configuration URL] shouldNot] beNil];
            [[[configuration URL] should] equal:@"testURL"];
        });
        
        it(@"should parse the operation class", ^{
            Class operationClass = [configuration operationClass];
            [[theValue(operationClass) shouldNot] beNil];
        });
        
        it(@"should parse whether should cache results or not", ^{
            [[theValue([configuration cacheResults]) should] beFalse];
        });
        
        it(@"should parse the response deserializer", ^{
            id responseDeserializer = [configuration responseDeserializer];
            [[theValue([responseDeserializer isKindOfClass:[RNFJSONResponseDeserializer class]]) should] beTrue];
            [[theValue(responseDeserializer) shouldNot] beNil];
        });
    });
});

SPEC_END