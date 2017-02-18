//
//  CHRIndexCtl.h
//  jobClient
//
//  Created by 一览ios on 15/6/2.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//
#import "BaseListCtl.h"
#import "CompanyInfo_DataModal.h"

@interface CHROfferPartyDetailCtl : BaseUIViewController

@property (nonatomic, assign) BOOL consultantCompanyFlag;//顾问企业列表 yes 顾问  no 企业
@property (nonatomic, assign) BOOL  guWenRequestFlag;//顾问
@property (strong, nonatomic) CompanyInfo_DataModal *companyInfomModel; //顾问端才传

//@property (nonatomic,copy) NSString *synergy_id;//协同账号id
@property(nonatomic, copy) NSString *companyId;//企业ID

@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *addressLb;

@property (weak, nonatomic) IBOutlet UILabel *offerPartyCntLb;//全部
@property (weak, nonatomic) IBOutlet UILabel *confirmFitCntLb;//筛选简历
@property (weak, nonatomic) IBOutlet UILabel *presentCntLb;//其他已到场人才
@property (weak, nonatomic) IBOutlet UILabel *toInterviewCntLb;//等候面试
@property (weak, nonatomic) IBOutlet UILabel *interviewedCntLb;//面试人才

@property (weak, nonatomic) IBOutlet UIButton *adviserRecoBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmFitBtn;
@property (weak, nonatomic) IBOutlet UIButton *toInterviewBtn;
@property (weak, nonatomic) IBOutlet UIButton *interviewedBtn;
@property (weak, nonatomic) IBOutlet UIButton *presentBtn;//已到场


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView  *redMark;
@property (weak, nonatomic) IBOutlet UILabel *firstTitleLb;
@property (weak, nonatomic) IBOutlet UILabel *secondTitleLb;
@property (weak, nonatomic) IBOutlet UILabel *thirdTitleLb;
@property (weak, nonatomic) IBOutlet UIView *secondBgView;
@property (weak, nonatomic) IBOutlet UIView *thirdBgView;

@property (weak, nonatomic) IBOutlet UIView *fouthBgView;
@property (weak, nonatomic) IBOutlet UIView *fivesBgView;
@property (weak, nonatomic) IBOutlet UIImageView *fouthPoint;
@property (weak, nonatomic) IBOutlet UIImageView *fivesPoint;
@property (weak, nonatomic) IBOutlet UIView *fouthLine;
@property (weak, nonatomic) IBOutlet UIView *fivesLine;

@property (strong, nonatomic) IBOutlet UIImageView *confirmRedMark;
@property (strong, nonatomic) IBOutlet UIImageView *waitInterviewRedMark;
@property (strong, nonatomic) IBOutlet UIImageView *interviewedRedMark;

@property (nonatomic, copy) NSString *jobfair_id;
@property (nonatomic, copy) NSString *jobfair_time;
@property (nonatomic, copy) NSString *jobfair_name;
@property (nonatomic, copy) NSString *fromtype;
@property (nonatomic, copy) NSString *place_name;

//来自推送 顾问端参会企业
@property (nonatomic, assign) BOOL isFromMessage;
@property (nonatomic, copy) NSString *msgType;
@property (nonatomic,copy) NSString *add_user;

@property (nonatomic, assign) BOOL isPop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topTotop;

@end
