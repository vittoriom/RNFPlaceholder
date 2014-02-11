//
//  RNFDictionaryConfiguration.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 10/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "RNFDictionaryConfiguration.h"
#import "RNFMalformedConfiguration.h"

@interface RNFDictionaryConfiguration ()

@property (nonatomic, strong) NSDictionary *internalDictionary;

@end

@implementation RNFDictionaryConfiguration

#pragma mark - Initializers

- (instancetype) initWithDictionary:(NSDictionary *)dictionary
{
    self = [self init];
    
    _internalDictionary = dictionary;
    
    [self performSanityCheckOnDictionary:dictionary];
    
    return self;
}

#pragma mark - Sanity checks

- (void) performSanityCheckOnDictionary:(NSDictionary *)dictionary
{
    NSString *errorMessage = nil;
    
    if (![dictionary objectForKey:kRNFConfigurationEndpointBaseURL])
    {
        errorMessage = NSLocalizedString(@"No baseURL is configured for the endpoint", @"");
    } else if(![dictionary objectForKey:kRNFConfigurationEndpointOperations])
    {
        errorMessage = NSLocalizedString(@"No operations are configured for the endpoint", @"");
    }
    
    NSArray *operations = self.operations;
    if([operations count] == 0)
    {
        errorMessage = NSLocalizedString(@"Operations array has 0 elements", @"");
    }
    
    if(errorMessage)
        @throw [[RNFMalformedConfiguration alloc] initWithName:NSStringFromClass([RNFMalformedConfiguration class])
                                                    reason:errorMessage
                                                  userInfo:nil];
}

#pragma mark - Getters

- (NSURL *) baseURL
{
    return [NSURL URLWithString:self.internalDictionary[kRNFConfigurationEndpointBaseURL]];
}

- (NSArray *) operations
{
    return self.internalDictionary[kRNFConfigurationEndpointOperations];
}

@end
