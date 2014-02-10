//
//  RNFLogger.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 10/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    RNFLoggerLevelAll,
    RNFLoggerLevelInfo,
    RNFLoggerLevelWarning,
    RNFLoggerLevelError,
    RNFLoggerLevelFatal,
    RNFLoggerLevelNone
} RNFLoggerLevel;

@protocol RNFLogger <NSObject>

- (void) log:(NSString *)fmt, ...;

- (void) logWithLevel:(RNFLoggerLevel)level message:(NSString *)fmt, ...;

@end
