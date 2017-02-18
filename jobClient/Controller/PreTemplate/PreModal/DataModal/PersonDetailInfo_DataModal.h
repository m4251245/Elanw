//
//  PersonDetailInfo_DataModal.h
//  iPadJobClient
//
//  Created by job1001 job1001 on 11-12-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

/********************************************
 个人信息，在job1001上的信息模块
 ********************************************/

#import <Foundation/Foundation.h>


@interface PersonDetailInfo_DataModal : NSObject {
   
}


@property(nonatomic,retain) NSString                            *updateTime_;
@property(nonatomic,retain) NSString                            *phone_;
@property(nonatomic,retain) NSString                            *shouji_;
@property(nonatomic,retain) NSString                            *emial_;
@property(nonatomic,retain) NSString                            *qq_;
@property(nonatomic,retain) NSString                            *http_;
@property(nonatomic,retain) NSString                            *post_;
@property(nonatomic,retain) NSString                            *address_;
@property(nonatomic,retain) NSString                            *pic_;

@property(nonatomic,retain) NSString                            *iname_;
@property(nonatomic,retain) NSString                            *gznum_;
@property(nonatomic,retain) NSString                            *sex_;
@property(nonatomic,retain) NSString                            *edu_;
@property(nonatomic,retain) NSString                            *bday_;
@property(nonatomic,retain) NSString                            *hka_;
@property(nonatomic,retain) NSString                            *region_;
@property(nonatomic,retain) NSString                            *zcheng_;
@property(nonatomic,retain) NSString                            *marray_;
@property(nonatomic,retain) NSString                            *zzmm_;
@property(nonatomic,retain) NSString                            *mzhu_;

@property(nonatomic,retain) NSString                            *jobtype_;
@property(nonatomic,retain) NSString                            *job_;
@property(nonatomic,retain) NSString                            *person_status;
@property(nonatomic,retain) NSString                            *jobs_;
@property(nonatomic,retain) NSString                            *job1_;
@property(nonatomic,retain) NSString                            *city_;
@property(nonatomic,retain) NSString                            *gzdd1_;
@property(nonatomic,retain) NSString                            *gzdd5_;
@property(nonatomic,retain) NSString                            *worddate_;
@property(nonatomic,retain) NSString                            *yuex_;
@property(nonatomic,retain) NSString                            *grzz_;

@property(nonatomic,retain) NSString                            *gzjl_;
@property(nonatomic,retain) NSString                            *othertc_;

@property(nonatomic,retain) NSString                            *school_;

@property(nonatomic,retain) NSString                            *byday_;
@property(nonatomic,retain) NSString                            *zye_;
@property(nonatomic,retain) NSString                            *zym_;
@property(nonatomic,retain) NSString                            *edus_;
@property(nonatomic,retain) NSString                            *eduStratTime;
@property(nonatomic,retain) NSString                            *eduEndTime;
@property(nonatomic,retain) NSString                            *edusId;
@property(nonatomic,retain) NSString                            *eduId;
@property(nonatomic,retain) NSString                            *personId;
@property(nonatomic,retain) NSString                            *rcType_;//求职身份
@property(nonatomic,retain) NSString                            *jobStatus; //人才类型 0应届生   1社会人才
@property(nonatomic,retain) NSString                            *evaluation; //自我评价
@property(nonatomic,assign) NSInteger                           resumeStatus_;

@property(nonatomic,assign) BOOL                                bOld_;
@property(nonatomic,assign) BOOL                                bCanLooked_;

@property(nonatomic,retain) NSString                            *workStratTime;
@property(nonatomic,retain) NSString                            *workEndTime;
@property(nonatomic,strong) NSString                            *workIsToNow;
@property(nonatomic,strong) NSString                            *studyIsToNow;
@property(nonatomic,retain) NSString                            *workId;
@property(nonatomic,retain) NSString                            *companyName;
@property(nonatomic,retain) NSString                            *zw;

@property(nonatomic,retain) NSString                            *role;                  //求职身份
@property(nonatomic,retain) NSString                            *jobStatus1;         //求职状态
@property(nonatomic,retain) NSString                            *country;         //国籍
@property(nonatomic,retain) NSString                            *idType;         //证件类型
@property(nonatomic,retain) NSString                            *idNum;         //证件号码
@property(nonatomic,retain) NSString                            *height;         //身高
@property(nonatomic,retain) NSString                            *weight;         //体重
@property(nonatomic,retain) NSString                            *salary;         //目前年薪


@end
