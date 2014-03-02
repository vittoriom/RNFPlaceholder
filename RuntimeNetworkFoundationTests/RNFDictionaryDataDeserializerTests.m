#import "RNFDictionaryDataDeserializer.h"
#import "TestModel.h"
#import "TestKVC.h"

SPEC_BEGIN(RNFDictionaryDataDeserializerTests)

describe(@"Dictionary-based data deserializer", ^{
    __block RNFDictionaryDataDeserializer *deserializer;
    
    context(@"when initialized with a malformed dictionary", ^{
        it(@"should return the source object if initialized with an empty dictionary", ^{
            deserializer = [[RNFDictionaryDataDeserializer alloc] initWithDictionary:@{}];
            NSDictionary *data = @{ @"test" : @"value", @"key" : @3 };
            [[[deserializer deserializeData:data] should] equal:data];
        });
        
        it(@"should return the source object if initialized with a nil dictionary", ^{
            deserializer = [[RNFDictionaryDataDeserializer alloc] initWithDictionary:nil];
            NSDictionary *data = @{ @"test" : @"value", @"key" : @3 };
            [[[deserializer deserializeData:data] should] equal:data];
        });
        
        it(@"should return the source object if no mapping is specified", ^{
            deserializer = [[RNFDictionaryDataDeserializer alloc] initWithDictionary:@{
                                                                                       kRNFDictionaryDataDeserializerOnlyDeserializedMappedKeys : @NO
                                                                                       }];
            NSDictionary *data = @{ @"test" : @"value", @"key" : @3 };
            [[[deserializer deserializeData:data] should] equal:data];
        });
        
        it(@"should return the source object if the normal initializer is used", ^{
            deserializer = [[RNFDictionaryDataDeserializer alloc] init];
            NSDictionary *data = @{ @"test" : @"value", @"key" : @3 };
            [[[deserializer deserializeData:data] should] equal:data];
        });
    });
    
    context(@"when initialized with a proper dictionary", ^{
        it(@"should return the modified dictionary if only the mappings are specified", ^{
            deserializer = [[RNFDictionaryDataDeserializer alloc] initWithDictionary:@{
                                                                                       kRNFDictionaryDataDeserializerOnlyDeserializedMappedKeys : @YES,
                                                                                       kRNFDictionaryDataDeserializerMappings : @{
                                                                                               @"identifier" : @"uID",
                                                                                               @"test" : @"proper"
                                                                                               }
                                                                                       }];
            NSDictionary *data = @{ @"test" : @"value", @"identifier" : @3, @"notIncluded" : @[ @1, @2 ] };
            [[[deserializer deserializeData:data] should] equal:@{ @"uID" : @3, @"proper" : @"value" }];
        });
        
        it(@"should return the target class initialized with the mappings if it conforms to RNFInitializableWithDictionary", ^{
            deserializer = [[RNFDictionaryDataDeserializer alloc] initWithDictionary:@{
                                                                                       kRNFDictionaryDataDeserializerOnlyDeserializedMappedKeys : @YES,
                                                                                       kRNFDictionaryDataDeserializerMappings : @{
                                                                                               @"identifier" : @"uID",
                                                                                               @"test" : @"name"
                                                                                               },
                                                                                       kRNFDictionaryDataDeserializerTargetClass : @"TestModel"
                                                                                       }];
            NSDictionary *data = @{ @"test" : @"value", @"identifier" : @3, @"notIncluded" : @[ @1, @2 ] };
            TestModel *output = [deserializer deserializeData:data];
            [[theValue([output isKindOfClass:[TestModel class]]) should] beTrue];
            [[output.name should] equal:@"value"];
            [[output.ID should] equal:@3];
        });
        
        it(@"should return the target class with KVC properties setup if it doesn't conform to RNFInitializableWithDictionary", ^{
            deserializer = [[RNFDictionaryDataDeserializer alloc] initWithDictionary:@{
                                                                                       kRNFDictionaryDataDeserializerOnlyDeserializedMappedKeys : @YES,
                                                                                       kRNFDictionaryDataDeserializerMappings : @{
                                                                                               @"identifier" : @"ID",
                                                                                               @"test" : @"name"
                                                                                               },
                                                                                       kRNFDictionaryDataDeserializerTargetClass : @"TestKVC"
                                                                                       }];
            NSDictionary *data = @{ @"test" : @"value", @"identifier" : @3, @"notIncluded" : @[ @1, @2 ] };
            TestKVC *output = [deserializer deserializeData:data];
            [[theValue([output isKindOfClass:[TestKVC class]]) should] beTrue];
            [[output.name should] equal:@"value"];
            [[output.ID should] equal:@3];
        });
        
        it(@"should handle nested deserialization for 2 levels",^{
            deserializer = [[RNFDictionaryDataDeserializer alloc] initWithDictionary:@{
                                                                                       kRNFDictionaryDataDeserializerOnlyDeserializedMappedKeys : @YES,
                                                                                       kRNFDictionaryDataDeserializerMappings : @{
                                                                                               @"identifier" : @"uID",
                                                                                               @"test" : @"name",
                                                                                               @"nested" : @{
                                                                                                       @"objectClass" : @"RNFDictionaryDataDeserializer",
                                                                                                       kRNFDictionaryDataDeserializerOnlyDeserializedMappedKeys : @NO,
                                                                                                       kRNFDictionaryDataDeserializerTargetClass : @"TestKVC",
                                                                                                       kRNFDictionaryDataDeserializerMappings : @{
                                                                                                               @"uID" : @"ID",
                                                                                                               @"nachname" : @"name"
                                                                                                               }
                                                                                                       }
                                                                                               },
                                                                                       kRNFDictionaryDataDeserializerTargetClass : @"TestModel"
                                                                                       }];
            NSDictionary *data = @{ @"test" : @"value", @"identifier" : @3, @"notIncluded" : @[ @1, @2 ], @"nested" : @{ @"uID" : @4, @"nachname" : @"nestedWorks" } };
            TestModel *output = [deserializer deserializeData:data];
            [[theValue([output isKindOfClass:[TestModel class]]) should] beTrue];
            [[output.name should] equal:@"value"];
            [[output.ID should] equal:@3];
            
            TestKVC *kvc = [output kvcProperty];
            [[[kvc name] should] equal:@"nestedWorks"];
            [[[kvc ID] should] equal:@4];
        });
        
        it(@"should handle nested deserialization for 3 levels", ^{
            deserializer = [[RNFDictionaryDataDeserializer alloc] initWithDictionary:@{
                                                                                       kRNFDictionaryDataDeserializerOnlyDeserializedMappedKeys : @YES,
                                                                                       kRNFDictionaryDataDeserializerMappings : @{
                                                                                               @"identifier" : @"uID",
                                                                                               @"test" : @"name",
                                                                                               @"nested" : @{
                                                                                                       @"objectClass" : @"RNFDictionaryDataDeserializer",
                                                                                                       kRNFDictionaryDataDeserializerOnlyDeserializedMappedKeys : @NO,
                                                                                                       kRNFDictionaryDataDeserializerTargetClass : @"TestKVC",
                                                                                                       kRNFDictionaryDataDeserializerMappings : @{
                                                                                                               @"uID" : @"ID",
                                                                                                               @"nachname" : @"name",
                                                                                                               @"nested" : @{
                                                                                                                       @"objectClass" : @"RNFDictionaryDataDeserializer",
                                                                                                                       kRNFDictionaryDataDeserializerOnlyDeserializedMappedKeys : @YES,
                                                                                                                       kRNFDictionaryDataDeserializerTargetClass : @"TestModel",
                                                                                                                       kRNFDictionaryDataDeserializerMappings : @{
                                                                                                                               @"levelID" : @"uID",
                                                                                                                               @"levelName" : @"name"
                                                                                                                               }
                                                                                                                       }
                                                                                                               }
                                                                                                       }
                                                                                               },
                                                                                       kRNFDictionaryDataDeserializerTargetClass : @"TestModel"
                                                                                       }];
            NSDictionary *data = @{
                                   @"test" : @"value",
                                   @"identifier" : @3,
                                   @"notIncluded" : @[ @1, @2 ],
                                   @"nested" : @{
                                           @"uID" : @4,
                                           @"nachname" : @"nestedWorks",
                                           @"nested" : @{
                                                   @"levelID" : @2,
                                                   @"levelName" : @"ubernested"
                                                   }
                                           }
                                   };
            TestModel *output = [deserializer deserializeData:data];
            [[theValue([output isKindOfClass:[TestModel class]]) should] beTrue];
            [[output.name should] equal:@"value"];
            [[output.ID should] equal:@3];
            
            TestKVC *kvc = [output kvcProperty];
            [[[kvc name] should] equal:@"nestedWorks"];
            [[[kvc ID] should] equal:@4];
            
            TestModel *nested = [kvc nested];
            [[[nested name] should] equal:@"ubernested"];
            [[[nested ID] should] equal:@2];
            [[[nested kvcProperty] should] beNil];
        });
    });
});

SPEC_END