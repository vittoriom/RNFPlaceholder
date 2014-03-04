//
//  RNFEndpoint.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 09/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "RNFEndpoint.h"
#import "RNF.h"
#import "RNFPlistConfigurationLoader.h"
#import "RNFParametersParser.h"
#import "RNFUnifiedConfiguration.h"
#import "RNFResponseValidator.h"

#import <objc/runtime.h>

static NSString * const kRNFParsedRuntimeArguments = @"arguments";
static NSString * const kRNFParsedRuntimeErrorBlock = @"errorBlock";
static NSString * const kRNFParsedRuntimeCompletionBlock = @"completionBlock";

@interface RNFEndpoint ()

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) id<RNFConfigurationLoader> configurator;
@property (nonatomic, strong) id<RNFEndpointConfiguration> configuration;

//TODO: remove these as soon as the configuration returns them already
@property (nonatomic, strong) id<RNFOperationQueue> networkQueue;
@property (nonatomic, strong) id<RNFCacheHandler> cacheHandler;
@property (nonatomic, strong) id<RNFLogger> logger;

- (NSArray *) operations;

@end

@implementation RNFEndpoint
{
    BOOL _configurationLoaded;
}

#pragma mark - Initializers

- (id) initWithConfigurator:(id<RNFConfigurationLoader>)configurator
{
    self = [self init];
    
    _configurator = configurator;

    return self;
}

- (id) initWithName:(NSString *)name
{
    id<RNFConfigurationLoader> configurationLoader = [RNFPlistConfigurationLoader RNFConfigurationLoaderForEndpointWithName:name];
    
    self = [self initWithConfigurator:configurationLoader];
    
    //Eagerly load the configuration
    [self loadConfigurationForConfigurator:configurationLoader];
    
    self.name = name;
    
    return self;
}

#pragma mark - Configuration loading

- (id<RNFEndpointConfiguration>) configuration
{
    if(!_configuration)
        [self loadConfigurationForConfigurator:self.configurator];
    
    return _configuration;
}

- (void) loadConfigurationForConfigurator:(id<RNFConfigurationLoader>)configurator
{
    @synchronized(self)
    {
        if(_configurationLoaded)
            return;
        
        if ([configurator respondsToSelector:@selector(load)])
        {
            [configurator load];
        }
        
        _configurationLoaded = YES;
        
        id<RNFEndpointConfiguration> config = [configurator endpointAttributes];
        
        self.name = [config name];
        
        Class operationQueueClass = [config operationQueueClass];
        if(operationQueueClass)
            self.networkQueue = [operationQueueClass new];
        
        Class cacheHandler = [config cacheClass];
        if(cacheHandler)
        {
            if ([cacheHandler respondsToSelector:@selector(cacheHandlerForEndpoint:)])
                self.cacheHandler = [cacheHandler cacheHandlerForEndpoint:self];
            else
                self.cacheHandler = [cacheHandler new];
        }
        
        Class loggerClass = [config logger];
        if (loggerClass)
        {
            if([loggerClass respondsToSelector:@selector(loggerForEndpoint:)])
               self.logger = [loggerClass loggerForEndpoint:self];
            else
               self.logger = [loggerClass new];
        }

        self.configuration = config;
    }
}

#pragma mark - dynamic getters

- (NSURL *) baseURL
{
    if(!_configuration)
        [self loadConfigurationForConfigurator:self.configurator];
    
    return [self.configuration baseURL];
}

- (NSArray *) operations
{
    if(!_configuration)
        [self loadConfigurationForConfigurator:self.configurator];
    
    return [self.configuration operations];
}

#pragma mark - Convenience methods

- (id<RNFOperation>) operationWithName:(NSString *)name
{
    NSArray *operationsArray = [self operations];
    return [operationsArray objectPassingTest:^BOOL(id<RNFOperationConfiguration> operation) {
        return [[operation name] isEqualToString:name];
    }];
}

- (void) handleResponse:(NSData *)response
           forOperation:(id<RNFOperation>)operation
         withStatusCode:(NSInteger)statusCode
                 cached:(BOOL)cached
     usingConfiguration:(RNFUnifiedConfiguration *)unifiedConfiguration
    withCompletionBlock:(RNFCompletionBlockComplete)completion
           failureBlock:(RNFErrorBlock)errorBlock
{
    id<RNFResponseDeserializer> deserializer = [unifiedConfiguration responseDeserializer];
    id deserializedResponse = deserializer ? [deserializer deserializeResponse:response] : response;
    
    id<RNFResponseValidator> validator = [unifiedConfiguration responseValidator];
    NSError *responseError = validator ? [validator responseIsValid:deserializedResponse forOperation:operation withStatusCode:statusCode] : nil;
    
    if(responseError)
    {
        if(cached) //Not handling errors for a cached response
            return;
        
        if(errorBlock)
            errorBlock(deserializedResponse, responseError,statusCode);
        else
            completion(deserializedResponse, operation, statusCode, cached);
        return;
    }
    
    id<RNFDataDeserializer> dataDeserializer = [unifiedConfiguration dataDeserializer];
    deserializedResponse = dataDeserializer ? [dataDeserializer deserializeData:deserializedResponse] : deserializedResponse;
    
    if(completion)
        completion(deserializedResponse, operation, statusCode, cached);
    
    if(!cached && [unifiedConfiguration cacheResults] && [self.cacheHandler operationConfigurationCanBeCached:unifiedConfiguration])
        [self.cacheHandler cacheObject:response withKey:[operation uniqueIdentifier] withCost:[response length]];
}

#pragma mark - Runtime machinery

- (void) forwardInvocation:(NSInvocation *)anInvocation
{
    [anInvocation invoke];
}

- (id) forwardingTargetForSelector:(SEL)aSelector
{
    NSString *selectorAsString = NSStringFromSelector(aSelector);
    
    if(!self.configuration)
    {
        [self loadConfigurationForConfigurator:self.configurator];
    }
    
    NSArray *operations = [self.configuration operations];

	NSInteger indexOfOperation = [operations indexOfObjectPassingTest:^BOOL(id<RNFOperationConfiguration> operation, NSUInteger idx, BOOL *stop) {
        return [[operation name] isEqualToString:selectorAsString];
    }];
    
	if(indexOfOperation == NSNotFound)
		return self;

	id<RNFOperationConfiguration> operationConfiguration = [operations objectAtIndex:indexOfOperation];
	NSUInteger argsCount = [NSMethodSignature numberOfArgumentsForSelector:aSelector];
    
    class_replaceMethod([self class], aSelector, imp_implementationWithBlock(^id<RNFOperation>(RNFEndpoint *endpointSelf, ...){
    	NSDictionary *parsedRuntimeMethodName = ({
            NSMutableDictionary *parsedResult = [NSMutableDictionary new];
            va_list args;
            va_start(args, endpointSelf);
            
            NSMutableArray *argsArray = [NSMutableArray new];
            
            id arg;
            RNFErrorBlock errorBlock = nil;
            RNFCompletionBlockComplete completion = nil;
            for(int i=0; i<argsCount; i++)
            {
                arg = va_arg(args, id);
                [argsArray addObject:arg];
                
                if ([arg isKindOfClass:NSClassFromString(@"NSBlock")]) {
                    if(!completion)
                        completion = arg;
                    else
                        errorBlock = arg;
                }
            }
            
            va_end(args);
            
            parsedResult[kRNFParsedRuntimeArguments] = argsArray;
            
            if(completion)
                parsedResult[kRNFParsedRuntimeCompletionBlock] = completion;
            if(errorBlock)
                parsedResult[kRNFParsedRuntimeErrorBlock] = errorBlock;
            
            parsedResult;
        });
        
        RNFErrorBlock errorBlock = parsedRuntimeMethodName[kRNFParsedRuntimeErrorBlock];
        RNFCompletionBlockComplete completion = parsedRuntimeMethodName[kRNFParsedRuntimeCompletionBlock];
    	RNFUnifiedConfiguration *unifiedConfiguration = [[RNFUnifiedConfiguration alloc] initWithEndpointConfiguration:self.configuration operationConfiguration:operationConfiguration];
        
        NSString *urlString = [unifiedConfiguration URL];
        urlString = [urlString URLStringByAppendingQueryStringParameters:[unifiedConfiguration queryStringParameters]];
        
        RNFParametersParser *parser = [RNFParametersParser new];
        NSURL *operationURL = [NSURL URLWithString:[parser parseString:urlString withArguments:parsedRuntimeMethodName[kRNFParsedRuntimeArguments] userDefinedParametersProvider:[self.configuration userDefinedConfiguration]]];
        
        NSDictionary *headersToUse = [parser parseDictionary:[unifiedConfiguration headers] withArguments:parsedRuntimeMethodName[kRNFParsedRuntimeArguments] userDefinedParametersProvider:[self.configuration userDefinedConfiguration]];
        
        Class operationClass = [unifiedConfiguration operationClass];
        id<RNFOperation> operation = [[operationClass alloc] initWithURL:operationURL
                                                                  method:[unifiedConfiguration HTTPMethod]
                                                                 headers:headersToUse
                                                                    body:[unifiedConfiguration HTTPBody]];
        
        id cachedData = nil;
        if ([self.cacheHandler operationConfigurationCanBeCached:unifiedConfiguration])
            cachedData = [self.cacheHandler cachedObjectWithKey:[operation uniqueIdentifier]];
        
        if (cachedData)
        {
            [self handleResponse:cachedData
                    forOperation:operation
                  withStatusCode:200
                          cached:YES
              usingConfiguration:unifiedConfiguration
             withCompletionBlock:completion
                    failureBlock:errorBlock];
        }
        
        [operation setCompletionBlock:^(id response, id<RNFOperation> operation, NSUInteger statusCode, BOOL cached) {
            [self handleResponse:response
                    forOperation:operation
                  withStatusCode:statusCode
                          cached:cached
              usingConfiguration:unifiedConfiguration
             withCompletionBlock:completion
                    failureBlock:errorBlock];
		} errorBlock:errorBlock];
        
        [self.networkQueue enqueueOperation:operation];
        
        return operation;
    }), [NSMethodSignature methodSignatureForMethodWithArguments:argsCount]);
    
    return self;
}

#pragma mark - RNFOperationQueue

- (void) enqueueOperation:(NSOperation<RNFOperation> *)operation
{
    if (self.networkQueue)
    {
        [self.networkQueue enqueueOperation:operation];
    } else
    {
        //Start immediately
        [operation start];
    }
}

@end
