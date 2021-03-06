#import "RNFUnifiedConfiguration.h"
#import "RNFEndpointConfiguration.h"
#import "RNFOperationConfiguration.h"
#import "RNFDictionaryEndpointConfiguration.h"
#import "RNFDictionaryOperationConfiguration.h"
#import "RNFBaseOperation.h"
#import "RNFYesResponseValidator.h"
#import "DummyAuthHandler.h"
#import "RNFJSONResponseDeserializer.h"
#import "RNFNSLogger.h"

SPEC_BEGIN(RNFUnifiedConfigurationTests)

describe(@"Unified configuration", ^{
    __block RNFUnifiedConfiguration *sut;
    __block RNFDictionaryEndpointConfiguration *endpoint;
    __block RNFDictionaryOperationConfiguration *operation;
    
    context(@"when initialized with nil configurations", ^{
        beforeAll(^{
            sut = [[RNFUnifiedConfiguration alloc] initWithEndpointConfiguration:nil operationConfiguration:nil];
        });
        
        it(@"should return a nil name", ^{
            [[[sut name] should] beNil];
        });
        
        it(@"should return a nil baseURL", ^{
            [[[sut baseURL] should] beNil];
        });
        
        it(@"should return nil operations", ^{
            [[[sut operations] should] beNil];
        });
        
        it(@"should return a nil URL", ^{
            [[[sut URL] should] beNil];
        });
        
        it(@"should return a nil operationClass", ^{
            id operationClass = [sut operationClass];
            [[operationClass should] beNil];
        });
        
        it(@"should return GET as HTTPMethod", ^{
            [[[sut HTTPMethod] should] equal:@"GET"];
        });
        
        it(@"should return a nil body", ^{
            [[[sut HTTPBody] should] beNil];
        });
        
        it(@"should return a nil data deserializer", ^{
            id obj = [sut dataDeserializer];
            [[obj should] beNil];
        });
        
        it(@"should return a nil data serializer", ^{
            id obj = [sut dataSerializer];
            [[obj should] beNil];
        });
        
        it(@"should return nil query string parameters", ^{
            [[[sut queryStringParameters] should] beNil];
        });
        
        it(@"should return a nil auth handler", ^{
            [[(id)[sut authenticationHandler] should] beNil];
        });
        
        it(@"should return nil headers", ^{
            [[[sut headers] should] equal:@{}];
        });
        
        it(@"should return a nil response deserializer", ^{
            id obj = [sut responseDeserializer];
            [[obj should] beNil];
        });
        
        it(@"should return a nil operation queue class", ^{
            id obj = [sut operationQueueClass];
            [[obj should] beNil];
        });
        
        it(@"should cache results", ^{
            [[theValue([sut cacheResults]) should] beTrue];
        });
        
        it(@"should return a nil cache class", ^{
            id obj = [sut cacheClass];
            [[obj should] beNil];
        });
        
        it(@"should return a nil logger", ^{
            id obj = [sut logger];
            [[obj should] beNil];
        });
    });
    
    context(@"when initialized with a nil operation configuration", ^{
        beforeAll(^{
            endpoint = [[RNFDictionaryEndpointConfiguration alloc] initWithDictionary:@{
                                                                     kRNFConfigurationEndpointBaseURL : @"http://vittoriomonaco.it",
                                                                     kRNFConfigurationEndpointCacheClass : @"NSCache",
                                                                     kRNFConfigurationEndpointDefaultHeaders : @{
                                                                         @"Accept" : @"gzip",
                                                                         @"Encoding" : @"UTF8"
                                                                         },
                                                                     kRNFConfigurationEndpointLogger : @"RNFNSLogger",
                                                                     kRNFConfigurationEndpointName : @"test",
                                                                     kRNFConfigurationEndpointOperationClass : @"RNFBaseOperation",
                                                                     kRNFConfigurationEndpointOperationQueueClass : @"NSOperationQueue",
                                                                     kRNFConfigurationEndpointOperations : @[
                                                                         @{
                                                                             kRNFConfigurationOperationURL : @"test",
                                                                             kRNFConfigurationOperationName : @"test"
                                                                             }, @{
                                                                             kRNFConfigurationOperationName : @"test2",
                                                                             kRNFConfigurationOperationURL : @"test2"
                                                                             }
                                                                         ],
                                                                     kRNFConfigurationEndpointResponseDeserializer : @"RNFJSONResponseDeserializer",
                                                                     kRNFConfigurationEndpointShouldCacheResults : @NO,
                                                                     kRNFConfigurationEndpointDefaultQueryStringParameters : @{
                                                                         @"customP" : @"customV"
                                                                         },
                                                                     kRNFConfigurationEndpointAuthenticationHandler : @"DummyAuthHandler",
                                                                     kRNFConfigurationEndpointResponseValidator : @"RNFYesResponseValidator"
                                                                    }];
            sut = [[RNFUnifiedConfiguration alloc] initWithEndpointConfiguration:endpoint operationConfiguration:nil];
        });
        
        it(@"should return a nil name", ^{
            [[[sut name] should] beNil];
        });
        
        it(@"should return a valid response validator", ^{
            id validator = [sut responseValidator];
            [[theValue([validator isKindOfClass:[RNFYesResponseValidator class]]) should] beTrue];
        });
        
        it(@"should return a valid baseURL", ^{
            [[[sut baseURL] should] equal:[NSURL URLWithString:@"http://vittoriomonaco.it"]];
        });
        
        it(@"should return valid operations", ^{
            [[[sut operations] should] haveCountOf:2];
            [[[[sut operations][0] name] should] equal:@"test"];
        });
        
        it(@"should return a nil URL", ^{
            [[[sut URL] should] equal:@"http://vittoriomonaco.it/"];
        });
        
        it(@"should return a valid operationClass", ^{
            [[theValue([sut operationClass]) should] equal:theValue([RNFBaseOperation class])];
        });
        
        it(@"should return a valid auth handler", ^{
            id handler = [sut authenticationHandler];
            [[theValue([handler isKindOfClass:[DummyAuthHandler class]]) should] beTrue];
        });
        
        it(@"should return GET as HTTPMethod", ^{
            [[[sut HTTPMethod] should] equal:@"GET"];
        });
        
        it(@"should return a nil body", ^{
            [[[sut HTTPBody] should] beNil];
        });
        
//        it(@"should return a nil data deserializer", ^{
//            id obj = [sut dataDeserializer];
//            [[obj should] beNil];
//        });
//        
//        it(@"should return a nil data serializer", ^{
//            id obj = [sut dataSerializer];
//            [[obj should] beNil];
//        });
        
        it(@"should return valid query string parameters", ^{
            [[[sut queryStringParameters] should] equal:@{ @"customP" : @"customV" }];
        });
        
        it(@"should return valid headers", ^{
            [[[sut headers] should] equal:@{
                                            @"Accept" : @"gzip",
                                            @"Encoding" : @"UTF8"
                                            }];
        });
        
        it(@"should return a valid response deserializer", ^{
            id obj = [sut responseDeserializer];
            [[theValue([obj isKindOfClass:[RNFJSONResponseDeserializer class]]) should] beTrue];
        });
        
        it(@"should return a valid operation queue class", ^{
            id obj = [sut operationQueueClass];
            [[theValue(obj == [NSOperationQueue class]) should] beTrue];
        });
        
        it(@"should not cache results", ^{
            [[theValue([sut cacheResults]) should] beFalse];
        });
        
        it(@"should return a valid cache class", ^{
            id obj = [sut cacheClass];
            [[theValue(obj == [NSCache class]) should] beTrue];
        });
        
        it(@"should return a valid logger", ^{
            id obj = [sut logger];
            [[theValue([obj isKindOfClass:[RNFNSLogger class]]) should] beTrue];
        });
    });
    
    context(@"when initialized with a nil endpoint configuration", ^{
        beforeAll(^{
            operation = [[RNFDictionaryOperationConfiguration alloc] initWithDictionary:@{
                                                                          kRNFConfigurationOperationDataDeserializer : @"NSDictionary",
                                                                          kRNFConfigurationOperationDataSerializer : @"NSDictionary",
                                                                          kRNFConfigurationOperationHeaders : @{
                                                                                  @"accept" : @"gzip"
                                                                                  },
                                                                          kRNFConfigurationOperationHTTPBody : @{
                                                                                  @"param1" : @"value1",
                                                                                  @"param2" : @2
                                                                                  },
                                                                          kRNFConfigurationOperationAuthenticationHandler : @"DummyAuthHandler",
                                                                          kRNFConfigurationOperationHTTPMethod : @"POST",
                                                                          kRNFConfigurationOperationName : @"test",
                                                                          kRNFConfigurationOperationOperationClass : @"RNFBaseOperation",
                                                                          kRNFConfigurationOperationResponseDeserializer : @"RNFJSONResponseDeserializer",
                                                                          kRNFConfigurationOperationShouldCacheResults : @NO,
                                                                          kRNFConfigurationEndpointResponseValidator : @"RNFYesResponseValidator",
                                                                          kRNFConfigurationOperationURL : @"testURL"
                                                                    }];
            
            sut = [[RNFUnifiedConfiguration alloc] initWithEndpointConfiguration:nil operationConfiguration:operation];
        });
        
        it(@"should return a valid name", ^{
            [[[sut name] should] equal:@"test"];
        });
        
        it(@"should return a nil baseURL", ^{
            [[[sut baseURL] should] beNil];
        });
        
        it(@"should return a valid responseValidator", ^{
            id validator = [sut responseValidator];
            [[theValue([validator isKindOfClass:[RNFYesResponseValidator class]]) should] beTrue];
        });
        
        it(@"should return nil operations", ^{
            [[[sut operations] should] beNil];
        });
        
        it(@"should return a nil URL", ^{
            [[[sut URL] should] beNil];
        });
        
        it(@"should return a valid operationClass", ^{
            [[theValue([sut operationClass]) should] equal:theValue([RNFBaseOperation class])];
        });
        
        it(@"should return POST as HTTPMethod", ^{
            [[[sut HTTPMethod] should] equal:@"POST"];
        });
        
        it(@"should return a valid auth handler", ^{
            id handler = [sut authenticationHandler];
            [[theValue([handler isKindOfClass:[DummyAuthHandler class]]) should] beTrue];
        });
        
        it(@"should return a valid body", ^{
            NSData *body = [sut HTTPBody];
            [[body shouldNot] beNil];
            NSString *bodyString = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
            
            [[bodyString should] equal:@"param1=value1&param2=2"];
        });
        
//        it(@"should return a valid data deserializer", ^{
//            id obj = [sut dataDeserializer];
//            [[obj shouldNot] beNil];
//        });
//        
//        it(@"should return a valid data serializer", ^{
//            id obj = [sut dataSerializer];
//            [[obj shouldNot] beNil];
//        });
        
        it(@"should return nil query string parameters", ^{
            [[[sut queryStringParameters] should] beNil];
        });
        
        it(@"should return valid headers", ^{
            [[[sut headers] should] equal:@{
                                            @"accept" : @"gzip"
                                            }];
        });
        
        it(@"should return a valid response deserializer", ^{
            id obj = [sut responseDeserializer];
            [[theValue([obj isKindOfClass:[RNFJSONResponseDeserializer class]]) should] beTrue];
        });
        
        it(@"should return a nil operation queue class", ^{
            id obj = [sut operationQueueClass];
            [[obj should] beNil];
        });
        
        it(@"should not cache results", ^{
            [[theValue([sut cacheResults]) should] beFalse];
        });
        
        it(@"should return a nil cache class", ^{
            id obj = [sut cacheClass];
            [[obj should] beNil];
        });
        
        it(@"should return a nil logger", ^{
            id obj = [sut logger];
            [[obj should] beNil];
        });
    });
    
    context(@"when initialized with no nil configurations", ^{
        beforeAll(^{
            operation = [[RNFDictionaryOperationConfiguration alloc] initWithDictionary:@{
                                                                                          kRNFConfigurationOperationDataDeserializer : @"NSDictionary",
                                                                                        kRNFConfigurationOperationDataSerializer : @"NSDictionary",
                                                                                          kRNFConfigurationOperationHeaders : @{
                                                                                                  @"Accept" : @"gzip, tar"
                                                                                                  },
                                                                                          kRNFConfigurationOperationHTTPBody : @{
                                                                                                  @"param1" : @"value1",
                                                                                                  @"param2" : @2
                                                                                                  },
                                                                                          kRNFConfigurationOperationHTTPMethod : @"POST",
                                                                                          kRNFConfigurationOperationName : @"test",
                                                                                          kRNFConfigurationOperationOperationClass : @"RNFBaseOperation",
                                                                                          kRNFConfigurationOperationAuthenticationHandler : @"DummyAuthHandler",
                                                                                          kRNFConfigurationOperationResponseDeserializer : @"RNFJSONResponseDeserializer",
                                                                                          kRNFConfigurationOperationShouldCacheResults : @NO,
                                                                                          kRNFConfigurationOperationURL : @"testURL"
                                                                                          }];

            endpoint = [[RNFDictionaryEndpointConfiguration alloc] initWithDictionary:@{
                                                                                        kRNFConfigurationEndpointBaseURL : @"http://vittoriomonaco.it",
                                                                                        kRNFConfigurationEndpointCacheClass : @"NSCache",
                                                                                        kRNFConfigurationEndpointDefaultHeaders : @{
                                                                                                @"Accept" : @"gzip",
                                                                                                @"Encoding" : @"UTF8"
                                                                                                },
                                                                                        kRNFConfigurationEndpointLogger : @"RNFNSLogger",
                                                                                        kRNFConfigurationEndpointName : @"test",
                                                                                        kRNFConfigurationEndpointOperationClass : @"RNFBaseOperation",
                                                                                        kRNFConfigurationEndpointOperationQueueClass : @"NSOperationQueue",
                                                                                        kRNFConfigurationEndpointOperations : @[
                                                                                                @{
                                                                                                    kRNFConfigurationOperationURL : @"test",
                                                                                                    kRNFConfigurationOperationName : @"test"
                                                                                                    }, @{
                                                                                                    kRNFConfigurationOperationName : @"test2",
                                                                                                    kRNFConfigurationOperationURL : @"test2"
                                                                                                    }
                                                                                                ],
                                                                                        kRNFConfigurationEndpointResponseDeserializer : @"RNFJSONResponseDeserializer",
                                                                                        kRNFConfigurationEndpointShouldCacheResults : @NO,
                                                                                        kRNFConfigurationEndpointResponseValidator : @"RNFYesResponseValidator",
                                                                                        kRNFConfigurationEndpointDefaultQueryStringParameters : @{
                                                                                                @"customP" : @"customV"
                                                                                                }
                                                                                        }];
            sut = [[RNFUnifiedConfiguration alloc] initWithEndpointConfiguration:endpoint operationConfiguration:operation];
        });
        
        it(@"should return a valid name", ^{
            [[[sut name] should] equal:@"test"];
        });
        
        it(@"should return a valid baseURL", ^{
            [[[sut baseURL] should] equal:[NSURL URLWithString:@"http://vittoriomonaco.it"]];
        });
        
        it(@"should return a valid response validator", ^{
            id validator = [sut responseValidator];
            [[theValue([validator isKindOfClass:[RNFYesResponseValidator class]]) should] beTrue];
        });
        
        it(@"should return a valid URL", ^{
            [[[sut URL] should] equal:@"http://vittoriomonaco.it/testURL"];
        });
        
        it(@"should return a valid operationClass", ^{
            [[theValue([sut operationClass]) should] equal:theValue([RNFBaseOperation class])];
        });
        
        it(@"should return a valid auth handler", ^{
            id handler = [sut authenticationHandler];
            [[theValue([handler isKindOfClass:[DummyAuthHandler class]]) should] beTrue];
        });
        
        it(@"should return a valid body", ^{
            NSData *body = [sut HTTPBody];
            [[body shouldNot] beNil];
            NSString *bodyString = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
            
            [[bodyString should] equal:@"param1=value1&param2=2"];
        });
        
//        it(@"should return a valid data deserializer", ^{
//            id obj = [sut dataDeserializer];
//            [[obj shouldNot] beNil];
//        });
//        
//        it(@"should return a valid data serializer", ^{
//            id obj = [sut dataSerializer];
//            [[obj shouldNot] beNil];
//        });
        
        it(@"should return a valid response deserializer", ^{
            id obj = [sut responseDeserializer];
            [[theValue([obj isKindOfClass:[RNFJSONResponseDeserializer class]]) should] beTrue];
        });
        
        it(@"should not cache results", ^{
            [[theValue([sut cacheResults]) should] beFalse];
        });
        
        it(@"should return a valid baseURL", ^{
            [[[sut baseURL] should] equal:[NSURL URLWithString:@"http://vittoriomonaco.it"]];
        });
        
        it(@"should return valid operations", ^{
            [[[sut operations] should] haveCountOf:2];
            [[[[sut operations][0] name] should] equal:@"test"];
        });
        
        it(@"should return a valid operationClass", ^{
            [[theValue([sut operationClass]) should] equal:theValue([RNFBaseOperation class])];
        });
        
        it(@"should return POST as HTTPMethod", ^{
            [[[sut HTTPMethod] should] equal:@"POST"];
        });
        
        it(@"should return valid query string parameters", ^{
            [[[sut queryStringParameters] should] equal:@{ @"customP" : @"customV" }];
        });
        
        it(@"should return valid headers", ^{
            [[[sut headers] should] equal:@{
                                            @"Accept" : @"gzip, tar",
                                            @"Encoding" : @"UTF8"
                                            }];
        });
        
        it(@"should return a valid operation queue class", ^{
            id obj = [sut operationQueueClass];
            [[theValue(obj == [NSOperationQueue class]) should] beTrue];
        });
        
        it(@"should return a valid cache class", ^{
            id obj = [sut cacheClass];
            [[theValue(obj == [NSCache class]) should] beTrue];
        });
        
        it(@"should return a valid logger", ^{
            id obj = [sut logger];
            [[theValue([obj isKindOfClass:[RNFNSLogger class]]) should] beTrue];
        });
    });
});

SPEC_END