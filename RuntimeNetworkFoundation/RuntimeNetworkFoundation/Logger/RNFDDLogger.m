//
//  RNFDDLogger.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 22/03/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#if defined(__has_include)
#if __has_include(<CocoaLumberjack/DDLog.h>)
#import "RNFDDLogger.h"

@implementation RNFDDLogger

- (void) logEvent:(RNFLoggerEvent)event withLevel:(RNFLoggerLevel)level message:(NSString *)message
{
    switch (level)
    {
        case RNFLoggerLevelInfo:
            DDLogInfo(@"%@ - %@",[self humanReadableLogLevel:level],message);
            break;
        case RNFLoggerLevelWarning:
            DDLogWarn(@"%@ - %@",[self humanReadableLogLevel:level],message);
            break;
        case RNFLoggerLevelError:
        case RNFLoggerLevelFatal:
            DDLogError(@"%@ - %@",[self humanReadableLogLevel:level],message);
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

#endif
#endif