//
//  NewResumeNotifyDataModel.h
//  jobClient
//
//  Created by 一览ios on 16/6/3.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"

@interface NewResumeNotifyDataModel : PageInfo
@property (nonatomic, copy) NSString *uid;//公司
@property (nonatomic, copy) NSString *positionId;//职位
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *sdate;
@property (nonatomic, copy) NSString *cname;
@property (nonatomic, copy) NSString *zpId;
@property (nonatomic, copy) NSString *senduid;
@property (nonatomic, copy) NSString *cmp_service;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *newmail;

@property (nonatomic, copy) NSString *cxz;
@property (nonatomic, copy) NSString *readNumber;
@property (nonatomic, copy) NSString *readDate;
@property (nonatomic, copy) NSString *personId;

@property (nonatomic, copy) NSString *mailtext;
@property (nonatomic, copy) NSString *sendname;
@end
