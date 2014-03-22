//
//  RNFNSLogger.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 17/03/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNFLogger.h"

/**
 A very basic RNFLogger implementation that just outputs everything on NSLog prepending the message with the log level and the logged event
 */
@interface RNFNSLogger : NSObject <RNFLogger>

@end
