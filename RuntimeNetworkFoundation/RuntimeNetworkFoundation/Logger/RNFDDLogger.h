//
//  RNFDDLogger.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 22/03/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#if defined(__has_include)
#if __has_include(<CocoaLumberjack/DDLog.h>)
#import <Foundation/Foundation.h>

#ifndef LOG_LEVEL_DEF
#define LOG_LEVEL_DEF LOG_LEVEL_ERROR
#endif 

#import <CocoaLumberjack/DDLog.h>
#import "RNFLogger.h"

/**
 *  A DDLog based implementation of RNFLogger in case you use CocoaLumberjack in your application
 *  This implementation assumes that the static int variable ddLogLevel is already defined in the pch file of the project.
 *  If this is not the case, the compiler will throw an error because the ddLogLevel won't be visible.
 */
@interface RNFDDLogger : NSObject <RNFLogger>

@end

#endif
#endif