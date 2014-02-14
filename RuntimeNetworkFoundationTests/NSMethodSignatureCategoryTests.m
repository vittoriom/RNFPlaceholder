#import "NSMethodSignature+OperateOnSelectors.h"

SPEC_BEGIN(NSMethodSignatureCategoryTests)

describe(@"NSMethodSignature category", ^{
    it(@"should return the correct number of arguments if one", ^{
        [[theValue([NSMethodSignature numberOfArgumentsForSelector:@selector(sendActionsForControlEvents:)]) should] equal:@1];
    });
    
    it(@"should return the correct number of arguments if more than one", ^{
        [[theValue([NSMethodSignature numberOfArgumentsForSelector:@selector(sendAction:to:forEvent:)]) should] equal:@3];
    });
    
    it(@"should return the correct number of arguments if zero", ^{
        [[theValue([NSMethodSignature numberOfArgumentsForSelector:@selector(reloadData)]) should] equal:@0];
    });
});

SPEC_END