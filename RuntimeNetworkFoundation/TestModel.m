//
//  TestModel.m
//  RuntimeNetworkFoundation
//
//  Created by Vittorio Monaco on 26/02/14.
//  Copyright (c) 2014 Vittorio Monaco. All rights reserved.
//

#import "TestModel.h"

@implementation TestModel

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
    self = [self init];
    
    _name = [dict objectForKey:@"name"];
    _ID = [dict objectForKey:@"uID"];
    _kvcProperty = [dict objectForKey:@"nested"];
    _list = [dict objectForKey:@"list"];
    
    return self;
}

@end
