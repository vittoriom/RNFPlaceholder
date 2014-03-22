//
//  RNFRunnable.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 22/03/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RNFRunnable <NSObject>

/**
 *  Starts a runnable object
 */
- (void) start;

/**
 *  Cancels a runnable object
 */
- (void) cancel;

//- (void) pause;
//
//- (void) resume;

@end
