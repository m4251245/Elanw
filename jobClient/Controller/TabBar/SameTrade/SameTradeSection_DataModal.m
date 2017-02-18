//
//  SameTradeSection_DataModal.m
//  jobClient
//
//  Created by 一览ios on 15/3/19.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "SameTradeSection_DataModal.h"

@implementation SameTradeSection_DataModal

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.title = dict[@"desc"];
        self.dataArray = dict[@"dataArr"];
        self.type = dict[@"type"];
    }
    return self;
}

@end
