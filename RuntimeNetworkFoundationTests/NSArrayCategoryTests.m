#import "NSArray+RNFBlocks.h"

SPEC_BEGIN(NSArrayCategory)

describe(@"Array category for blocks",^{
    __block NSArray *testArray;
    
    beforeAll(^{
        testArray = @[
                      @{
                          @"key" : @1
                          },
                      @{
                          @"key" : @2
                          },
                      @{
                          @"key" : @3
                          }
                      ];
    });
    
    it(@"should return nil if the test is nil", ^{
        [[[testArray rnf_objectPassingTest:nil] should] beNil];
    });
    
    it(@"should return the object if the test is passing for some element", ^{
        [[[testArray rnf_objectPassingTest:^BOOL(NSDictionary *object) {
            return [object[@"key"] isEqualToNumber:@2];
        }] should] equal:@{
                           @"key" : @2
                           }];
    });
    
    it(@"should return nil if the test is not passing for any element", ^{
        [[[testArray rnf_objectPassingTest:^BOOL(id object) {
            return [object[@"key"] isEqualToNumber:@10];
        }] should] beNil];
    });
});

SPEC_END