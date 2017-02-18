//
//  ELActivityPeopleCtl.h
//  jobClient
//
//  Created by 一览iOS on 16/6/16.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"

@interface ELActivityPeopleModel : PageInfo

@property (nonatomic, copy) NSString *idatetime;
@property (nonatomic, copy) NSString *jobs;
@property (nonatomic, copy) NSString *gaae_id;
@property (nonatomic, copy) NSString *article_id;
@property (nonatomic, copy) NSString *person_pic;
@property (nonatomic, copy) NSString *person_zw;
@property (nonatomic, copy) NSString *person_company;
@property (nonatomic, copy) NSString *company;
@property (nonatomic, copy) NSString *person_job_now;
@property (nonatomic, copy) NSString *updatetime;
@property (nonatomic, copy) NSString *person_id;
@property (nonatomic, copy) NSString *gaae_contacts;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *group;
@property (nonatomic, copy) NSString *qi_id;
@property (nonatomic, copy) NSString *gaae_name;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *enroll_status;

-(id)initWithDictionary:(NSDictionary *)dic;

@end
