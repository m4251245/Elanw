//
//  ELResumeChangeCtl.h
//  jobClient
//
//  Created by 一览iOS on 16/11/7.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "ELNewResumePreviewCtl.h"
#import "RequestCon.h"
#import "OfferPartyResumeEnumeration.h"

@protocol LoadDataBlockDelegate <NSObject>

-(void)requestLoadRequest:(RequestCon *)con;

@end

@interface ELResumeChangeCtl : BaseUIViewController

@property (assign, nonatomic) ResumeType resumeListType; //企业后台简历列表类型

@property (assign, nonatomic) NSString *forType;
@property (nonatomic, weak) id<NewResumePreviewCtlDelegate> delegate;
@property (nonatomic, assign) BOOL isRecommend;
@property (nonatomic, assign) NSInteger idx;
@property (nonatomic, assign) BOOL selType;
@property (nonatomic,assign) NSInteger selectRow;
@property (nonatomic,strong) NSMutableArray *arrData;
@property (nonatomic,weak) id <LoadDataBlockDelegate> loadDelegate;
@property (nonatomic,assign) NSInteger currentPage;

@property (assign, nonatomic) ComResumeListType resumeSelectType;//老offer派简历类型选择
@property (nonatomic, strong) OfferPartyTalentsModel *offerModel;

@property (nonatomic, assign) NSInteger resumeEntry;// 简历预览入口 1一览精选 2 offer派

@property (nonatomic, assign) NSInteger totalCount;//列表数据总数
@property (nonatomic, copy) NSString  *leave_action;
@property(nonatomic, copy) NSString *fromtype;//offer  vph  kpb
@end
