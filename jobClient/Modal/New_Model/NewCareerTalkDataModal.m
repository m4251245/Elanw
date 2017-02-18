//
//  NewCareerTalkDataModal.m
//  jobClient
//
//  Created by 一览ios on 16/6/2.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "NewCareerTalkDataModal.h"

@implementation NewCareerTalkDataModal

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.xjhId = value;
    }
    if ([key isEqualToString:@"care"]) {
        self.attention = value;
    }
}
@end
