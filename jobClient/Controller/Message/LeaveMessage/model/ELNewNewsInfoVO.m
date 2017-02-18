//
//  ELNewNewsInfoVO.m
//  jobClient
//
//  Created by 一览ios on 2016/12/22.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELNewNewsInfoVO.h"

@implementation ELNewNewsInfoVO

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.newsInfoId = value;
    }
}

@end
