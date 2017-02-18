//
//  Groups_DataModal.m
//  Association
//
//  Created by 一览iOS on 14-1-15.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "Groups_DataModal.h"

@implementation Groups_DataModal
@synthesize articleCnt_,auditstatus_,code_,creater_,createrId_,id_,idatetime_,intro_,istj_,maxMemberCnt_,name_,openstatus_,personCnt_,pic_,tags_,totalId_,tradeId_,updatetime_,updatetimeLast_,isCreater_,firstArt_,firstComm_,invitePerm_,publishPerm_,bImageLoad_,imageData_,groupCode_,groupRel_,tagsArray_;


-(id)init
{
    self = [super init];
    firstArt_ = [[Article_DataModal alloc]init];
    tagsArray_ = [[NSMutableArray alloc] init];
    creater_ = [[Expert_DataModal alloc]init];
    return self;
}

-(instancetype)initWithRecommentListDictionary:(NSDictionary *)dic
{
    self = [self init];
    if (self)
    {
        NSDictionary *groupInfoDic = dic[@"group_info"];
        NSDictionary *articleInfoDic = dic[@"article_info"];
        if ([groupInfoDic isKindOfClass:[NSDictionary class]])
        {
            self.name_ = groupInfoDic[@"group_name"];
            self.personCnt_ = [groupInfoDic[@"group_person_cnt"] integerValue];
            self.articleCnt_ = [groupInfoDic[@"group_article_cnt"] integerValue];
            self.pic_ = groupInfoDic[@"group_pic"];
            self.id_ = groupInfoDic[@"group_id"];
        }
        if ([articleInfoDic isKindOfClass:[NSDictionary class]])
        {
            self.firstArt_ = [[Article_DataModal alloc] init];
            self.firstArt_.personName_ = articleInfoDic[@"own_name"];
            self.firstArt_.personID_ = articleInfoDic[@"own_id"];
            self.firstArt_.id_ = articleInfoDic[@"article_id"];
            self.firstArt_.title_ = articleInfoDic[@"title"];
        }
    }
    return self;
}

-(instancetype)initPersonCenterWithDictionary:(NSDictionary *)groupListDic{
    self = [self init];
    if (self)
    {
        self.id_  = [groupListDic objectForKey:@"group_id"];
        self.pic_ = [groupListDic objectForKey:@"group_pic"];
        self.name_ = [groupListDic objectForKey:@"group_name"];
        self.name_ = [MyCommon translateHTML:self.name_];
        self.name_ = [MyCommon MyfilterHTML:self.name_];
        self.articleCnt_ = [[groupListDic objectForKey:@"group_article_cnt"] intValue];
        self.personCnt_ = [[groupListDic objectForKey:@"group_person_cnt"] intValue];
        self.openstatus_ = groupListDic[@"group_open_status"];
        NSDictionary *dicList = [groupListDic objectForKey:@"_article_list"];
        if ([dicList isKindOfClass:[NSDictionary class]]) {
            self.firstArt_.id_ = [dicList objectForKey:@"article_id"];
            self.firstArt_.title_ = [dicList objectForKey:@"title"];
            self.firstArt_.personName_ = [[dicList objectForKey:@"_person_detail"] objectForKey:@"person_iname"];
        }
        NSDictionary *dicRel = [groupListDic objectForKey:@"group_person_rel"];
        if ([dicRel isKindOfClass:[NSDictionary class]]) {
            self.code_ = [dicRel objectForKey:@"code"];
        }
    }
    return self;
}

@end
