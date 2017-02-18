//
//  ELSalaryResultModel.h
//  jobClient
//
//  Created by 一览ios on 16/6/6.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"
//#import "User_DataModal.h"
#import "ELUserModel.h"

@interface ELSalaryResultModel : PageInfo
@property(nonatomic, copy) NSString *_id;
@property(nonatomic, copy) NSString *jtzw;
@property(nonatomic, copy) NSString *person_id;//用户id
@property(nonatomic, copy) NSString *person_sex;//性别
@property(nonatomic, copy) NSString *person_yuex;//月薪
@property(nonatomic, copy) NSString *sendtime;//
@property(nonatomic, copy) NSString *zw_typename;
@property(nonatomic, copy) NSString *zw_typename2;
@property(nonatomic, copy) NSString *_show_type;
@property(nonatomic, copy) NSString *sendtime_desc;
@property(nonatomic, copy) NSString *percent;//比例
@property(nonatomic, strong) NSDictionary *personInfo;

@property(nonatomic, copy) NSString *des_;
@property(nonatomic, strong) ELUserModel *userInfo;

//查工资列表需要的字段
@property (nonatomic, copy) NSString *person_iname;
@property (nonatomic, copy) NSString *zw_regionid;
@property (nonatomic, copy) NSString *zw_typeid2;
@property (nonatomic, copy) NSString *person_eduId;
@property (nonatomic, copy) NSString *cname;
@property (nonatomic, copy) NSString *totalid;
@property (nonatomic, copy) NSString *school;
@property (nonatomic, copy) NSString *person_age;
@property (nonatomic, copy) NSString *person_gznum;
@property (nonatomic, copy) NSString *company_id;
@property (nonatomic, copy) NSString *person_jobs_all;
@property (nonatomic, copy) NSString *sendtime_show;
@property (nonatomic, copy) NSString *zw_regionid_show;
@property (nonatomic, copy) NSString *cnt_day;
@property (nonatomic, copy) NSString *tradeid;
@property (nonatomic, copy) NSString *zw_typeid;
@property (nonatomic, copy) NSString *zpid;
@property (nonatomic, copy) NSString *edu_name;
@property (nonatomic, copy) NSString *_pic;

@property (nonatomic, copy) NSString *zym;
@property (nonatomic, copy) NSString *bday;
@property (nonatomic, copy) NSString *eduId_desc;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *job_desc;
@property (nonatomic, copy) NSString *salary;
@property (nonatomic, copy) NSString *regionid_desc;
@property (nonatomic, copy) NSString *regionid;
@property (nonatomic, copy) NSString *iname;
@property (nonatomic, copy) NSString *zye;
@property (nonatomic, copy) NSString *totalid_desc;
@property (nonatomic, copy) NSString *gznum;

- (instancetype)initWithDictionary:(NSDictionary *)dic;
- (instancetype)initWithSalaryDictionary:(NSDictionary *)dic;

@end
