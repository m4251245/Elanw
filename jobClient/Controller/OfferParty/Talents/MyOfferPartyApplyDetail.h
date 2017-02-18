//
//  MyOfferPartyApplyDetail.h
//  jobClient
//
//  Created by 一览ios on 15/6/19.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"

@interface MyOfferPartyApplyDetail : BaseEditInfoCtl

@property (strong, nonatomic) CompanyInfo_DataModal *companyModel;
@property (weak, nonatomic) IBOutlet UIImageView *companyLogoImgv;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLb;
@property (weak, nonatomic) IBOutlet UILabel *companyJobLb;
@property (weak, nonatomic) IBOutlet UILabel *companyAdressLb;

@property (weak, nonatomic) IBOutlet UIButton *recommendBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmFitBtn;
@property (weak, nonatomic) IBOutlet UIButton *interviewedBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendOfferBtn;
@property (weak, nonatomic) IBOutlet UIButton *interviewBtn;

@property (weak, nonatomic) IBOutlet UIView *redLineView;
@property (weak, nonatomic) IBOutlet UIButton *showCompanyDetailBtn;

@property (weak, nonatomic) IBOutlet UIImageView *articleImgv;
@property (weak, nonatomic) IBOutlet UILabel *articleTitleLb;
@property (weak, nonatomic) IBOutlet UILabel *articleContentLb;
@property (weak, nonatomic) IBOutlet UIButton *moreArticleBtn;

@property (weak, nonatomic) IBOutlet UIView *articleView;

@property(nonatomic, copy) NSString *groupId;

//@property (nonatomic, assign) BOOL isShowInterviewFail; /**<显示面试不合格 */

@end
