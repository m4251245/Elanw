//
//  New_PersonDataModel.m
//  jobClient
//
//  Created by 一览ios on 16/5/10.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "New_PersonDataModel.h"

@implementation New_PersonDataModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.myResumeId = value;
    }
    if ([key isEqualToString:@"template"]) {
        self.mytemplate = value;
    }
}

@end
