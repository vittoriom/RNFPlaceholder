//
//  TestKVC.h
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 02/03/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TestModel;

@interface TestKVC : NSObject

@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) TestModel *nested;
@property (nonatomic, strong) NSString *name;

@end
