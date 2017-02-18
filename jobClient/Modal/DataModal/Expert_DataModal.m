//
//  Expert_DataModal.m
//  Association
//
//  Created by 一览iOS on 14-1-17.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "Expert_DataModal.h"

@implementation Expert_DataModal
@synthesize introduce_,goodat_,questionCnt_,answerCnt_,fansCnt_,followCnt_,letterCnt_,publishCnt_,groupsCnt_,followStatus_,articleId_,content_,ctime_,commentCnt_,is_article,expertId_,followerName_,isExpert_,followerId_,role_,jobStatus,gpId_,publishPerm_,invitePerm_,groupsCreateCnt_,isInvite_,sameCity_,sameHometown_,sameSchool_,relationArray_,ylPersonFlag_,hkaStr_,schoolStr_,cityStr_,sendEmailFlag_,articleCtime_,articleImg_,articleTitle_,isNewFollow_,bday_,favoriteCnt_;

-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.id_ = [dic objectForKey:@"person_id"];
        self.iname_ = [dic objectForKey:@"person_iname"];
        self.idate_ = [dic objectForKey:@"idatetime"];
        NSDate * date = [MyCommon getDate:self.idate_];
        self.idate_ = [MyCommon compareCurrentTime:date];
        self.img_ = [dic objectForKey:@"person_pic"];
        self.isExpert_ = [[dic objectForKey:@"is_expert"] boolValue];
        self.gznum_ = [dic objectForKey:@"person_gznum"];
        self.zw_ = [dic objectForKey:@"person_zw"];
        self.cityStr_ = [dic objectForKey:@"person_region_name"];
        self.age_ = [dic objectForKey:@"person_age"];
        self.sameSchool_ = [dic objectForKey:@"same_school"];
        self.sameCity_ = [dic objectForKey:@"same_city"];
        self.sex_ = [dic objectForKey:@"person_sex"];
    }
    return self;
}

-(instancetype)initWithParserLetterListDictionary:(NSDictionary *)subDic
{
    self = [super init];
    if (self) {
        self.id_ = [subDic objectForKey:@"trigger_person_id"];
        self.iname_ = [subDic objectForKey:@"person_iname"];
        self.idate_ = [subDic objectForKey:@"idatetime"];
        NSDate * date = [MyCommon getDate:self.idate_];
        self.idate_ = [MyCommon compareCurrentTime:date];
        self.img_ = [subDic objectForKey:@"person_pic"];
        self.isExpert_ = [[subDic objectForKey:@"is_expert"] boolValue];
        self.gznum_ = [subDic objectForKey:@"person_gznum"];
        self.zw_ = [subDic objectForKey:@"person_zw"];
        self.cityStr_ = [subDic objectForKey:@"person_region_name"];
        self.age_ = [subDic objectForKey:@"person_age"];
        self.sameSchool_ = [subDic objectForKey:@"same_school"];
        self.sameCity_ = [subDic objectForKey:@"same_city"];
        self.sex_ = [subDic objectForKey:@"person_sex"];
        self.letterContent_ = @"接口未返回，待处理...";
    }
    return self;
}

-(instancetype)initWithExpertDetailDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) 
    {
        self.id_ = [dic objectForKey:@"personId"];
        self.iname_ = [dic objectForKey:@"person_iname"];
        self.job_ = [dic objectForKey:@"person_job_now"];
        self.sex_ = [dic objectForKey:@"person_sex"];
        self.email_ = [dic objectForKey:@"person_email"];
        self.mobile_ = [dic objectForKey:@"person_mobile"];
        self.zw_ = [dic objectForKey:@"person_zw"];
        self.gznum_ = [dic objectForKey:@"person_gznum"];
        self.company_ = [dic objectForKey:@"person_company"];
        self.img_ = [dic objectForKey:@"person_pic"];
        self.nickname_ = [dic objectForKey:@"person_nickname"];
        self.signature_ = [dic objectForKey:@"person_signature"];
        @try {
            NSDictionary * expertDic = [dic objectForKey:@"expert_detail"];
            self.goodat_ = [expertDic objectForKey:@"good_at"];
        }
        @catch (NSException *exception) {
            self.goodat_ = @"暂无";
        }
        @finally {
            
        }
        
        @try {
            NSDictionary * contentDic = [dic objectForKey:@"job_person_detail"];
            self.content_ = [contentDic objectForKey:@"grzz"];
        }
        @catch (NSException *exception) {
            self.content_ = @"暂无";
        }
        @finally {
            
        }
        
        @try {
            NSDictionary * countDic = [dic objectForKey:@"count_list"];
            self.answerCnt_ = [[countDic objectForKey:@"answer_count"] integerValue];
            self.fansCnt_ = [[countDic objectForKey:@"fans_count"] integerValue];
            self.publishCnt_ = [[countDic objectForKey:@"publish_count"] integerValue];
        }
        @catch (NSException *exception) {
            self.answerCnt_ = 0;
            self.fansCnt_ = 0;
            self.publishCnt_ = 0;
        }
        @finally {
            
        }

    }
    return self;
}

-(instancetype)initWithArticleDetailExpertNSDctionary:(NSDictionary *)expertDic
{
    self = [super init];
    if (self) 
    {
        self.id_ = [expertDic objectForKey:@"person_id"];
        self.iname_ = [expertDic objectForKey:@"person_iname"];
        self.img_ = [expertDic objectForKey:@"person_pic"];
        self.zw_ = [expertDic objectForKey:@"person_zw"];
        self.gznum_ = [expertDic objectForKey:@"person_gznum"];
        self.job_ = [expertDic objectForKey:@"person_job_now"];
        self.goodat_ = [expertDic objectForKey:@"good_at"];
        if ([[expertDic objectForKey:@"is_expert"] isEqualToString:@"1"]) {
            self.isExpert_ = YES;
        }else{
            self.isExpert_ = NO;
        }
        self.followStatus_ = [[expertDic objectForKey:@"rel"]intValue];
        self.publishCnt_ = [[expertDic objectForKey:@"publish_count"] intValue];
        self.answerCnt_ = [[expertDic objectForKey:@"answer_count"]intValue];
        self.groupsCreateCnt_ = [[expertDic objectForKey:@"groups_count"]intValue];
        self.fansCnt_ = [[expertDic objectForKey:@"fans_count"]intValue];
    }   
    return self;
}

@end
