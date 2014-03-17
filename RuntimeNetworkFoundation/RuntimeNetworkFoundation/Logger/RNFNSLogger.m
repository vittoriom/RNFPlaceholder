//
//  RNFNSLogger.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 17/03/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "RNFNSLogger.h"

@implementation RNFNSLogger

- (void) logEvent:(RNFLoggerEvent)event withLevel:(RNFLoggerLevel)level message:(NSString *)fmt, ...
{
    va_list args;
    va_start(args, fmt);
    NSLog([NSString stringWithFormat:@"%@ - %@",[self humanReadableLogLevel:level],fmt],args);
    va_end(args);
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
