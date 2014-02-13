#import "RNFDictionaryEndpointConfiguration.h"
#import "RNFBaseOperation.h"
#import "RNFOperationConfiguration.h"
#import "RNFBaseOperationConfiguration.h"

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
    
    context(@"when initialized with a proper configuration", ^{
        __block RNFDictionaryEndpointConfiguration *configuration;
        
        beforeAll(^{
            configuration = [[RNFDictionaryEndpointConfiguration alloc] initWithDictionary:@{
                                                                                             kRNFConfigurationEndpointBaseURL : @"http://vittoriomonaco.it",
                                                                                             kRNFConfigurationEndpointCacheClass : @"NSCache",
                                                                                             kRNFConfigurationEndpointDefaultHeaders : @{
                                                                                                     @"Accept" : @"gzip",
                                                                                                     @"Encoding" : @"UTF8"
                                                                                                     },
                                                                                             kRNFConfigurationEndpointLoggerClass : @"NSString",
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
                                                                                             kRNFConfigurationEndpointResponseDeserializer : @"NSArray",
                                                                                             kRNFConfigurationEndpointShouldCacheResults : @NO,
                                                                                             kRNFConfigurationEndpointPortNumber : @443
                                                                                             }];
        });
        
        it(@"should correctly read the base url", ^{
            [[[configuration baseURL] should] equal:[NSURL URLWithString:@"http://vittoriomonaco.it"]];
        });
        
        it(@"should correctly read the cache class", ^{
            Class cacheClass = [configuration cacheClass];
            [[theValue([cacheClass isSubclassOfClass:[NSCache class]]) should] beTrue];
        });
        
        it(@"should correctly read the default headers", ^{
            NSDictionary *headers = [configuration headers];
            [[[headers allKeys] should] haveCountOf:2];
            [[[headers objectForKey:@"Accept"] should] equal:@"gzip"];
        });
        
        it(@"should correctly instantiate the logger", ^{
            id logger = [configuration logger];
            [[logger shouldNot] beNil];
            [[theValue([logger isKindOfClass:[NSString class]]) should] beTrue];
        });
        
        it(@"should correctly read the endpoint name", ^{
            [[[configuration name] should] equal:@"test"];
        });
        
        it(@"should correctly read the operation class", ^{
            Class operationClass = [configuration operationClass];
            [[theValue([operationClass isSubclassOfClass:[RNFBaseOperation class]]) should] beTrue];
        });
        
        it(@"should correctly read the operation queue class", ^{
            Class operationQueueClass = [configuration operationQueueClass];
            [[theValue([operationQueueClass isSubclassOfClass:[NSOperationQueue class]]) should] beTrue];
        });
        
        it(@"should correctly read the operations array", ^{
            NSArray *operations = [configuration operations];
            [[operations should] haveCountOf:2];
            [[theValue([operations[0] isKindOfClass:[RNFBaseOperationConfiguration class]]) should] beTrue];
        });
        
        it(@"should correctly instantiate the response deserializer", ^{
            id deserializer = [configuration deserializer];
            [[deserializer shouldNot] beNil];
            [[theValue([deserializer isKindOfClass:[NSArray class]]) should] beTrue];
        });
        
        it(@"should correctly read whether the endpoint should cache results or not", ^{
            [[theValue([configuration cacheResults]) should] beFalse];
        });
        
        it(@"should correctly read the port number", ^{
            [[[configuration portNumber] should] equal:@443];
        });
    });
});

SPEC_END