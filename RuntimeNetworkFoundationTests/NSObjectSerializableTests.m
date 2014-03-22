#import "NSObject+RNFSerializable.h"
#import "RNFSerializable.h"

SPEC_BEGIN(NSObjectSerializableTests)

describe(@"NSObject", ^{
    it(@"should serialize correctly", ^{
        NSNumber *number = @2;
        [[[(id<RNFSerializable>)number serialize] should] equal:@"2"];
    });
    
    it(@"should also serialize strings", ^{
        NSString *test = @"test";
        [[[(id<RNFSerializable>)test serialize] should] equal:@"test"];
    });
    
    it(@"should serialize generic objects", ^{
        NSDateFormatter *dateF = [NSDateFormatter new];
        [[[(id<RNFSerializable>)dateF serialize] shouldNot] beNil];
    });
});

SPEC_END