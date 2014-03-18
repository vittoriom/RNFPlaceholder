#import "NSCache+RNFCacheHandler.h"
#import <Nocilla/Nocilla.h>

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
    
        it(@"should return NO when asked for validity of data", ^{
            [[theValue([cacheHandler cachedDataIsValidWithKey:@"testKey"]) should] beFalse];
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
    });
});

SPEC_END