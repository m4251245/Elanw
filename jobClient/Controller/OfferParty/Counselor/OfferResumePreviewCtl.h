//
//  OfferResumePreviewCtl.h
//  jobClient
//
//  Created by YL1001 on 14-9-11.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseWebViewCtl.h"
#import "ExRequetCon.h"
#import "TranspondResumeCtl.h"
#import "OfferPartyResumeEnumeration.h"

@protocol OfferResumePreviewCtlDelegate <NSObject>

@optional
-(void)rejectResume:(User_DataModal*)dataModal passed:(BOOL)bePassed;

@end

@interface OfferResumePreviewCtl : BaseWebViewCtl<TranspondResumeCtlDelegate,UIAlertViewDelegate>
{
    User_DataModal   * inDataModal_;
    NSString         * companyId_;
    
    TranspondResumeCtl * transpondResumeCtl_;
    RequestCon       * rejectCon_;
    RequestCon       * collectCon_;
    
    RequestCon *_isLookPersonCantactCon;//是否能够面试
    RequestCon *_downloadResumeCon;//下载简历
}

@property (weak, nonatomic) IBOutlet UIButton *loadResumeBtn;
@property (weak, nonatomic) IBOutlet UIButton *recomBtn;

@property (weak, nonatomic) IBOutlet UIButton *dianlianBtn;
@property (weak, nonatomic) IBOutlet UIButton *daochangBtn;
@property (weak, nonatomic) IBOutlet UIButton *btnFujian;

@property (nonatomic, copy) NSString *jobfair_id;
@property (nonatomic, assign) BOOL bRecommended_;    //判断是否是顾问推荐的简历
@property (nonatomic, assign) id<OfferResumePreviewCtlDelegate> delegate_;
@property (assign, nonatomic) OPResumeListType resumeListType;  //offer派的简历类型
@property (assign, nonatomic) ResumeType resumeType;            //招聘顾问的简历类型
@property (weak, nonatomic)   IBOutlet UIView *optionView1;
@property (weak, nonatomic)   IBOutlet UIView *optionView3;
@property (weak, nonatomic)   IBOutlet UIView *optionView2;
@property (assign, nonatomic) BOOL consultantCompanyFlag;//顾问企业列表
@property (nonatomic, strong) UIViewController *menuCtl;

@property (nonatomic, copy) NSString *commentContent;//推荐内容

@property (nonatomic, assign) BOOL isRecommend;

@end
