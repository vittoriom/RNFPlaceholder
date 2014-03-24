#import "NSCache+RNFCacheHandler.h"
#import "RNF.h"

SPEC_BEGIN(NSCacheHandlerTests)

describe(@"NSCache as a RNFCacheHandler", ^{
    __block id<RNFCacheHandler> cacheHandler;
    
    context(@"when initialized with the right constructor", ^{
        beforeAll(^{
            cacheHandler = [[NSCache alloc] initWithCapacity:10];
        });
        
        it(@"should not return nil", ^{
            id cache = cacheHandler;
            [[cache shouldNot] beNil];
        });
        
        it(@"should have the right cost", ^{
            id cache = cacheHandler;
            [[theValue([cache totalCostLimit]) should] equal:theValue(10)];
        });
    });
    
    context(@"when caching an object", ^{
        beforeAll(^{
            cacheHandler = [[NSCache alloc] init];
        });
    
        it(@"should return NO when asked for validity of data if the data is not present", ^{
            [[theValue([cacheHandler cachedDataIsValidWithKey:@"-_testKey"]) should] beFalse];
        });
        
        it(@"should cache objects", ^{
            NSString *stringSample = @"Test string to cache";
            [cacheHandler cacheObject:stringSample withKey:@"testKey" withCost:@10 validUntil:[NSDate dateWithTimeIntervalSinceNow:100]];
            
            [[[cacheHandler cachedObjectWithKey:@"testKey"] shouldNot] beNil];
            [[[cacheHandler cachedObjectWithKey:@"testKey"] should] equal:stringSample];
        });
        
        it(@"should return nil if no object is cached with the given key", ^{
            [[[cacheHandler cachedObjectWithKey:@"no key found"] should] beNil];
        });
        
        it(@"should cache the last object with the same key", ^{
            NSString *secondSample = @"Test string to cache, 2";
            [[[cacheHandler cachedObjectWithKey:@"testKey"] should] equal:@"Test string to cache"];
            [cacheHandler cacheObject:secondSample withKey:@"testKey" withCost:@10 validUntil:[NSDate dateWithTimeIntervalSinceNow:100]];
            [[[cacheHandler cachedObjectWithKey:@"testKey"] shouldNot] beNil];
            [[[cacheHandler cachedObjectWithKey:@"testKey"] should] equal:secondSample];
        });
        
        it(@"should cache GET requests", ^{
            id dummyConfig = [RNFUnifiedConfiguration nullMock];
            [dummyConfig stub:@selector(HTTPMethod) andReturn:@"GET"];
            [[theValue([cacheHandler operationConfigurationCanBeCached:dummyConfig]) should] beTrue];
        });
        
        it(@"should not cache POST requests", ^{
            id dummyConfig = [RNFUnifiedConfiguration nullMock];
            [dummyConfig stub:@selector(HTTPMethod) andReturn:@"POST"];
            [[theValue([cacheHandler operationConfigurationCanBeCached:dummyConfig]) should] beFalse];
        });
        
        it(@"should take into account validity of objects", ^{
            NSString *objectToCache = @"Object to cache";
            [cacheHandler cacheObject:objectToCache withKey:@"_testKey" withCost:@1 validUntil:[NSDate dateWithTimeIntervalSinceNow:2]];
            [[[cacheHandler cachedObjectWithKey:@"_testKey"] should] equal:objectToCache];
            [[expectFutureValue([cacheHandler cachedObjectWithKey:@"_testKey"]) shouldEventuallyBeforeTimingOutAfter(2)] beNil];
        });
    });
});

SPEC_END