//
//  SearchParam_DataModal.m
//  jobClient
//
//  Created by job1001 job1001 on 11-12-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SearchParam_DataModal.h"


@implementation SearchParam_DataModal

@synthesize searchKeywords_;
@synthesize regionId_;
@synthesize regionStr_;
@synthesize majorId_;
@synthesize majorStr_;
@synthesize zwId_;
@synthesize zwStr_;
@synthesize jobType_;
@synthesize bCampusSearch_;
@synthesize bParent_;
@synthesize tradeStr_;
@synthesize tradeId_;
@synthesize dateId_;
@synthesize dateStr_;
@synthesize uid_;
@synthesize rangId_;
@synthesize rangStr_;
@synthesize personId_;
@synthesize searchTime_;
@synthesize timeStr_;
@synthesize eduId_,payMentValue_,workAgeValue_,workAgeValue_1,workTypeValue_,eduName_,payMentName_,timeName_,workAgeName_,workTypeName_;
@synthesize jobNum,latNum,longnum;
-(id) init
{
    //默认按全文搜索
    _searchType_ = 3;
    
    return self;
}
//遵循copying协议，执行深拷贝
- (id)copyWithZone:(nullable NSZone *)zone{
    SearchParam_DataModal *searchVO = [self.class allocWithZone:zone];
    searchVO.age1 = [_age1 copy];//年龄1
    searchVO.age2 = [_age2 copy];
    searchVO.searchName = [_searchName copy];//名字
    searchVO.dicTime = [_dicTime copy];//场次
    searchVO.isRepeat = self.isRepeat;
    searchVO.process_state = [_process_state copy];
    searchVO.regionId_ = [regionId_ copy];
    searchVO.eduId_ = [eduId_ copy];
    searchVO.workTypeValue_ = [workTypeName_ copy];
    searchVO.experienceValue1 = [_experienceValue1 copy];
    searchVO.experienceValue2 = [_experienceValue2 copy];
    return searchVO;
}

@end
