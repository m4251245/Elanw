//
//  SalaryResult_DataModal.m
//  jobClient
//
//  Created by YL1001 on 14-9-24.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "SalaryResult_DataModal.h"

@implementation SalaryResult_DataModal
- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        NSMutableDictionary *subDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
        [subDic removeObjectForKey:@"_rel_info"];
        NSMutableDictionary *firDic = dic[@"_rel_info"];
        NSDictionary *secDic = firDic[@"personInfo"];
        [firDic removeObjectForKey:@"personInfo"];
        if ([firDic isKindOfClass:[NSDictionary class]]) {
            [subDic addEntriesFromDictionary:firDic];
        }
        if ([secDic isKindOfClass:[NSDictionary class]]) {
            [subDic addEntriesFromDictionary:secDic];
        }
        [self setValuesForKeysWithDictionary:subDic];
        
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
