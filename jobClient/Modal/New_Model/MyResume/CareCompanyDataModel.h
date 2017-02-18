//
//  CareCompanyDataModel.h
//  jobClient
//
//  Created by 一览ios on 16/6/8.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"

@interface CareCompanyDataModel : PageInfo
@property (nonatomic, copy) NSString *cxz;
@property (nonatomic, copy) NSString *addtime;
@property (nonatomic, copy) NSString *company_id;
@property (nonatomic, copy) NSString *logopath;
@property (nonatomic, copy) NSString *trade;
@property (nonatomic, copy) NSString *yuangong;
@property (nonatomic, copy) NSString *cname;
@property (nonatomic, copy) NSString *cmp_service;
@property (nonatomic, strong) NSDictionary *zw_update;
@property(nonatomic, copy) NSString *zwUpdateCnt_;

@property (nonatomic,assign) BOOL canEdit_;

@end
