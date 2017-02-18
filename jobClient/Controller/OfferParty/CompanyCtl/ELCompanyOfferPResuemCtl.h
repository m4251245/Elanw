//
//  ELCompanyOfferPResuemCtl.h
//  jobClient
//
//  Created by YL1001 on 16/9/20.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELBaseListCtl.h"
#import "OfferPartyResumeEnumeration.h"

@interface ELCompanyOfferPResuemCtl : ELBaseListCtl

@property (nonatomic, copy) NSString *jobfair_id;
@property (nonatomic, copy) NSString *fromtype;
@property (nonatomic, copy) NSString *companyId;

@property (nonatomic,copy) NSString *synergy_id;//协同账号id

@property (nonatomic, assign) OPResumeType resumeType;      //简历状态
@property (nonatomic, assign) ComResumeListType resumeListType; //简历列表类型

//职业顾问复用
@property (assign, nonatomic) BOOL counselorFlag; //yes 顾问  no 企业


@end
