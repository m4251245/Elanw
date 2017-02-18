//
//  ELUserJobModel.m
//  jobClient
//
//  Created by 一览ios on 16/6/14.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELUserJobModel.h"

@implementation ELUserJobModel
- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
@end
