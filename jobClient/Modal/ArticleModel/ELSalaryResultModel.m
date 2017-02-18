//
//  ELSalaryResultModel.m
//  jobClient
//
//  Created by 一览ios on 16/6/6.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELSalaryResultModel.h"

@implementation ELSalaryResultModel
- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        NSMutableDictionary *subDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
        NSMutableDictionary *firDic = dic[@"_rel_info"];
        
        if ([firDic isKindOfClass:[NSDictionary class]]) {
            [subDic addEntriesFromDictionary:firDic];
        }
       
        [self setValuesForKeysWithDictionary:subDic];
    }
    return self;
}

- (instancetype)initWithSalaryDictionary:(NSDictionary *)dic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"personInfo"]) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            self.userInfo = [[ELUserModel alloc] initWithDictionary:value];
        }
        
    }else if ([key isEqualToString:@"id"]){
        self._id = value; 
    }else{
        [super setValue:value forKey:key];
    }
}

@end
