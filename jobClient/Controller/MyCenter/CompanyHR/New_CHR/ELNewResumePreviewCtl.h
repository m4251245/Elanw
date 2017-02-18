//
//  ELNewResumePreviewCtl.h
//  jobClient
//
//  Created by YL1001 on 16/8/3.
//  Copyright © 2016年 YL1001. All rights reserved.
//


/***
 
 新的简历预览，企业后台首页五个导航专用简历预览
 
 ***/

#import "BaseWebViewCtl.h"
#import "CHRIndexCtl.h"
@class CompanyResumePrevierwModel;
@class User_DataModal;

@protocol NewResumePreviewCtlDelegate <NSObject>

-(void)downloadResume:(User_DataModal*)dataModal;

@optional
-(void)ModifyResume:(User_DataModal*)dataModal passed:(BOOL)bePassed;


@end

@protocol ELResumeLoadDelegate <NSObject>

-(void)finishLoad;
-(void)finishLoadWithModel:(id)model;

@end

@interface ELNewResumePreviewCtl : BaseWebViewCtl

@property (assign, nonatomic) ResumeType resumeListType; //企业后台简历列表类型
@property (assign, nonatomic) NSString *forType;
@property (nonatomic, weak) id<NewResumePreviewCtlDelegate> delegate;
@property (nonatomic,weak) id<ELResumeLoadDelegate> loadDelegate;
@property (nonatomic, assign) BOOL isRecommend;
@property (nonatomic, assign) NSInteger idx;
@property (nonatomic, assign) BOOL selType;
@property (strong, nonatomic) CompanyResumePrevierwModel *previewModel;

- (void)rightBtnClick:(UIButton *)sender;


@property (nonatomic, strong) OfferPartyTalentsModel *offerPartyModel;

@end
