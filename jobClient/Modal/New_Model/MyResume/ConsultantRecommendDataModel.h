//
//  ConsultantRecommendDataModel.h
//  jobClient
//
//  Created by 一览ios on 16/5/20.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PageInfo.h"

@interface ConsultantRecommendDataModel : PageInfo

@property (nonatomic, copy) NSString *report;
@property (nonatomic, copy) NSString *sa_user_id;
@property (nonatomic, copy) NSString *job_id;
@property (nonatomic, copy) NSString *operation;
@property (nonatomic, copy) NSString *person_id;
@property (nonatomic, copy) NSString *vpzr_reason_person;
@property (nonatomic, copy) NSString *vpzr_reason_company;
@property (nonatomic, copy) NSString *reporttype;
@property (nonatomic, copy) NSString *fromtype;
@property (nonatomic, copy) NSString *reportdata;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *idate;
@property (nonatomic, copy) NSString *forkey;
@property (nonatomic, copy) NSString *jjr_project_id;
@property (nonatomic, copy) NSString *direction;
@property (nonatomic, copy) NSString *recommend_type;
@property (nonatomic, copy) NSString *fortype;
@property (nonatomic, copy) NSString *vpzr_id;

@property (nonatomic, strong) NSDictionary *salerperson;
@property (nonatomic, strong) NSArray *zpinfo;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end
