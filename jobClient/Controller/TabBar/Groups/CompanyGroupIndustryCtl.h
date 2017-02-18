//
//  CompanyGroupIndustryCtl.h
//  jobClient
//
//  Created by 一览iOS on 15-4-25.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "GroupsChangeTypeCtl.h"

@interface CompanyGroupIndustryCtl : BaseListCtl

@property (nonatomic,strong) GroupsChangeTypeCtl *companyCtl;
@property (nonatomic,strong) NSMutableArray *arrData;

@end
