//
//  RNFDDLogger.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 22/03/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNFLogger.h"

/**
 *  A DDLog based implementation of RNFLogger in case you use CocoaLumberjack in your application
 */
@interface RNFDDLogger : NSObject <RNFLogger>

@end
