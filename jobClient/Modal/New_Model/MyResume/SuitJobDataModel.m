//
//  SuitJobDataModel.m
//  jobClient
//
//  Created by 一览ios on 16/5/18.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "SuitJobDataModel.h"

@implementation SuitJobDataModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.suitId = value;
    }
}

@end
