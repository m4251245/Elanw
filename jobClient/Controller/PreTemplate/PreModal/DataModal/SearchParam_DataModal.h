//
//  SearchParam_DataModal.h
//  jobClient
//
//  Created by job1001 job1001 on 11-12-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

/****************************************
        用于进行搜索时的DataModal
 ****************************************/

#import <Foundation/Foundation.h>


@interface SearchParam_DataModal : NSObject<NSCopying>{
    NSString                        *searchKeywords_;
    NSString                        *regionId_;
    NSString                        *regionStr_;
    NSString                        *majorId_;      //专业id
    NSString                        *majorStr_;     //专业str
    NSString                        *zwId_;
    NSString                        *zwStr_;
    NSString                        *jobType_;      //求职类型
    NSString                        *timeStr_;         //发布日期
    NSString                        *timeName_;
    NSString                        *eduId_;   //学历
    NSString                        *eduName_;
    NSString                        *workAgeValue_;  //工作年限
    NSString                        *workAgeName_;
    NSString                        *payMentValue_;  //薪资
    NSString                        *payMentName_;
    NSString                        *workTypeValue_; //工作类型
    NSString                        *workTypeName_;
    
    BOOL                            bCampusSearch_;

    //bParent为true时，为tradeId总网id,否则为所选的行业id
    NSString                        *tradeId_;
    NSString                        *tradeStr_;
    BOOL                            bParent_;
    
    NSString                        *dateId_;
    NSString                        *dateStr_;
    
    NSString                        *uid_;          //公司id
    
    NSString                        *rangId_;       //定位范围
    NSString                        *rangStr_;      //定位范围
}


@property(nonatomic,copy) NSString                        *searchKeywords_;
@property(nonatomic,copy) NSString                        *regionId_;
@property(nonatomic,copy) NSString                        *regionStr_;
@property(nonatomic,copy) NSString                        *pRegionId;
@property(nonatomic,copy) NSString                        *majorId_;
@property(nonatomic,copy) NSString                        *majorStr_;
@property(nonatomic,copy) NSString                        *zwId_;
@property(nonatomic,copy) NSString                        *zwStr_;
@property(nonatomic,copy) NSString                        *jobType_;
@property(nonatomic,assign) BOOL                            bCampusSearch_;
@property(nonatomic,assign) BOOL                            bParent_;
@property(nonatomic,copy) NSString                        *tradeId_;
@property(nonatomic,copy) NSString                        *tradeStr_;
@property(nonatomic,copy) NSString                        *tradePid;
@property(nonatomic,copy) NSString                        *dateId_;
@property(nonatomic,copy) NSString                        *dateStr_;
@property(nonatomic,copy) NSString                        *uid_;
@property(nonatomic,copy) NSString                        *rangId_;
@property(nonatomic,copy) NSString                        *rangStr_;
@property(nonatomic,assign) NSInteger                             searchType_;
@property(nonatomic,copy) NSString                        *personId_;
@property(nonatomic,copy) NSString                        *searchTime_;
@property(nonatomic,copy) NSString                        *timeStr_;
@property(nonatomic,copy) NSString                        *workAgeValue_;//3-5年  3  工作年限
@property(nonatomic,copy) NSString                        *workAgeValue_1;//      5
@property(nonatomic,copy) NSString                        *eduId_;
@property(nonatomic,copy) NSString                        *payMentValue_;
@property(nonatomic,copy) NSString                        *workTypeValue_;//阅读状态
@property(nonatomic,copy) NSString                        *timeName_;
@property(nonatomic,copy) NSString                        *workAgeName_;
@property(nonatomic,copy) NSString                        *eduName_;
@property(nonatomic,copy) NSString                        *payMentName_;
@property(nonatomic,copy) NSString                        *workTypeName_;
@property(nonatomic,copy) NSString                        *jobstring;     //职位订阅拼接
@property(nonatomic,copy) NSString                        *experienceName;//经验
@property(nonatomic,copy) NSString                        *experienceValue1;
@property(nonatomic,copy) NSString                        *experienceValue2;

@property(nonatomic,copy) NSString                        *process_state;//状态

@property(nonatomic,copy) NSString                        *age1;//年龄1
@property(nonatomic,copy) NSString                        *age2;
@property(nonatomic,assign) BOOL                          isRepeat;//去重
@property(nonatomic,copy) NSString                        *searchName;//名字搜索
@property(nonatomic,copy) NSString                        *dicTime;//场次

//附近职位
@property(nonatomic,strong) NSString           *latNum;//经纬度
@property(nonatomic,strong) NSString           *longnum;
@property(nonatomic,assign) NSInteger           jobNum;

@property(nonatomic,assign) BOOL               isTotalTrade;
@property(nonatomic,assign) BOOL  isSelected;

@end
