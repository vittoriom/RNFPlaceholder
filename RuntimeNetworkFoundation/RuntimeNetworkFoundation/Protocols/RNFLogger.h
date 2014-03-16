//
//  RNFLogger.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 10/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RNFEndpoint;

typedef enum {
    RNFLoggerLevelAll,
    RNFLoggerLevelInfo,
    RNFLoggerLevelWarning,
    RNFLoggerLevelError,
    RNFLoggerLevelFatal,
    RNFLoggerLevelNone
} RNFLoggerLevel;

typedef enum {
    RNFLoggerEventCacheMiss,
    RNFLoggerEventCacheHit,
    RNFLoggerEventOperationFailed,
    RNFLoggerEventOperationFinished,
    RNFLoggerEventOperationCanceled,
    RNFLoggerEventConfigurationLoaded,
    RNFLoggerEventOperationEnqueued,
    RNFLoggerEventAuthenticationSucceeded
} RNFLoggerEvent;

@protocol RNFLogger <NSObject>

- (void) log:(NSString *)fmt, ...;

- (void) logWithLevel:(RNFLoggerLevel)level message:(NSString *)fmt, ...;

- (BOOL) shouldLogEvent:(RNFLoggerEvent)event;

@end
