//
//  RNFParametersParserError.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 15/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  This exception is thrown when the parameter parser encounters a fatal error
 *  (e.g. when a placeholder references an index out of the arguments bounds
 *  or when you try to serialize a non-serializable argument)
 */
@interface RNFParametersParserError : NSException

@end
