//
//  ELGroupDetailModal.m
//  jobClient
//
//  Created by 一览iOS on 16/6/3.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELGroupDetailModal.h"

@implementation ELGroupDetailModal

-(id)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        NSMutableDictionary *subDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
        NSDictionary *group_person_detail = dic[@"group_person_detail"];
        if ([group_person_detail isKindOfClass:[NSDictionary class]]){
            [subDic removeObjectForKey:@"group_person_detail"];
            [subDic addEntriesFromDictionary:group_person_detail];
        }
        NSDictionary *user_rel = dic[@"user_rel"];
        if ([user_rel isKindOfClass:[NSDictionary class]]){
            [subDic removeObjectForKey:@"user_rel"];
            [subDic addEntriesFromDictionary:user_rel];
        }
        NSDictionary *group_perm_list = dic[@"group_perm_list"];
        if ([group_perm_list isKindOfClass:[NSDictionary class]]){
            [subDic removeObjectForKey:@"group_perm_list"];
            [subDic addEntriesFromDictionary:group_perm_list];
        }
        NSDictionary *group_person_info = dic[@"group_person_info"];
        if ([group_person_info isKindOfClass:[NSDictionary class]]){
            [subDic removeObjectForKey:@"group_person_info"];
            [subDic addEntriesFromDictionary:group_person_info];
        }
        [self setValuesForKeysWithDictionary:subDic];
        self.group_name = [MyCommon translateHTML:self.group_name];
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
    }
    else if ([key isEqualToString:@"push_set"]) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            self.setcode = [value objectForKey:@"setcode"];
        }
    }
    else{
        [super setValue:value forKey:key];
    }
}

-(id)initWithGroupDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        NSMutableDictionary *subDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
        NSDictionary *group_perm_list = dic[@"group_perm_list"];
        if ([group_perm_list isKindOfClass:[NSDictionary class]]){
            [subDic removeObjectForKey:@"group_perm_list"];
            [subDic addEntriesFromDictionary:group_perm_list];
        }
        [self setValuesForKeysWithDictionary:subDic];
    }
    return self;
}

@end
