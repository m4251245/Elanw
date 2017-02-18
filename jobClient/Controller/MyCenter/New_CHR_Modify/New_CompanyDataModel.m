//
//  New_CompanyDataModel.m
//  jobClient
//
//  Created by 一览ios on 16/9/20.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "New_CompanyDataModel.h"

@implementation New_CompanyDataModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.cId = value;
    }
}
@end
