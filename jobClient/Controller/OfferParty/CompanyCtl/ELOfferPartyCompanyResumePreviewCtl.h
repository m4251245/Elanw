//
//  ELOfferPartyCompanyResumePreviewCtl.h
//  jobClient
//
//  Created by YL1001 on 16/10/8.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "BaseWebViewCtl.h"
#import "OfferPartyResumeEnumeration.h"

@protocol CompanyResumePreviewDelegate <NSObject>

-(void)finishLoad;
-(void)finishLoadWithModel:(id)model;
@optional
- (void)operationSuccessful;

@end

@interface ELOfferPartyCompanyResumePreviewCtl : BaseWebViewCtl

@property (nonatomic, copy) NSString *fromtype;
@property (nonatomic, assign) ComResumeListType resumeSelectType;
@property (nonatomic, weak) id<CompanyResumePreviewDelegate> delegate;
@property (nonatomic, assign) BOOL isRecommend;

@property (nonatomic, assign) NSInteger idx;
@property (nonatomic, assign) BOOL selType;
@property (nonatomic,assign) NSInteger selectRow;
@property (nonatomic,strong) NSMutableArray *arrData;
@property (nonatomic,assign) NSInteger currentPage;

- (void)rightBtnClick:(UIButton *)sender;
@end
