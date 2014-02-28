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
            [[[parser parseString:inputString withArguments:nil userDefinedParametersProvider:nil] should] equal:inputString];
        });
        
        it(@"should correctly return the input string if arguments array is empty", ^{
            NSString *inputString = @"questions?tag=0&format=json";
            [[[parser parseString:inputString withArguments:@[] userDefinedParametersProvider:nil] should] equal:inputString];
        });
        
        it(@"should correctly return the input string if arguments array contains values", ^{
            NSString *inputString = @"questions?tag=0&format=json";
            [[[parser parseString:inputString withArguments:@[@1, @"test"] userDefinedParametersProvider:nil] should] equal:inputString];
        });
    });
    
    context(@"when passing a string with placeholders", ^{
        it(@"should raise if the arguments array is nil and there is a reference to arguments", ^{
            [[theBlock(^{
                NSString *inputString = @"questions?tag={{{0}}}&format={{{1}}}";
                [parser parseString:inputString withArguments:nil userDefinedParametersProvider:nil];
            }) should] raise];
        });
        
        it(@"should raise if the arguments array is empty and there is a reference to arguments", ^{
            [[theBlock(^{
                NSString *inputString = @"questions?tag={{0}}&format={{1}}";
                [parser parseString:inputString withArguments:@[] userDefinedParametersProvider:nil];
            }) should] raise];
        });
              
        it(@"should replace the placeholders for the indexes contained in the arguments array", ^{
            NSString *inputString = @"questions?tag={{0}}&format={{1}}";
            [[[parser parseString:inputString withArguments:@[@"tech",@"json"] userDefinedParametersProvider:nil] should] equal:@"questions?tag=tech&format=json"];
        });
        
        it(@"should raise if the arguments array is shorter than the number of placeholders referencing arguments", ^{
            [[theBlock(^{
                NSString *inputString = @"questions?tag={{0}}&format={{1}}";
                [parser parseString:inputString withArguments:@[@"tech"] userDefinedParametersProvider:nil];
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
                                                                ] userDefinedParametersProvider:nil];
            }) should] raise];
        });
        
        it(@"should raise if the provider is nil and there is a reference to a user-defined constant", ^{
            [[theBlock(^{
                NSString *inputString = @"questions?token={ACCESS_TOKEN}&format={{0}}";
                [parser parseString:inputString withArguments:@[@"json"] userDefinedParametersProvider:nil];
            }) should] raise];
        });
        
        it(@"should raise if the provider doesn't return a valid object for a user-defined constant", ^{
            [[theBlock(^{
                id provider = [KWMock mockForProtocol:@protocol(RNFUserDefinedConfigurationParameters)];
                [provider stub:@selector(valueForUserDefinedParameter:) andReturn:nil];
                NSString *inputString = @"questions?token={ACCESS_TOKEN}&format={{0}}";
                [parser parseString:inputString withArguments:@[@"json"] userDefinedParametersProvider:provider];
            }) should] raise];
        });
        
        it(@"should replace the placeholders for the constants", ^{
            id provider = [KWMock mockForProtocol:@protocol(RNFUserDefinedConfigurationParameters)];
            [provider stub:@selector(valueForUserDefinedParameter:) andReturn:@"myToken"];
            NSString *inputString = @"questions?token={ACCESS_TOKEN}&format={{0}}";
            [[[parser parseString:inputString withArguments:@[@"json"] userDefinedParametersProvider:provider] should] equal:@"questions?token=myToken&format=json"];
        });
    });
});

SPEC_END