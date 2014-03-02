//
//  TestModel.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 26/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNFInitializableWithDictionary.h"
#import "TestKVC.h"

@interface TestModel : NSObject <RNFInitializableWithDictionary>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) TestKVC *kvcProperty;

@end
