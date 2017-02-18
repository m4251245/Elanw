//
//  InterviewModel_DataModal.h
//  jobClient
//
//  Created by YL1001 on 14-9-13.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "PageInfo.h"

@interface InterviewModel_DataModal : PageInfo

@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy) NSString *resumeId;
@property(nonatomic, copy) NSString *zpId;
@property(nonatomic, copy) NSString *year;
@property(nonatomic, copy) NSString *month;
@property(nonatomic, copy) NSString *day;
@property(nonatomic, copy) NSString *hour;
@property(nonatomic, copy) NSString *min;

@property(nonatomic,strong) NSString * companyId_;
@property(nonatomic,strong) NSString * cname_;
@property(nonatomic,strong) NSString * address_;
@property(nonatomic,strong) NSString * desc_;
@property(nonatomic,strong) NSString * pname_;
@property(nonatomic,strong) NSString * phone_;
@property(nonatomic,strong) NSString * zwname_;
@property(nonatomic,strong) NSString * temlname_;
@property(nonatomic,strong) NSString * zwid_;
@property(nonatomic, copy) NSString *jobName;
@property(nonatomic, copy) NSString *tradeId;

@end
