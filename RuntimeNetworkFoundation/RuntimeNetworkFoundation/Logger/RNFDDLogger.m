//
//  RNFDDLogger.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 22/03/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "RNFDDLogger.h"

@implementation RNFDDLogger

- (void) logEvent:(RNFLoggerEvent)event withLevel:(RNFLoggerLevel)level message:(NSString *)message
{
#ifdef DDLogInfo
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
#else
    NSLog(@"%@ - %@",[self humanReadableLogLevel:level],message);
#endif
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
