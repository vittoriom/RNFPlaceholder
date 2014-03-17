//
//  RNFLogger.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 10/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RNFEndpoint;

/**
 This enumeration specifies the severity level of a logged event
 */
typedef enum {
    RNFLoggerLevelInfo, ///An event happened
    RNFLoggerLevelWarning, ///Something should be fixed in a later release
    RNFLoggerLevelError, ///An error occurred but the execution can continue
    RNFLoggerLevelFatal ///The error is fatal and cannot be recovered
} RNFLoggerLevel;

/**
 This enumeration lets you use a switch case to handle different events in your logger implementation, if needed
 */
typedef enum {
    RNFLoggerEventCacheMiss, ///This event happens when an operation can't be found in the cache
    RNFLoggerEventCacheHit, ///This event happens when an operation can be found in the cache and its data is used
    RNFLoggerEventOperationFailed, ///This event happens when an operation fails, usually after validation
    RNFLoggerEventOperationFinished, ///This event happens when an operation successfully completes
    RNFLoggerEventOperationCanceled, ///Unused for now
    RNFLoggerEventConfigurationLoaded, ///This event happens when an RNFEndpoint instance loads its configuration
    RNFLoggerEventOperationEnqueued, ///This event happens after a RNFOperation instance is enqueued in a RNFOperationQueue
    RNFLoggerEventAuthenticationSucceeded ///Unused for now
} RNFLoggerEvent;

@protocol RNFLogger <NSObject>

/**
 * Informs the logger that an event happened. The logger can ignore or redirect the log if needed
 * @param event the event that happened. @see RNFLoggerEvent for more information
 * @param level the severity level of the event. @see RNFLoggerLevel for more information
 * @param fmt the usual log message format
 *
 */
- (void) logEvent:(RNFLoggerEvent)event withLevel:(RNFLoggerLevel)level message:(NSString *)fmt, ...;

@end
