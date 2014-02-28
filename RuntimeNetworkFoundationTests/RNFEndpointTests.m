#import "RNFBaseOperation.h"
#import "RNFEndpoint.h"
#import "RNFOperation.h"
#import "RNFDictionaryOperationConfiguration.h"
#import "RNFConfigurationLoader.h"
#import "RNFPlistConfigurationLoader.h"
#import "RNFDictionaryEndpointConfiguration.h"
#import "RNFConfigurationNotFound.h"

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
            id operation = [RNFDictionaryOperationConfiguration new];
            [[operation should] receive:@selector(name) andReturn:@"operation1"];
            
            [[endpoint should] receive:@selector(operations) andReturn:@[operation]];
            
            id operationFound = [endpoint operationWithName:@"operation1"];
            [[operation should] equal:operationFound];
        });
        
        it(@"should return the correct operation even in a set of more than one", ^{
            id operation = [RNFDictionaryOperationConfiguration new], operation2 = [RNFDictionaryOperationConfiguration new];
            [[operation should] receive:@selector(name) andReturn:@"operation1"];
            [[operation2 should] receive:@selector(name) andReturn:@"operation2"];
            
            [[endpoint should] receive:@selector(operations) andReturn:@[operation2, operation]];
            
            id operationFound = [endpoint operationWithName:@"operation1"];
            [[operation should] equal:operationFound];
        });
        
        it(@"should return immediately without scanning subsequent operations after finding one", ^{
            id operation = [RNFDictionaryOperationConfiguration new], operation2 = [RNFDictionaryOperationConfiguration new];
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
        
        it(@"should return a nil configuration object", ^{
            RNFEndpoint *endpoint = [RNFEndpoint new];
            id configuration = [endpoint configuration];
            [[configuration should] beNil];
        });
    });
    
    context(@"when initialized with a name", ^{
        beforeAll(^{
            endpoint = [[RNFEndpoint alloc] initWithName:@"sampleConfiguration"];
        });
        
//        it(@"should return the correct name if asked", ^{
//            NSString *endpointName = nil;
//            endpointName = [endpoint name];
//            [[endpointName shouldNot] beNil];
//            [[endpointName should] equal:@"sampleConfiguration"];
//        });
        
        it(@"should load a plist configuration with that name", ^{
            NSURL *plistURL = [NSURL URLWithString:@"http://vittoriomonaco.it/api"];
            [[[endpoint baseURL] should] equal:plistURL];
        });
        
        it(@"should throw an exception if the plist is not found", ^{
            [[theBlock(^{
                id dummy = [[RNFEndpoint alloc] initWithName:@"notFound"];
                [dummy description];
            }) should] raise];
        });
        
        it(@"should return the configuration object", ^{
            id configuration = [endpoint configuration];
            [[theValue([configuration isKindOfClass:[RNFDictionaryEndpointConfiguration class]]) should] beTrue];
        });
    });
    
    context(@"when initialized with a configurator", ^{
        it(@"should not load the attributes eagerly", ^{
            RNFPlistConfigurationLoader *configurationLoader = [[RNFPlistConfigurationLoader alloc] initWithPlistName:@"sampleConfiguration"];
            [[configurationLoader shouldNot] receive:@selector(endpointAttributes)];
            RNFEndpoint *endpoint = [[RNFEndpoint alloc] initWithConfigurator:configurationLoader];
            [endpoint description];
        });
        
        it(@"should load the attributes when asked the first time", ^{
            RNFPlistConfigurationLoader *configurationLoader = [[RNFPlistConfigurationLoader alloc] initWithPlistName:@"sampleConfiguration"];
            RNFEndpoint *endpoint = [[RNFEndpoint alloc] initWithConfigurator:configurationLoader];
            [[[endpoint baseURL] should] equal:[NSURL URLWithString:@"http://vittoriomonaco.it/api"]];
        });
        
        it(@"should return the configuration object", ^{
            RNFPlistConfigurationLoader *configurationLoader = [[RNFPlistConfigurationLoader alloc] initWithPlistName:@"sampleConfiguration"];
            RNFEndpoint *endpoint = [[RNFEndpoint alloc] initWithConfigurator:configurationLoader];
            id configuration = [endpoint configuration];
            [[theValue([configuration isKindOfClass:[RNFDictionaryEndpointConfiguration class]]) should] beTrue];
        });
    });
});

SPEC_END