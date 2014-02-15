#import "RNFJSONResponseDeserializer.h"

SPEC_BEGIN(RNFJSONResponseDeserializerTests)

describe(@"JSON response deserializer", ^{
    __block RNFJSONResponseDeserializer *deserializer;
    
    beforeAll(^{
        deserializer = [RNFJSONResponseDeserializer new];
    });
    
    context(@"when fed with a nil pointer", ^{
        it(@"should return nil", ^{
            [[[deserializer deserializeResponse:nil] should] beNil];
        });
    });
    
    context(@"when fed with an invalid JSON object", ^{
        it(@"should return nil", ^{
            NSString *fakeJSON = @"{ \"key\" : \"value\", \"key2\" : \"value2\", \"complexKey\" : { \"key\" : \"value\" }";
            NSData *fakeData = [fakeJSON dataUsingEncoding:NSUTF8StringEncoding];
            
            [[[deserializer deserializeResponse:fakeData] should] beNil];
        });
    });
    
    context(@"when fed with a proper JSON object", ^{
        it(@"should return a valid object", ^{
            NSDictionary *sample = @{
                                     @"key" : @"value",
                                     @"key2" : @"value2",
                                     @"key3" : @[
                                             @"one",
                                             @"two",
                                             @"three"
                                             ],
                                     @"key4" : @{
                                             @"key" : @"value"
                                             }
                                     };
            
            NSData *sampleData = [NSJSONSerialization dataWithJSONObject:sample
                                                                 options:0
                                                                   error:nil];
            
            id JSONObject = [deserializer deserializeResponse:sampleData];
            
            [[JSONObject shouldNot] beNil];
            [[[JSONObject allKeys] should] haveCountOf:4];
            [[[JSONObject objectForKey:@"key"] should] equal:@"value"];
            [[[JSONObject objectForKey:@"key3"] should] haveCountOf:3];
            [[[[JSONObject objectForKey:@"key4"] allKeys] should] haveCountOf:1];
            [[[[JSONObject objectForKey:@"key3"] objectAtIndex:1] should] equal:@"two"];
        });
    });
});

SPEC_END