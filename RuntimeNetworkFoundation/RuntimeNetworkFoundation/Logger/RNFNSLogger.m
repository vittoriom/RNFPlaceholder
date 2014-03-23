//
//  RNFNSLogger.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 17/03/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "RNFNSLogger.h"

@implementation RNFNSLogger

- (void) logEvent:(RNFLoggerEvent)event withLevel:(RNFLoggerLevel)level message:(NSString *)message
{
    NSLog(@"%@ - %@",[self humanReadableLogLevel:level], message);
}

- (NSString *) humanReadableLoggerEvent:(RNFLoggerEvent)event
{
    switch (event)
    {
        case RNFLoggerEventAuthenticationSucceeded:
            return @"Authentication succeeded";
            break;
        case RNFLoggerEventCacheHit:
            return @"Cache hit";
            break;
        case RNFLoggerEventCacheMiss:
            return @"Cache miss";
            break;
        case RNFLoggerEventOperationFailed:
            return @"Operation failed";
            break;
        case RNFLoggerEventConfigurationLoaded:
            return @"Configuration loaded";
            break;
        case RNFLoggerEventOperationCanceled:
            return @"Operation was canceled";
            break;
        case RNFLoggerEventOperationEnqueued:
            return @"Operation enqueued";
            break;
        case RNFLoggerEventOperationFinished:
            return @"Operation finished";
            break;
        default:
            return @"Unknown event";
            break;
    }
}

- (NSString *) humanReadableLogLevel:(RNFLoggerLevel)level
{
    switch (level) {
        case RNFLoggerLevelInfo:
            return @"INFO";
        case RNFLoggerLevelError:
            return @"ERROR";
        case RNFLoggerLevelFatal:
            return @"FATAL";
        case RNFLoggerLevelWarning:
            return @"WARNING";
        default:
            return @"UNKNOWN";
    }
}

@end
