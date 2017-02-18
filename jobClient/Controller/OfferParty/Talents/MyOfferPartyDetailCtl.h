//
//  CHRIndexCtl.h
//  jobClient
//
//  Created by 一览ios on 15/6/2.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
//#import "OfferPartyTalentsModel.h"

@class OfferPartyTalentsModel;
@class NoDataTipsCtl;

typedef NS_ENUM(NSUInteger, OfferPartyDetailType) {
    OfferPartyDetailTypeAll,
    OfferPartyDetailTypeRecommend,
    OfferPartyDetailTypeConsultant
};

//用户offer派状态
typedef NS_ENUM(NSUInteger, UserOPStatusType) {
    UserOPStatusTypeUndeliver =0,//可投递
    UserOPStatusTypeSendOffer,//确认录用
    UserOPStatusTypeConfirmFit,//通过初选
    UserOPStatusTypeInterviewed,//面试合格
    UserOPStatusTypeDelivered,//已投递（等待面试）
    UserOPStatusTypeRecommend ,//已推荐
    UserOPStatusTypeInterview=7 ,//待面试
    UserOPStatusTypeLeaved=8,//已离场
    UserOPStatusTypeNoFilter = 10, //不通过初选
    UserOPStatusTypeGiveup  = 14,//放弃面试
};

@interface MyOfferPartyDetailCtl : BaseListCtl

//@property (strong, nonatomic) OfferPartyTalentsModel *offerPartyModel;
@property (nonatomic, copy) NSString *jobfair_id;
@property (nonatomic, copy) NSString *jobfair_time;
@property (nonatomic, copy) NSString *jobfair_name;
@property (nonatomic, copy) NSString *fromtype;
@property (nonatomic, copy) NSString *place_name;
@property (nonatomic, assign) BOOL iscome; //已签到
@property (nonatomic, assign) BOOL isjoin; //已报名

@property (weak, nonatomic) IBOutlet UIImageView *adviserImgv;
@property (weak, nonatomic) IBOutlet UILabel *adviserNameLb;
@property (weak, nonatomic) IBOutlet UILabel *adviserTitleLb;
@property (weak, nonatomic) IBOutlet UIButton *adviserPhoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *adviserAttentionBtn;
@property (weak, nonatomic) IBOutlet UIButton *adviserMessageBtn;
@property (weak, nonatomic) IBOutlet UIButton *adviserMessageBtn2;
@property (weak, nonatomic) IBOutlet UIView *contactMeView;
@property (weak, nonatomic) IBOutlet UILabel *topTipsLb;
@property (weak, nonatomic) IBOutlet UIView *toolbarView;

@property (weak, nonatomic) IBOutlet UIButton *statusBtn;

@property (strong, nonatomic) IBOutlet UIView *noDataView;
@property (strong, nonatomic) NoDataTipsCtl *noDataTipsCtl;

@property (assign, nonatomic)OfferPartyDetailType offerPartyDetailType;

@property (assign, nonatomic) BOOL      isGuWenRequestFlag;//顾问端

@property (assign, nonatomic) BOOL  resumeComplete; /**<简历是否完善 */

@end
