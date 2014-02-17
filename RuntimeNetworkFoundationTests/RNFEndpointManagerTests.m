#import "RNFEndpointManager.h"
#import "RNFEndpoint.h"

SPEC_BEGIN(RNFEndpointManagerTests)

describe(@"Endpoint manager", ^{
    __block RNFEndpointManager *manager;
    __block RNFEndpoint *endpoint;
    
    beforeEach(^{
        manager = [RNFEndpointManager new];
        endpoint = [RNFEndpoint new];
    });
    
    context(@"when adding new endpoints", ^{
        it(@"should return NO when adding an empty endpoint", ^{
            [[theValue([manager addEndpoint:endpoint]) should] beFalse];
        });
        
        it(@"should return YES when adding a configured endpoint", ^{
            [[endpoint should] receive:@selector(endpointName) andReturn:@"test"];
            
            [[theValue([manager addEndpoint:endpoint]) should] beTrue];
        });
        
        it(@"should return NO if an endpoint with the same name already exists", ^{
            [[endpoint should] receive:@selector(endpointName) andReturn:@"name1"];
            
            [[theValue([manager addEndpoint:endpoint]) should] beTrue];
            
            RNFEndpoint *endpoint2 = [RNFEndpoint new];
            [[endpoint2 should] receive:@selector(endpointName) andReturn:@"name1"];
            [[theValue([manager addEndpoint:endpoint2]) should] beFalse];
            
            [[[manager endpointWithName:@"name1"] should] equal:endpoint];
        });
    });
    
    context(@"when asked for endpoints with a given name", ^{
        it(@"should return nil if no endpoint is configured", ^{
            [[[manager endpointWithName:@"test"] should] beNil];
        });
        
        it(@"should return the correct endpoint if any", ^{
            [[endpoint should] receive:@selector(endpointName) andReturn:@"test"];
            [manager addEndpoint:endpoint];
            
            [[[manager endpointWithName:@"test"] should] equal:endpoint];
        });
    });
});

SPEC_END