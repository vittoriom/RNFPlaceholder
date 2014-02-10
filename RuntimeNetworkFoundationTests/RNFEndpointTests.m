#import "RNFEndpoint.h"
#import "RNFDefaultOperation.h"
#import "RNFOperation.h"
#import "RNFConfigurationLoader.h"

SPEC_BEGIN(RNFEndpointTests)

describe(@"Endpoints", ^{
    __block RNFEndpoint *endpoint;
    
    context(@"when asked for operations", ^{
        beforeEach(^{
            endpoint = [[RNFEndpoint alloc] init];
        });
        
        it(@"should return nil if no operation is configured", ^{
            id operation = [endpoint operationWithName:@"whatever"];
            [[operation should] beNil];
        });
        
        it(@"should return nil if operation parameter is nil", ^{
            id operation = [endpoint operationWithName:nil];
            [[operation should] beNil];
        });
        
        it(@"should return the correct operation if any", ^{
            id operation = [RNFDefaultOperation new];
            [[operation should] receive:@selector(name) andReturn:@"operation1"];
            
            [[endpoint should] receive:@selector(operations) andReturn:@[operation]];
            
            id operationFound = [endpoint operationWithName:@"operation1"];
            [[operation should] equal:operationFound];
        });
        
        it(@"should return the correct operation even in a set of more than one", ^{
            id operation = [RNFDefaultOperation new], operation2 = [RNFDefaultOperation new];
            [[operation should] receive:@selector(name) andReturn:@"operation1"];
            [[operation2 should] receive:@selector(name) andReturn:@"operation2"];
            
            [[endpoint should] receive:@selector(operations) andReturn:@[operation2, operation]];
            
            id operationFound = [endpoint operationWithName:@"operation1"];
            [[operation should] equal:operationFound];
        });
        
        it(@"should return immediately without scanning subsequent operations after finding one", ^{
            id operation = [RNFDefaultOperation new], operation2 = [RNFDefaultOperation new];
            [[operation should] receive:@selector(name) andReturn:@"operation1"];
            [[operation2 shouldNot] receive:@selector(name) andReturn:@"operation2"];
            
            [[endpoint should] receive:@selector(operations) andReturn:@[operation, operation2]];
            
            id operationFound = [endpoint operationWithName:@"operation1"];
            [[operation should] equal:operationFound];
        });
    });
    
    context(@"when initialized with new or init", ^{
        it(@"should not return nil even if there will be no configuration", ^{
            [[[RNFEndpoint new] shouldNot] beNil];
        });
    });
    
    context(@"when initialized with a name", ^{
        beforeEach(^{
            endpoint = [[RNFEndpoint alloc] initWithName:@"sampleConfiguration"];
        });
        
        it(@"should return the correct name if asked", ^{
            [[[endpoint name] should] equal:@"sampleConfiguration"];
        });
        
        it(@"should load a plist configuration with that name", ^{
            NSURL *plistURL = [NSURL URLWithString:@"http://vittoriomonaco.it/api"];
            [[[endpoint baseURL] should] equal:plistURL];
        });
    });
});

SPEC_END