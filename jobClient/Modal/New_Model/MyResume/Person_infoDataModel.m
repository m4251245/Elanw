//
//  Person_infoDataModel.m
//  jobClient
//
//  Created by 一览ios on 16/5/13.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "Person_infoDataModel.h"

@implementation Person_infoDataModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.myId = value;
    }
    
}
@end
