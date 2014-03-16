#import "NSArray+RNFSerializable.h"
#import "NSObject+RNFSerializable.h"

SPEC_BEGIN(NSArraySerializableTests)

describe(@"NSArray", ^{
    it(@"should correctly serialize if objects are serializable", ^{
        NSArray *numbers = @[@1,@2,@3];
        [[theValue([numbers isSerializable]) should] beTrue];
        [[[numbers serialize] should] equal:@"[1,2,3]"];
    });
    
    it(@"should correctly serialize if objects are serializable / 2", ^{
        NSArray *strings = @[@"one",@"two",@"three"];
        [[theValue([strings isSerializable]) should] beTrue];
        [[[strings serialize] should] equal:@"[\"one\",\"two\",\"three\"]"];
    });
    
    it(@"should not serialize if not all the objects are serializable", ^{
        NSArray *notOk = @[@"one",@2, [NSDateFormatter new]];
        [[theValue([notOk isSerializable]) should] beFalse];
    });
});

SPEC_END