//
//  ELGroupPersonDetialModel.m
//  jobClient
//
//  Created by 一览iOS on 16/6/12.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELGroupPersonDetialModel.h"

@implementation ELGroupPersonDetialModel

-(id)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        NSDictionary *relDic = dic[@"group_perm_list"];
        NSMutableDictionary *subDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
        if ([relDic isKindOfClass:[NSDictionary class]]) {
            [subDic removeObjectForKey:@"group_perm_list"];
            [subDic addEntriesFromDictionary:relDic];
        }
        [self setValuesForKeysWithDictionary:subDic];
        self.person_iname = [MyCommon translateHTML:self.person_iname];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"group_person_detail"]) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            self.group_person_detail = [[ELSameTradePeopleModel alloc] initWithDictionary:value];
        }
    }else{
        [super setValue:value forKey:key];
    }
}

@end
