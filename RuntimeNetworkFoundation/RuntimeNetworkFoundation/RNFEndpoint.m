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

static NSString * const kRNFParsedRuntimeArguments = @"rnf_arguments";
static NSString * const kRNFParsedRuntimeErrorBlock = @"rnf_errorBlock";
static NSString * const kRNFParsedRuntimeCompletionBlock = @"rnf_completionBlock";

@interface RNFEndpoint ()

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) id<RNFConfigurationLoader> configurator;
@property (nonatomic, strong) id<RNFEndpointConfiguration> configuration;
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

+ (NSDateFormatter *) expirationDateFormatter
{
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [NSDateFormatter new];
        formatter.dateFormat = @"ddd, dd MMM yyyy HH:mm:ss 'GMT'";
    });
    
    return formatter;
}

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
        
        self.logger = [config logger];
        
        self.configuration = config;
        
        if (self.logger)
        {
            [self.logger logEvent:RNFLoggerEventConfigurationLoaded withLevel:RNFLoggerLevelInfo message:[NSString stringWithFormat:@"Configuration successfully loaded for endpoint %@ with name %@",self, self.name]];
        }
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
    return [operationsArray rnf_objectPassingTest:^BOOL(id<RNFOperationConfiguration> operation) {
        return [[operation name] isEqualToString:name];
    }];
}

- (void) handleResponse:(NSData *)response
        withURLResponse:(NSURLResponse *)urlResponse
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
        
        if (self.logger)
        {
            [self.logger logEvent:RNFLoggerEventOperationFailed withLevel:RNFLoggerLevelError message:[NSString stringWithFormat:@"Operation %@ failed with error %@",operation, responseError]];
        }
        
        if(errorBlock)
            errorBlock(deserializedResponse, responseError,statusCode);
        else
            completion(deserializedResponse, operation, statusCode, cached, urlResponse);
        return;
    }
    
    id<RNFDataDeserializer> dataDeserializer = [unifiedConfiguration dataDeserializer];
    deserializedResponse = dataDeserializer ? [dataDeserializer deserializeData:deserializedResponse] : deserializedResponse;
    
    if (self.logger)
    {
        [self.logger logEvent:RNFLoggerEventOperationFinished withLevel:RNFLoggerLevelInfo message:[NSString stringWithFormat:@"Operation %@ finished with status code %d, was cached: %d, data %@",operation, statusCode, cached, deserializedResponse]];
    }
    
    if(completion)
        completion(deserializedResponse, operation, statusCode, cached, urlResponse);
    
    if(!cached && [unifiedConfiguration cacheResults] && [self.cacheHandler operationConfigurationCanBeCached:unifiedConfiguration])
    {
        NSDate *validity = nil;
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)urlResponse;
        NSDictionary *headers = [httpResponse allHeaderFields];
        NSString *cacheControl = [headers valueForKey:@"Cache-Control"];
        NSString *expires = [headers valueForKey:@"Expires"];
        if (cacheControl)
        {
            NSRange validityRange = [cacheControl rangeOfString:@"max-cache="];
            if (validityRange.location != NSNotFound)
            {
                validity = [NSDate dateWithTimeIntervalSinceNow:[[cacheControl substringFromIndex:validityRange.location + validityRange.length] integerValue]];
            }
        } else if(expires)
        {
            validity = [[RNFEndpoint expirationDateFormatter] dateFromString:expires];
        }
        
        [self.cacheHandler cacheObject:response
                               withKey:[operation uniqueIdentifier]
                              withCost:[NSNumber numberWithUnsignedInteger:[response length]]
                            validUntil:validity];
    }
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
                if (arg)
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
            if (self.logger)
            {
                [self.logger logEvent:RNFLoggerEventCacheHit withLevel:RNFLoggerLevelInfo message:[NSString stringWithFormat:@"Cache hit for operation %@",operation]];
            }
            [self handleResponse:cachedData
                 withURLResponse:nil
                    forOperation:operation
                  withStatusCode:200
                          cached:YES
              usingConfiguration:unifiedConfiguration
             withCompletionBlock:completion
                    failureBlock:errorBlock];
        } else
        {
            if (self.logger)
            {
                [self.logger logEvent:RNFLoggerEventCacheMiss withLevel:RNFLoggerLevelInfo message:[NSString stringWithFormat:@"Cache miss for operation %@",operation]];
            }
        }
        
        [operation setCompletionBlock:^(id response, id<RNFOperation> operation, NSUInteger statusCode, BOOL cached, NSURLResponse *urlResponse) {
            [self handleResponse:response
                 withURLResponse:urlResponse
                    forOperation:operation
                  withStatusCode:statusCode
                          cached:cached
              usingConfiguration:unifiedConfiguration
             withCompletionBlock:completion
                    failureBlock:errorBlock];
		} errorBlock:errorBlock];
        
        if (!cachedData || ![self.cacheHandler cachedDataIsValidWithKey:[operation uniqueIdentifier]])
        {
            [self.networkQueue enqueueOperation:operation];
            if (self.logger)
            {
                [self.logger logEvent:RNFLoggerEventOperationEnqueued withLevel:RNFLoggerLevelInfo message:[NSString stringWithFormat:@"Operation %@ enqueued for execution",operation]];
            }
        }
        
        return operation;
    }), [NSMethodSignature methodSignatureForMethodWithArguments:argsCount]);
    
    return self;
}

#pragma mark - RNFOperationQueue

- (void) enqueueOperation:(id<RNFOperation>)operation
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
