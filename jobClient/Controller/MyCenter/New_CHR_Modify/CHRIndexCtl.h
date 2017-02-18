//
//  CHRIndexCtl.h
//  jobClient
//
//  Created by 一览ios on 15/6/2.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

//简历列表类型
typedef NS_ENUM(NSUInteger, ResumeType) {
    ResumeTypePersonDelivery = 1,  //投递应聘
    ResumeTypeAdviserRecommend,    //一览精选
    ResumeTypeDownload,            //主动下载
    ResumeTypeTranspondForMe,      //转发给我
    ResumeTypeTempSaved,           //暂存
    ResumeTypeTempSearch           //找简历
};

//简历状态
//0 待处理，1合适，5，不合适，20 待面试，30已到场，40已面试，60已发offer
typedef NS_ENUM(NSUInteger, ResumeState){
    ResumeStateToProcessed = 0,        //待处理
    ResumeStateQualified = 1,          //简历合适=初选通过
    ResumeStateUnQualified = 5,        //简历不合适=初选不通过
    ResumeStateToInterview = 20,       //等待面试
    ResumeStateHasPresent = 30,        //已到场
//    ResumeStateInterviewed = 40,       //已面试
    ResumeStateSendOffer = 60,         //已发offer
    ResumeStateLeaved = 35,            //已离场
    ResumeStateToDownload,             //未下载
    ResumeStateToDetermine = 3,        //待确定
    ResumeStateThroughInterview = 40,  //面试通过
    ResumeStateNOThroughInterview = 45,//面试不通过
    ResumeStateGiveUpInterview = 47,   //放弃面试
    ResumeStateMountGuard = 80,        //已上岗
};

#import "BaseListCtl.h"

@interface CHRIndexCtl : BaseListCtl

@property (nonatomic, copy) NSString *companyId;//企业ID
@property (nonatomic ,copy) NSString *synergy_id;//协同账号id
@property (weak, nonatomic) IBOutlet UIImageView *companyLogoImgv;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLb;
@property (weak, nonatomic) IBOutlet UILabel *statusLb;
@property (weak, nonatomic) IBOutlet UILabel *versionLb;
@property (weak, nonatomic) IBOutlet UIView *headMenuView;
@property (weak, nonatomic) IBOutlet UILabel *ReceivedCntLb;
@property (weak, nonatomic) IBOutlet UILabel *adviserRecoCntLb;
@property (weak, nonatomic) IBOutlet UILabel *downCntLb;
@property (weak, nonatomic) IBOutlet UILabel *tempSaveCntLb;
@property (weak, nonatomic) IBOutlet UILabel *receivedUnreadCntLb;
@property (weak, nonatomic) IBOutlet UILabel *adviserRecoUnreadCnt;
@property (weak, nonatomic) IBOutlet UIImageView *newerImgv;
@property (weak, nonatomic) IBOutlet UIView *ReceivedView;
@property (weak, nonatomic) IBOutlet UIView *adviserRecoView;
@property (weak, nonatomic) IBOutlet UIView *downView;
@property (weak, nonatomic) IBOutlet UIView *tempSaveView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *FindResumeHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headBgViewHeight;
@property (weak, nonatomic) IBOutlet UIView *findResumeBgView;
@property (weak, nonatomic) IBOutlet UIImageView *ReceivedNewImg;
@property (weak, nonatomic) IBOutlet UIImageView *YLSelectNewImg;
@property (weak, nonatomic) IBOutlet UIImageView *adviserNewImg;

@property (nonatomic,assign) BOOL islogin;

@end
