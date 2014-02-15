#import "RNFParametersParser.h"
#import "RNFTypes.h"

SPEC_BEGIN(RNFParametersParserTests)

describe(@"RNFParametersParser",^{
    __block RNFParametersParser *parser;
    
    beforeAll(^{
        parser = [RNFParametersParser new];
    });
    
    context(@"when passing a string with no placeholders", ^{
        it(@"should correctly return the input string if arguments array is nil", ^{
            NSString *inputString = @"questions?tag=0&format=json";
            [[[parser parseString:inputString withArguments:nil] should] equal:inputString];
        });
        
        it(@"should correctly return the input string if arguments array is empty", ^{
            NSString *inputString = @"questions?tag=0&format=json";
            [[[parser parseString:inputString withArguments:@[]] should] equal:inputString];
        });
        
        it(@"should correctly return the input string if arguments array contains values", ^{
            NSString *inputString = @"questions?tag=0&format=json";
            [[[parser parseString:inputString withArguments:@[@1, @"test"]] should] equal:inputString];
        });
    });
    
    context(@"when passing a string with placeholders", ^{
        it(@"should return nil if the arguments array is nil", ^{
            [[theBlock(^{
                NSString *inputString = @"questions?tag={{{0}}}&format={{{1}}}";
                [parser parseString:inputString withArguments:nil];
            }) should] raise];
        });
        
        it(@"should raise if the arguments array is empty", ^{
            [[theBlock(^{
                NSString *inputString = @"questions?tag={{0}}&format={{1}}";
                [parser parseString:inputString withArguments:@[]];
            }) should] raise];
        });
              
        it(@"should replace the placeholders for the indexes contained in the array", ^{
            NSString *inputString = @"questions?tag={{0}}&format={{1}}";
            [[[parser parseString:inputString withArguments:@[@"tech",@"json"]] should] equal:@"questions?tag=tech&format=json"];
        });
        
        it(@"should raise if the arguments array is shorter than the number of placeholders", ^{
            [[theBlock(^{
                NSString *inputString = @"questions?tag={{0}}&format={{1}}";
                [parser parseString:inputString withArguments:@[@"tech"]];
            }) should] raise];
        });
        
        it(@"should raise if one of the arguments to replace is not serializable", ^{
            [[theBlock(^{
                RNFCompletionBlock completion = ^(id response, id<RNFOperation> operation, NSUInteger statusCode) {
                    NSLog(@"hey!");
                };
                NSString *inputString = @"questions?tag={{0}}&format={{1}}";
                [parser parseString:inputString withArguments:@[
                                                                @"tech",
                                                                completion
                                                                ]];
            }) should] raise];
        });
    });
});

SPEC_END