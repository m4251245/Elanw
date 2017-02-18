//
//  CHRIndexCtl.h
//  jobClient
//
//  Created by 一览ios on 15/6/2.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

//简历列表类型
typedef NS_ENUM(NSUInteger, ResumeType) {
    ResumeTypePersonDelivery = 1,//投递应聘
    ResumeTypeAdviserRecommend,//一览精选
    ResumeTypeDownload,//主动下载
    ResumeTypeTranspondForMe,//转发给我
    ResumeTypeTempSaved,//暂存
    ResumeTypeTempSearch//找简历
};

//简历状态
typedef NS_ENUM(NSUInteger, ResumeState){
    ResumeStateToProcessed = 1,  //待处理
    ResumeStateQualified,        //简历合适
    ResumeStateUnQualified,      //简历不合适
    ResumeStateToInterview,      //等待面试
    ResumeStateInterviewed,      //已面试
    ResumeStateSendOffer,        //已发offer
    ResumeStateDownloaded,        //已下载
    ResumeStateToDownload,        //未下载
};


#import "BaseListCtl.h"

@interface CHRIndexCtl : BaseListCtl

@property(nonatomic, copy) NSString *companyId;//企业ID
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

@property (nonatomic,assign) BOOL islogin;

@end
