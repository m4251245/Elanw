//
//  CompanyResumePrevierwModel.m
//  jobClient
//
//  Created by YL1001 on 16/9/21.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "CompanyResumePrevierwModel.h"

@implementation CompanyResumePrevierwModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"company_person_result"]) {
        
        NSDictionary *dict = value;
        if (![dict isEqual:@""]) {
            _forkey = dict[@"forkey"];
            _reid = dict[@"reid"];
            _isshow = dict[@"isshow"];
            _uid = dict[@"id"];
            _sysupdatetime = dict[@"sysupdatetime"];
            _uids = dict[@"uids"];
            _isDel = dict[@"isDel"];
            _process_state = dict[@"process_state"];
            _newmail = dict[@"newmail"];
            _company_state = dict[@"company_state"];
            _work_state = dict[@"work_state"];
            _action_state = dict[@"action_state"];
            _tj_laber = dict[@"tj_laber"];
            _jobid = dict[@"job_id"];
        }
        
    }
    else if ([key isEqualToString:@"send_to_me_result"])
    {
        NSDictionary *dict = value;
        if (![dict isEqual:@""]) {
            _state = dict[@"state"];
            _type = dict[@"type"];
            _newmail = dict[@"newmail"];
            _sr_accept_m_id = dict[@"sr_accept_m_id"];
            _totalid = dict[@"totalid"];
            _company_id = dict[@"company_id"];
            _sr_send_m_id = dict[@"sr_send_m_id"];
            _jobname = dict[@"jobname"];
            _sr_idate = dict[@"sr_idate"];
            _jobid = dict[@"jobid"];
            _person_id = dict[@"person_id"];
            _sr_content = dict[@"sr_content"];
            _person_type = dict[@"person_type"];
            _person_iname = dict[@"person_iname"];
            _cmailbox_id = dict[@"cmailbox_id"];
            _tradeid = dict[@"tradeid"];
            _sr_id = dict[@"sr_id"];
            _update_time = dict[@"update_time"];
            _sign = dict[@"sign"];
        }
    }
    else if ([key isEqualToString:@"temp_result"])
    {
        NSDictionary *dict = value;
        if (![dict isEqual:@""]) {
            self.isDown = [dict objectForKey:@"isDown"];
            self.resumeCfolderId = [dict objectForKey:@"resumeCfolderId"];
            self.idate = [dict objectForKey:@"idate"];
            self.regionid = [dict objectForKey:@"regionid"];
            self.uname = [dict objectForKey:@"uname"];
            self.resumeTempId = [dict objectForKey:@"resumeTempId"];
            self.personId = [dict objectForKey:@"personId"];
            self.totalid = [dict objectForKey:@"totalid"];
            self.tradeid = [dict objectForKey:@"tradeid"];
            self.uid = [dict objectForKey:@"uid"];
            self.uids = [dict objectForKey:@"uids"];
        }
        
    }
    else
    {
        [super setValue:value forKey:key];
    }
}

@end
