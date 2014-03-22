#import "NSURL+RNFSerializable.h"

SPEC_BEGIN(RNFURLSerializableTests)

describe(@"NSURL", ^{
    it(@"should serialize correctly", ^{
        NSURL *url = [NSURL URLWithString:@"http://www.google.it"];
        [[[url serialize] should] equal:[url absoluteString]];
    });
    
    it(@"should serialize correctly when it's more complex", ^{
        NSURL *url = [NSURL URLWithString:@"http://www.google.it:443/test?q=query&p=parameter#anchor"];
        [[[url serialize] should] equal:[url absoluteString]];
    });
});

SPEC_END