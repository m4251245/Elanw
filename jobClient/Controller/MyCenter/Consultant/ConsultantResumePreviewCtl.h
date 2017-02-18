//
//  ConsultantResumePreviewCtl.h
//  jobClient
//
//  Created by YL1001 on 14-9-11.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseWebViewCtl.h"
#import "ExRequetCon.h"
#import "TranspondResumeCtl.h"
#import "ShareMessageModal.h"

@protocol LoadResumeDelegate <NSObject>

@optional
- (void)loadRcResumeSuccess;

@end

@interface ConsultantResumePreviewCtl : BaseWebViewCtl
{
    User_DataModal   * inDataModal_;
    NSString         * companyId_;
    
    IBOutlet  UIView   *bottomView_;
    IBOutlet  UIButton *sendinterviewBtn_;
    IBOutlet  UIButton *moreBtn_;
    IBOutlet  UIButton *loadResumeBtn;

    __weak IBOutlet UIButton *recordButton;
    __weak IBOutlet UIButton *zhuanfajianliBtn;
    
}

@property (nonatomic, copy) NSString *salerId;

@property(nonatomic,assign) id<LoadResumeDelegate,TranspondResumeCtlDelegate> delegate;
@property(nonatomic,assign) BOOL hideBottomView_;
@property(nonatomic,assign) BOOL bRecommended_;    //判断是否是顾问推荐的简历
@property(nonatomic,assign) BOOL hidenRightBtnBool;

@property (nonatomic, assign) NSInteger searchFlag;//搜索简历
@property (nonatomic, assign) NSInteger downloadFlag;//已下载简历
@property (nonatomic, assign) NSInteger recommendFlag;//已推荐简历

@property(nonatomic, assign) NSInteger isGuwen;

@end
