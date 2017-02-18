//
//  ResumePreviewCtl.h
//  jobClient
//
//  Created by YL1001 on 14-9-11.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//推荐的简历预览

#import "BaseWebViewCtl.h"
#import "ExRequetCon.h"
#import "TranspondResumeCtl.h"
#import "SendInterviewCtl.h"

@protocol DownloadResumeDelegate <NSObject>

-(void)downloadResume:(User_DataModal*)dataModal;

@end

@interface RecommendResumePreviewCtl : BaseWebViewCtl<TranspondResumeCtlDelegate>
{
    User_DataModal   * inDataModal_;
    NSString         * companyId_;
    IBOutlet  UIButton * sendinterviewBtn_;
    IBOutlet  UIButton * moreBtn_;
    IBOutlet  UIView   * bottomView_;
    
    IBOutlet  UIView   * popView1_;
    IBOutlet  UIButton * callBtn_;
    IBOutlet  UIButton * msgBtn_;
    IBOutlet  UIButton * emailBtn_;
    
    IBOutlet  UIView   * popView2_;
    IBOutlet  UIButton * zhuanfaBtn_;
    IBOutlet  UIButton * collectBtn_;
    IBOutlet  UIButton * evaluationBtn_;
    
    
    
    TranspondResumeCtl * transpondResumeCtl_;
    RequestCon       * rejectCon_;
    RequestCon       * collectCon_;
}

@property(nonatomic,assign) BOOL hideBottomView_;
@property(nonatomic,assign) id<DownloadResumeDelegate> delegate_;

@property (weak, nonatomic) IBOutlet UILabel *resumeLb;
@property (weak, nonatomic) IBOutlet UIButton *transmitBtn;
@property (weak, nonatomic) IBOutlet UILabel *transmitLb;
@property (strong, nonatomic) IBOutlet UIView *bottomView0;
@property (weak, nonatomic) IBOutlet UIButton *transmit0Btn;
@property (weak, nonatomic) IBOutlet UILabel *transmit0Lb;
@property (weak, nonatomic) IBOutlet UILabel *storeLb;
@property (weak, nonatomic) IBOutlet UIButton *storeBtn;
@property (weak, nonatomic) IBOutlet UILabel *downloadLb;
@property (weak, nonatomic) IBOutlet UIButton *downLoadBtn;

@property (assign, nonatomic) BOOL isResumeSearch;

@end
