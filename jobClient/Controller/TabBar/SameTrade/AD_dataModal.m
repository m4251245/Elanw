//
//  AD_dataModal.m
//  jobClient
//
//  Created by YL1001 on 14/12/3.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "AD_dataModal.h"

@implementation AD_dataModal

-(instancetype)initWithDictionary:(NSDictionary *)subDic{
    self = [super init];
    if (self) {
        self.adId = subDic[@"yar_id"];
        self.pic_ = subDic[@"path"];
        self.target_ = subDic[@"target"];
        self.url_ = subDic[@"url"];
        self.title_ = subDic[@"title"];
        self.type_ = subDic[@"_param"][@"type"];
        self.sharePic = subDic[@"small_pic"];
        self.shareContent = subDic[@"alt"];
        if ([self.type_ isEqualToString:@"yl_app_expert"]){
            self.pid = subDic[@"_param"][@"pid"];
        }
        if ([self.type_ isEqualToString:@"yl_app_normal_publish_detail"] || [self.type_ isEqualToString:@"yl_app_guan_detail"]){
            self.aid = subDic[@"_param"][@"aid"];
        }
        if ([self.type_ isEqualToString:@"yl_app_user_publish_list"]){
            self.pid = subDic[@"_param"][@"pid"];
        }
        if ([self.type_ isEqualToString:@"yl_app_group"]){
            self.gid = subDic[@"_param"][@"gid"];
        }
        if ([self.type_ isEqualToString:@"yl_app_group_topic_detail"]){
            self.gid = subDic[@"_param"][@"gid"];
            self.aid = subDic[@"_param"][@"aid"];
            self.code = subDic[@"_param"][@"code"];
            self.group_open_status = subDic[@"_param"][@"group_open_status"];
        }
        if ([self.type_ isEqualToString:@"yl_app_job_zw"]){
            self.zwid = subDic[@"_param"][@"zwid"];
            self.company_name = subDic[@"_param"][@"company_name"];
            self.company_id = subDic[@"_param"][@"company_id"];
            self.company_logo = subDic[@"_param"][@"company_logo"];
        }
        if ([self.type_ isEqualToString:@"yl_app_job_company"]){
            self.company_name = subDic[@"_param"][@"company_name"];
            self.company_id = subDic[@"_param"][@"company_id"];
        }
        if ([self.type_ isEqualToString:@"yl_app_zd_question"]){
            self.question_id = subDic[@"_param"][@"question_id"];
        }
        if ([self.type_ isEqualToString:@"yl_app_teachins_xjh"] || [self.type_ isEqualToString:@"yl_app_teachins_zph"]){
            self.teachins_id = subDic[@"_param"][@"teachins_id"];
        }
    }
    return self;
}

@end
