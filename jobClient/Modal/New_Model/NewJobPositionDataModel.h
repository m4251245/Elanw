//
//  NewJobPositionDataModel.h
//  jobClient
//
//  Created by 一览ios on 16/6/2.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"

@interface NewJobPositionDataModel : PageInfo
@property (nonatomic, copy) NSString *gznum;
@property (nonatomic, copy) NSString *minsalary;
@property (nonatomic, copy) NSString *zptype;
@property (nonatomic, copy) NSString *updatetime;
@property (nonatomic, copy) NSString *zpnum;
@property (nonatomic, copy) NSString *cname;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *gznum1;
@property (nonatomic, copy) NSString *edus;
@property (nonatomic, copy) NSString *regionname;
@property (nonatomic, copy) NSString *positionId;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *is_ky;
@property (nonatomic, copy) NSString *maxsalary;
@property (nonatomic, copy) NSString *rctypes;
@property (nonatomic, copy) NSString *cname_all;
@property (nonatomic, copy) NSString *regionid;
@property (nonatomic, copy) NSString *salaryType;
@property (nonatomic, copy) NSString *xzdy;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *gznum2;
@property (nonatomic, copy) NSString *jtzw;
@property (nonatomic, strong) NSArray *fldy;
@property (nonatomic, copy) NSString *benefits;//福利待遇拼接成字符串

@property (nonatomic, strong) UIColor *tagColor;
@property(nonatomic,strong) NSMutableAttributedString *positionAttstring;
@property(nonatomic,strong) NSMutableAttributedString *companyAttString;

@end
