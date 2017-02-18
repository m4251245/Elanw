//
//  CHRIndexCtl.h
//  jobClient
//
//  Created by 一览ios on 15/6/2.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
@class CompanyInfo_DataModal;

@interface CHROfferPartyListCtl : BaseListCtl

@property(nonatomic, copy) NSString *companyId;//企业ID
@property (nonatomic,copy) NSString *synergy_id;//协同账号id
@property (strong, nonatomic) CompanyInfo_DataModal *companyInfo;

@property (weak, nonatomic) IBOutlet UIImageView *companyLogoImgv;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLb;
@property (weak, nonatomic) IBOutlet UILabel *statusLb;
@property (weak, nonatomic) IBOutlet UILabel *versionLb;

@end
