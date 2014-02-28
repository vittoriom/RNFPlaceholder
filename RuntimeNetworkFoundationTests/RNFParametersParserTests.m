#import "RNFParametersParser.h"
#import "RNFTypes.h"

SPEC_BEGIN(RNFParametersParserTests)

describe(@"RNFParametersParser",^{
    __block RNFParametersParser *parser;
    __block NSString *inputString;
    __block NSDictionary *inputDictionary;
    
    beforeAll(^{
        parser = [RNFParametersParser new];
    });
    
    context(@"when passing a string with no placeholders", ^{
        beforeAll(^{
            inputString = @"questions?tag=0&format=json";
        });
        
        it(@"should correctly return the input string if arguments array is nil", ^{
            [[[parser parseString:inputString withArguments:nil userDefinedParametersProvider:nil] should] equal:inputString];
        });
        
        it(@"should correctly return the input string if arguments array is empty", ^{
            [[[parser parseString:inputString withArguments:@[] userDefinedParametersProvider:nil] should] equal:inputString];
        });
        
        it(@"should correctly return the input string if arguments array contains values", ^{
            [[[parser parseString:inputString withArguments:@[@1, @"test"] userDefinedParametersProvider:nil] should] equal:inputString];
        });
        
        it(@"should correctly return the input string if provider is not nil", ^{
            id provider = [KWMock mockForProtocol:@protocol(RNFUserDefinedConfigurationParameters)];
            [[[parser parseString:inputString withArguments:@[] userDefinedParametersProvider:provider] should] equal:inputString];
        });
    });
    
    context(@"when passing a dictionary with no placeholders", ^{
        beforeAll(^{
            inputDictionary = @{
                                @"tag" : @"test",
                                @"format" : @"json" };
        });
        
        it(@"should correctly return the input dictionary if arguments array is nil", ^{
            [[[parser parseDictionary:inputDictionary withArguments:Nil userDefinedParametersProvider:nil] should] equal:inputDictionary];
        });
        
        it(@"should correctly return the input string if arguments array is empty", ^{
            [[[parser parseDictionary:inputDictionary withArguments:@[] userDefinedParametersProvider:nil] should] equal:inputDictionary];
        });
        
        it(@"should correctly return the input string if arguments array contains values", ^{
            [[[parser parseDictionary:inputDictionary withArguments:@[@"tech",@"json"] userDefinedParametersProvider:nil] should] equal:inputDictionary];
        });
        
        it(@"should correctly return the input string if provider is not nil", ^{
            id provider = [KWMock mockForProtocol:@protocol(RNFUserDefinedConfigurationParameters)];
            [[[parser parseDictionary:inputDictionary withArguments:@[] userDefinedParametersProvider:provider] should] equal:inputDictionary];
        });
    });
    
    context(@"when passing a string with placeholders", ^{
        beforeAll(^{
            inputString = @"questions?tag={{{0}}}&format={{{1}}}";
        });
        
        it(@"should raise if the arguments array is nil and there is a reference to arguments", ^{
            [[theBlock(^{
                [parser parseString:inputString withArguments:nil userDefinedParametersProvider:nil];
            }) should] raise];
        });
        
        it(@"should raise if the arguments array is empty and there is a reference to arguments", ^{
            [[theBlock(^{
                [parser parseString:inputString withArguments:@[] userDefinedParametersProvider:nil];
            }) should] raise];
        });
              
        it(@"should replace the placeholders for the indexes contained in the arguments array", ^{
            [[[parser parseString:inputString withArguments:@[@"tech",@"json"] userDefinedParametersProvider:nil] should] equal:@"questions?tag=tech&format=json"];
        });
        
        it(@"should raise if the arguments array is shorter than the number of placeholders referencing arguments", ^{
            [[theBlock(^{
                [parser parseString:inputString withArguments:@[@"tech"] userDefinedParametersProvider:nil];
            }) should] raise];
        });
        
        it(@"should raise if one of the arguments to replace is not serializable", ^{
            [[theBlock(^{
                RNFCompletionBlock completion = ^(id response, id<RNFOperation> operation, NSUInteger statusCode) {
                    NSLog(@"hey!");
                };
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
    
    context(@"when passing a dictionary with placeholders", ^{
        beforeAll(^{
            inputDictionary = @{
                                @"tag" : @"{{0}}",
                                @"format" : @"{{1}}" };
            });
        
        it(@"should raise if the arguments array is nil and there is a reference to arguments", ^{
            [[theBlock(^{
                [parser parseDictionary:inputDictionary withArguments:nil userDefinedParametersProvider:nil];
            }) should] raise];
        });
        
        it(@"should raise if the arguments array is empty and there is a reference to arguments", ^{
            [[theBlock(^{
                [parser parseDictionary:inputDictionary withArguments:@[] userDefinedParametersProvider:nil];
            }) should] raise];
        });
        
        it(@"should replace the placeholders for the indexes contained in the arguments array", ^{
            [[[parser parseDictionary:inputDictionary withArguments:@[@"tech",@"json"] userDefinedParametersProvider:nil] should] equal:@{
                                                                                                                                          @"tag" : @"tech", @"format" : @"json"}];
        });
        
        it(@"should raise if the arguments array is shorter than the number of placeholders referencing arguments", ^{
            [[theBlock(^{
                [parser parseDictionary:inputDictionary withArguments:@[@"tech"] userDefinedParametersProvider:nil];
            }) should] raise];
        });
        
        it(@"should raise if one of the arguments to replace is not serializable", ^{
            [[theBlock(^{
                RNFCompletionBlock completion = ^(id response, id<RNFOperation> operation, NSUInteger statusCode) {
                    NSLog(@"hey!");
                };
                [parser parseDictionary:inputDictionary withArguments:@[
                                                                @"tech",
                                                                completion
                                                                ] userDefinedParametersProvider:nil];
            }) should] raise];
        });
        
        it(@"should raise if the provider is nil and there is a reference to a user-defined constant", ^{
            [[theBlock(^{
                inputDictionary = @{ @"token" : @"{ACCESS_TOKEN}", @"format" : @"{{0}}" };
                [parser parseDictionary:inputDictionary withArguments:@[@"json"] userDefinedParametersProvider:nil];
            }) should] raise];
        });
        
        it(@"should raise if the provider doesn't return a valid object for a user-defined constant", ^{
            [[theBlock(^{
                id provider = [KWMock mockForProtocol:@protocol(RNFUserDefinedConfigurationParameters)];
                inputDictionary = @{ @"token" : @"{ACCESS_TOKEN}", @"format" : @"{{0}}" };
                [provider stub:@selector(valueForUserDefinedParameter:) andReturn:nil];
                [parser parseDictionary:inputDictionary withArguments:@[@"json"] userDefinedParametersProvider:provider];
            }) should] raise];
        });
        
        it(@"should replace the placeholders for the constants", ^{
            id provider = [KWMock mockForProtocol:@protocol(RNFUserDefinedConfigurationParameters)];
            [provider stub:@selector(valueForUserDefinedParameter:) andReturn:@"myToken"];
            inputDictionary = @{ @"token" : @"{ACCESS_TOKEN}", @"format" : @"{{0}}" };
            [[[parser parseDictionary:inputDictionary withArguments:@[@"json"] userDefinedParametersProvider:provider] should] equal:@{ @"token" : @"myToken", @"format" : @"json" }];
        });
    });
});

SPEC_END