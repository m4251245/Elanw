//
//  MyDelegateModal.m
//  jobClient
//
//  Created by YL1001 on 16/6/3.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "MyDelegateModal.h"

@implementation MyDelegateModal

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"_person_info"]) {
        NSDictionary *dict = value;
        _person_iname = dict[@"person_iname"];
        _ip = dict[@"ip"];
        _person_pic_personality = dict[@"person_pic_personality"];
        _person_rctype = dict[@"person_rctype"];
        _person_nickname = dict[@"person_nickname"];
        if ([dict[@"_is_expert"] integerValue] == 1 || [dict[@"is_expert"] integerValue] == 1) {
            _is_expert = YES;
        }
        else
        {
            _is_expert = NO;
        }
        
        _person_user_type = dict[@"person_user_type"];
        _person_mobile_quhao = dict[@"person_mobile_quhao"];
        _person_reg_type = dict[@"person_reg_type"];
        _person_idate = dict[@"person_idate"];
        _totalid = dict[@"totalid"];
        _person_sex = dict[@"person_sex"];
        _person_gznum = dict[@"person_gznum"];
        _person_pic = dict[@"person_pic"];
        _person_signature = dict[@"person_signature"];
        _person_email = dict[@"person_email"];
        _person_mobile = dict[@"person_mobile"];
        _person_reg_url = dict[@"person_reg_url"];
        _person_company = dict[@"person_company"];
        _person_age = dict[@"person_age"];
        _personId = dict[@"personId"];
        _tradeid = dict[@"tradeid"];
        _person_job_now = dict[@"person_job_now"];
        _person_zw = dict[@"person_zw"];
    }
    else
    {
        [super setValue:value forKey:key];
    }
}

@end
