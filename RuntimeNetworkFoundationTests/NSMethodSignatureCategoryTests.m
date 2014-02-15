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
    
    context(@"when building method signatures", ^{
        it(@"should correctly build for zero arguments", ^{
            NSString *expected = @"@@:";
            NSString *actual = [NSString stringWithUTF8String:[NSMethodSignature methodSignatureForMethodWithArguments:0]];
            [[actual should] equal:expected];
        });
        
        it(@"should correctly build for one argument", ^{
            NSString *expected = @"@@:@";
            NSString *actual = [NSString stringWithUTF8String:[NSMethodSignature methodSignatureForMethodWithArguments:1]];
            [[actual should] equal:expected];
        });
        
        it(@"should correctly build for more than one argument", ^{
            NSString *expected = @"@@:@@@";
            NSString *actual = [NSString stringWithUTF8String:[NSMethodSignature methodSignatureForMethodWithArguments:3]];
            [[actual should] equal:expected];
        });
    });
});

SPEC_END