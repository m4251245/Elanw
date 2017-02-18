//
//  ZPinfoDataModel.h
//  jobClient
//
//  Created by 一览ios on 16/5/20.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PageInfo.h"

@interface ZPinfoDataModel : PageInfo

@property (nonatomic, copy) NSString *minsalary;
@property (nonatomic, copy) NSString *salaryType;
@property (nonatomic, copy) NSString *jtzw;
@property (nonatomic, copy) NSString *company_cname;
@property (nonatomic, copy) NSString *salary;
@property (nonatomic, copy) NSString *workplace;
@property (nonatomic, copy) NSString *maxsalary;
@property (nonatomic, copy) NSString *logopath;
@property (nonatomic, copy) NSString *zptxt;
@property (nonatomic, copy) NSString *jobtypes;
@property (nonatomic, copy) NSString *job_id;
@property (nonatomic, copy) NSString *edus;
@property (nonatomic, copy) NSString *gznum;
@property (nonatomic, copy) NSString *company_id;
@property (nonatomic, copy) NSString *isdelete;
@property (nonatomic, copy) NSString *zptype;

@property (nonatomic, strong) NSArray *company_tags;
@end
