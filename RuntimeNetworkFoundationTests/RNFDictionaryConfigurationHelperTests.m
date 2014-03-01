#import "RNFDictionaryConfigurationHelper.h"
#import "RNFResponseValidator.h"
#import "RNFStatusCodeResponseValidator.h"
#import "RNFResponseDeserializer.h"
#import "RNFYesResponseValidator.h"

SPEC_BEGIN(RNFDictionaryConfigurationHelperTests)

describe(@"RNFDictionaryConfigurationHelper", ^{
    context(@"when converting a dictionary to a NSData object", ^{
        it(@"should return nil if a nil string is passed", ^{
            [[[RNFDictionaryConfigurationHelper dictionaryToData:nil] should] beNil];
        });
        
        it(@"should return a valid NSData object otherwise", ^{
            NSDictionary *test = @{ @"key" : @"value", @"key2" : @"value2" };
            NSString *testString = @"key=value&key2=value2";
            NSData *result = [RNFDictionaryConfigurationHelper dictionaryToData:test];
            [[[[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding] should] equal:testString];
        });
    });
    
    context(@"when reading classes from a configuration", ^{
        it(@"should return nil if the key doesn't exist", ^{
            id result = [RNFDictionaryConfigurationHelper classFromKey:@"key" inDictionary:@{@"value" : @2}];
            [[result should] beNil];
        });
        
        it(@"should return nil if the dictionary is nil", ^{
            id result = [RNFDictionaryConfigurationHelper classFromKey:@"key" inDictionary:nil];
            [[result should] beNil];
        });
        
        it(@"should return the class if the dictionary contains the key", ^{
            Class result = [RNFDictionaryConfigurationHelper classFromKey:@"key" inDictionary:@{ @"key" : @"NSArray" }];
            [[theValue(result == [NSArray class]) should] beTrue];
        });
        
        it(@"should return nil if the dictionary contains the key but the value is not a valid class", ^{
            id result = [RNFDictionaryConfigurationHelper classFromKey:@"key" inDictionary:@{@"key" : @"ClassNotFound"}];
            [[result should] beNil];
        });
    });
    
    context(@"when instantiating an object from a configuration dictionary based on a protocol", ^{
        it(@"should return nil if the dictionary is nil", ^{
            [[[RNFDictionaryConfigurationHelper objectConformToProtocol:@protocol(RNFResponseValidator) forKey:@"key" inDictionary:nil] should] beNil];
        });
        
        it(@"should return nil if the dictionary doesn't contain the value for the key", ^{
            [[[RNFDictionaryConfigurationHelper objectConformToProtocol:@protocol(RNFResponseValidator) forKey:@"key" inDictionary:@{ @"test" : @"value" }] should] beNil];
        });
        
        it(@"should raise if the value is not a class", ^{
            [[theBlock(^{
                [RNFDictionaryConfigurationHelper objectConformToProtocol:@protocol(RNFResponseValidator) forKey:@"key" inDictionary:@{@"key" : @"ClassNotFound"}];
            }) should] raise];
        });
        
        it(@"should return an object of the class if the value is a class and it conforms to the protocol", ^{
            id obj = [RNFDictionaryConfigurationHelper objectConformToProtocol:@protocol(RNFResponseValidator) forKey:@"key" inDictionary:@{ @"key" : @"RNFYesResponseValidator" }];
            [[theValue([obj isKindOfClass:[RNFYesResponseValidator class]]) should] beTrue];
        });
        
        it(@"should raise if the value is a class but it doesn't conform to the protocol", ^{
            [[theBlock(^{
                [RNFDictionaryConfigurationHelper objectConformToProtocol:@protocol(RNFResponseValidator) forKey:@"key" inDictionary:@{ @"key" : @"RNFJSONResponseDeserializer" }];
            }) should] raise];
        });
        
        it(@"should return an object of the class if the value is a dictionary and the class conforms to RNFInitializableWithDictionary and the protocol", ^{
            id result = [RNFDictionaryConfigurationHelper objectConformToProtocol:@protocol(RNFResponseValidator) forKey:@"key" inDictionary:@{@"key": @{ @"objectClass" : @"RNFStatusCodeResponseValidator" }}];
            [[theValue([result isKindOfClass:[RNFStatusCodeResponseValidator class]]) should] beTrue];
        });
        
        it(@"should raise if the value is a dictionary but there is no class specified", ^{
            [[theBlock(^{
                [RNFDictionaryConfigurationHelper objectConformToProtocol:@protocol(RNFResponseValidator) forKey:@"key" inDictionary:@{
                                    @"key" : @{
                                        @"test" : @2 }
                                    }];
            }) should] raise];
        });
        
        it(@"should raise if the value is a dictionary but the class doesn't conform to RNFInitializableWithDictionary", ^{
            [[theBlock(^{
                [RNFDictionaryConfigurationHelper objectConformToProtocol:@protocol(RNFResponseValidator) forKey:@"key" inDictionary:@{ @"key" : @{ @"objectClass" : @"RNFJSONResponseDeserializer" }}];
            }) should] raise];
        });
        
        it(@"should raise if the value is a dictionary but the class doesn't conform to the protocol", ^{
            [[theBlock(^{
                [RNFDictionaryConfigurationHelper objectConformToProtocol:@protocol(RNFResponseDeserializer) forKey:@"key" inDictionary:@{ @"key" : @{ @"objectClass" : @"RNFStatusCodeResponseValidator" } }];
            }) should] raise];
        });
    });
});

SPEC_END