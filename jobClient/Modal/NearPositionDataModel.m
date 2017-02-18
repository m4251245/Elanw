//
//  NearPositionDataModel.m
//  jobClient
//
//  Created by 一览ios on 16/6/6.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "NearPositionDataModel.h"

@implementation NearPositionDataModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.positionId = value;
    }
}

@end
