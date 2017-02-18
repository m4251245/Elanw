//
//  ELSameTradePeopleModel.m
//  jobClient
//
//  Created by 一览iOS on 16/6/8.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELSameTradePeopleModel.h"

@implementation ELSameTradePeopleModel

-(id)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        NSMutableDictionary *subDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
        NSDictionary *_dynamic = dic[@"_dynamic"];
        if ([_dynamic isKindOfClass:[NSDictionary class]]){
            [subDic removeObjectForKey:@"_dynamic"];
            [subDic addEntriesFromDictionary:_dynamic];
        }
        NSDictionary *_person_info = dic[@"_person_info"];
        if ([_person_info isKindOfClass:[NSDictionary class]]){
            [subDic removeObjectForKey:@"_person_info"];
            [subDic addEntriesFromDictionary:_person_info];
        }
        NSDictionary *group_person_detail = dic[@"group_person_detail"];
        if ([group_person_detail isKindOfClass:[NSDictionary class]]){
            [subDic removeObjectForKey:@"group_person_detail"];
            [subDic addEntriesFromDictionary:group_person_detail];
        }
        NSDictionary *group_perm_list = dic[@"group_perm_list"];
        if ([group_perm_list isKindOfClass:[NSDictionary class]]){
            [subDic removeObjectForKey:@"group_perm_list"];
            [subDic addEntriesFromDictionary:group_perm_list];
        }
        [self setValuesForKeysWithDictionary:subDic];
        self.person_iname = [MyCommon translateHTML:self.person_iname];
        self.person_zw = [MyCommon translateHTML:self.person_zw];
        self.person_job_now = [MyCommon translateHTML:self.person_job_now];
        
        self.person_iname = [MyCommon MyfilterHTML:self.person_iname];
        self.person_zw = [MyCommon MyfilterHTML:self.person_zw];
        self.person_job_now = [MyCommon MyfilterHTML:self.person_job_now];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"expert_detail"]) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            self.expert_detail = [[ELGroupExpertModel alloc] initWithDictionary:value];
        }
    }else if([key isEqualToString:@"count_list"]){
        if ([value isKindOfClass:[NSDictionary class]]) {
            self.count_list = [[ELGroupCountModel alloc] initWithDictionary:value];
        }
    }else{
        [super setValue:value forKey:key];  
    }
}

@end
