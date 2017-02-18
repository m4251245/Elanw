//
//  Qikan_DataModal.m
//  Association
//
//  Created by 一览iOS on 14-2-11.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "Qikan_DataModal.h"

@implementation Qikan_DataModal
@synthesize articleId_,banner_,checkName_,checkTime_,clicks_,daoyu_,filePath_,idate_,interviewor_,ischeck_,isHome_,jobs_,name_,nextId_,nextQikan_,nextTitle_,orders_,qikan_,qikanId_,personImg_,tags_,template_,thum_,title_,titleImg_,topictype_,typeId_,uid_,imageData_,bImageLoad_,content_;


-(Qikan_DataModal *)initWithJobGuideListDictionary:(NSDictionary *)subDic
{
    self = [super init];
    if (self) {
        self.qikanId_ = [subDic objectForKey:@"qikanId"];
        self.qikan_ =[subDic objectForKey:@"qikan"];
        self.title_ = [subDic objectForKey:@"title"];
        self.thum_ = [subDic objectForKey:@"thum"];
        self.idate_ = [subDic objectForKey:@"idate"];
        self.daoyu_ = [subDic objectForKey:@"daoyu"];
    }
    return self;
}

-(Qikan_DataModal *)initWithJobGuideDetailDictionary:(NSDictionary *)subDic
{
    self = [super init];
    if (self) {
        self.qikanId_ = [subDic objectForKey:@"qikanId"];
        self.qikan_ =[subDic objectForKey:@"qikan"];
        self.title_ = [subDic objectForKey:@"title"];
        self.content_ = [subDic objectForKey:@"content"];
        self.content_ = [MyCommon convertHTML:self.content_];
    }
    return self;
}
@end
