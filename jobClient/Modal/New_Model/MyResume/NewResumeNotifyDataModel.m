//
//  NewResumeNotifyDataModel.m
//  jobClient
//
//  Created by 一览ios on 16/6/3.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "NewResumeNotifyDataModel.h"

@implementation NewResumeNotifyDataModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.positionId = value;
    }
}
@end
