//
//  SysNotification_DataModal.m
//  jobClient
//
//  Created by YL1001 on 14/10/31.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "SysNotification_DataModal.h"

@implementation SysNotification_DataModal

-(instancetype)initWithDictionary:(NSDictionary *)subDic
{
    self = [super init];
    if (self)
    {
        //    '301' => '推荐行家', // 活动
        //    '302' => '推荐社群', // 活动
        //    '303' => '推荐URL', // 活动
        //    '500' => '完善语音',
        //    '501' => '上传职业风采照',
        //    '502' => '鼓励发表',
        //    '503' => '回答小编专访',
        //    '515' => '灌薪水',
        //    '516' => '职位',
        //    '517' => '文章',
        //    '518' => '薪指比拼',
        //    '524' => '社群文章'
        self.detailContent = @"";
        self.type_ = [subDic objectForKey:@"msg_type"];
        
        switch ([self.type_ integerValue]) {
            case 301:
            {
                self.userId_ = [subDic objectForKey:@"person_id"];
                self.userImg_ = [subDic objectForKey:@"person_pic"];
                if ([subDic[@"person_job_now"] length] > 0)
                {
                    self.detailContent = [NSString stringWithFormat:@"%@:%@",subDic[@"person_iname"],subDic[@"person_job_now"]];
                }
                self.content_ = [subDic objectForKey:@"title"];
            }
                break;
            case 302:
            {
                self.groupId_ = [subDic objectForKey:@"gid"];
                self.userImg_ = [subDic objectForKey:@"group_pic"];
                self.detailContent = subDic[@"group_name"];
                self.content_ = [subDic objectForKey:@"title"];
            }
                break;
            case 303:
            {
                self.userImg_ = [subDic objectForKey:@"logo"];
                self.url_ = [subDic objectForKey:@"url"];
                self.content_ = [subDic objectForKey:@"title"];
            }
                break;
            case 500:
            {
                self.userId_ = [subDic objectForKey:@"person_id"];
                self.userImg_ = [subDic objectForKey:@"person_pic"];
                self.detailContent = [NSString stringWithFormat:@"TA是:%@",subDic[@"person_iname"]];
                if ([subDic[@"person_job_now"] length] > 0)
                {
                    self.detailContent = [NSString stringWithFormat:@"%@/%@",self.detailContent,subDic[@"person_job_now"]];
                }
                self.content_ = [subDic objectForKey:@"content"];
            }
                break;
            case 501:
            {
                self.userId_ = [subDic objectForKey:@"person_id"];
                self.userImg_ = [subDic objectForKey:@"person_pic"];
                self.detailContent = [NSString stringWithFormat:@"TA是:%@",subDic[@"person_iname"]];
                if ([subDic[@"person_job_now"] length] > 0)
                {
                    self.detailContent = [NSString stringWithFormat:@"%@/%@",self.detailContent,subDic[@"person_job_now"]];
                }
                self.content_ = [subDic objectForKey:@"content"];
            }
                break;
            case 502:
            {
                self.userId_ = [subDic objectForKey:@"person_id"];
                self.userImg_ = [subDic objectForKey:@"person_pic"];
                self.detailContent = [NSString stringWithFormat:@"TA是:%@",subDic[@"person_iname"]];
                if ([subDic[@"person_job_now"] length] > 0)
                {
                    self.detailContent = [NSString stringWithFormat:@"%@/%@",self.detailContent,subDic[@"person_job_now"]];
                }
                self.content_ = [subDic objectForKey:@"content"];
            }
                break;
            case 503:
            {
                self.userId_ = [subDic objectForKey:@"person_id"];
                self.userImg_ = [subDic objectForKey:@"person_pic"];
                self.content_ = [subDic objectForKey:@"content"];
            }
                break;
            case 515:
            {
                self.productId_ = [subDic objectForKey:@"aid"];
                self.userImg_ = [subDic objectForKey:@"logo"];
                self.detailContent = subDic[@"content"];
                self.content_ = [subDic objectForKey:@"title"];
            }
                break;
            case 516:
            {
                self.productId_ = [subDic objectForKey:@"aid"];
                self.userImg_  = [subDic objectForKey:@"company_logo"];
                self.companyId_ = [subDic objectForKey:@"company_id"];
                self.companyName_ = [subDic objectForKey:@"company_name"];
                self.content_ = [subDic objectForKey:@"title"];
            }
                break;
            case 517:
            {
                self.productId_ = [subDic objectForKey:@"aid"];
                self.userImg_ = [subDic objectForKey:@"logo"];
                if ([subDic[@"person_iname"] length] > 0)
                {
                    self.detailContent = [NSString stringWithFormat:@"来自:%@",subDic[@"person_iname"]];
                }
                self.content_ = [subDic objectForKey:@"title"];
            }
                break;
            case 518:
            {
                self.userId_ = [subDic objectForKey:@"person_id"];
                self.kw_ = [subDic objectForKey:@"kw"];
                self.salary_ = [subDic objectForKey:@"salary"];
                self.regionId_ = [subDic objectForKey:@"zw_regionid"];
                self.userImg_ = [subDic objectForKey:@"logo"];
                self.content_ = [subDic objectForKey:@"title"];
            }
                break;
            case 524:
            {
                self.productId_ = [subDic objectForKey:@"aid"];
                self.userImg_ = [subDic objectForKey:@"logo"];
                self.content_ = [subDic objectForKey:@"title"];
            }
                break;
            case 160:
            {
                self.productId_ = [subDic objectForKey:@"aid"];
                self.userImg_ = [subDic objectForKey:@"logo"];
                self.content_ = [subDic objectForKey:@"title"];
            }
                break;
            default:
                break;
        }
        
        if([self.detailContent isEqualToString:@""])
        {
            self.detailContent = subDic[@"content"];
        }
        
        /*
        if ([self.type_ isEqualToString:@"301"]||[self.type_ isEqualToString:@"500"]||[self.type_ isEqualToString:@"501"]||[self.type_ isEqualToString:@"502"]||[self.type_ isEqualToString:@"503"]) {
            self.userId_ = [subDic objectForKey:@"person_id"];
            self.userImg_ = [subDic objectForKey:@"person_pic"];
        }
        if ([self.type_ isEqualToString:@"302"]) {
            self.groupId_ = [subDic objectForKey:@"gid"];
            self.userImg_ = [subDic objectForKey:@"group_pic"];
            self.detailContent = subDic[@"group_name"];
        }
        if ([self.type_ isEqualToString:@"303"]) {
            self.userImg_ = [subDic objectForKey:@"logo"];
            self.url_ = [subDic objectForKey:@"url"];
        }
        
        if ([self.type_ isEqualToString:@"515"]||[self.type_ isEqualToString:@"517"]||[self.type_ isEqualToString:@"160"] || [self.type_ isEqualToString:@"524"]) {
            self.productId_ = [subDic objectForKey:@"aid"];
            self.userImg_ = [subDic objectForKey:@"logo"];
        }
        if ([self.type_ isEqualToString:@"516"]) {
            self.productId_ = [subDic objectForKey:@"aid"];
            self.userImg_  = [subDic objectForKey:@"company_logo"];
            self.companyId_ = [subDic objectForKey:@"company_id"];
            self.companyName_ = [subDic objectForKey:@"company_name"];
            
        }
        if ([self.type_ isEqualToString:@"518"]) {
            self.userId_ = [subDic objectForKey:@"person_id"];
            self.kw_ = [subDic objectForKey:@"kw"];
            self.salary_ = [subDic objectForKey:@"salary"];
            self.regionId_ = [subDic objectForKey:@"zw_regionid"];
            self.userImg_ = [subDic objectForKey:@"logo"];
        }
        
        if([self.type_ isEqualToString:@"500"]||[self.type_ isEqualToString:@"501"]||[self.type_ isEqualToString:@"502"])
        {
            self.detailContent = [NSString stringWithFormat:@"TA是:%@",subDic[@"person_iname"]];
            
            if ([subDic[@"person_job_now"] length] > 0)
            {
                self.detailContent = [NSString stringWithFormat:@"%@/%@",self.detailContent,subDic[@"person_job_now"]];
            }
        }
        if ([self.type_ isEqualToString:@"301"] && [subDic[@"person_job_now"] length] > 0)
        {
            self.detailContent = [NSString stringWithFormat:@"%@:%@",subDic[@"person_iname"],subDic[@"person_job_now"]];
        }
        if ([self.type_ isEqualToString:@"517"] && [subDic[@"person_iname"] length] > 0) {
            self.detailContent = [NSString stringWithFormat:@"来自:%@",subDic[@"person_iname"]];
        }
        if ([self.type_ isEqualToString:@"515"]) {
            self.detailContent = subDic[@"content"];
        }
        
        if ([self.type_ isEqualToString:@"500"]||[self.type_ isEqualToString:@"501"]||[self.type_ isEqualToString:@"502"]||[self.type_ isEqualToString:@"503"])
        {
            self.content_ = [subDic objectForKey:@"content"];
        }
        else
        {
            self.content_ = [subDic objectForKey:@"title"];
            if([self.detailContent isEqualToString:@""])
            {
                self.detailContent = subDic[@"content"];
            }
        }
        */
        
        self.datetime_ = [subDic objectForKey:@"idatetime"];
        self.content_ = [MyCommon translateHTML:self.content_];
        self.detailContent = [MyCommon translateHTML:self.detailContent];
        NSDate * date = [MyCommon getDate:self.datetime_];
        self.datetime_ = [MyCommon getWhoLikeMeListCurrentTime:date currentTimeString:self.datetime_];
    }
    return self;
}

@end
