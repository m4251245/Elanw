//
//  OfferPartyCompanyResumeModel.h
//  jobClient
//
//  Created by YL1001 on 16/9/20.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"
#import "OfferPartyResumeEnumeration.h"

@interface OfferPartyCompanyResumeModel : PageInfo

@property (nonatomic, copy) NSString *add_user;
@property (nonatomic, copy) NSString *fromtype;   //offer派类型
@property (nonatomic, copy) NSString *jobfair_id; //offer派Id
@property (nonatomic, copy) NSString *resume_id;  //简历Id
@property (nonatomic, copy) NSString *uId;     //公司Id
@property (nonatomic, copy) NSString *tuijian_id;
@property (nonatomic, copy) NSString *jobfair_person_id;
@property (nonatomic, copy) NSString *person_id;
@property (nonatomic, copy) NSString *person_name;
@property (nonatomic, copy) NSString *nianling;
@property (nonatomic, copy) NSString *eduId;        //学历
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *qq;
@property (nonatomic, copy) NSString *shouji;
@property (nonatomic, copy) NSString *report;     //推荐报告 1有 其他没有
@property (nonatomic, copy) NSString *reportUrl;
@property (nonatomic, copy) NSString *report_url;
@property (nonatomic, copy) NSString *job_tj;     //推荐职位
@property (nonatomic, copy) NSString *job_id;     //职位Id
@property (nonatomic, copy) NSString *gznum;      //工作经验
@property (nonatomic, copy) NSString *region;
@property (nonatomic, copy) NSString *current_statusStr;
@property (nonatomic, copy) NSString *current_status;
@property (nonatomic, copy) NSString *gj;
@property (nonatomic, copy) NSString *jumpline;
@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *tj_state;
@property (nonatomic, copy) NSString *delete_flag;
@property (nonatomic, copy) NSString *evaluate_filepath;
@property (nonatomic, copy) NSString *mypersonid;
@property (nonatomic, copy) NSString *guwen_state;
@property (nonatomic, copy) NSString *guwen_time;
@property (nonatomic, copy) NSString *regionid;
@property (nonatomic, copy) NSString *comment_sums;
@property (nonatomic, copy) NSString *gzdd1;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *job;
@property (nonatomic, copy) NSString *yuex;
@property (nonatomic, copy) NSString *bday;
@property (nonatomic, copy) NSString *pages;
@property (nonatomic, copy) NSString *gzdd2;
@property (nonatomic, copy) NSString *apply_time;

//简历状态
@property (nonatomic, copy) NSString *join_state;
@property (nonatomic, copy) NSString *leave_state;   //离场状态 1已离场
@property (nonatomic, copy) NSString *work_state;    //已上岗
@property (nonatomic, copy) NSString *work_time;
@property (nonatomic, copy) NSString *luyong_state;  //录用状态 1录用
@property (nonatomic, copy) NSString *luyong_time;
@property (nonatomic, copy) NSString *wait_mianshi;  //等候面试
@property (nonatomic, copy) NSString *mianshi_state; //面试状态  6合格  7不合格
@property (nonatomic, copy) NSString *mianshi_time;
@property (nonatomic, copy) NSString *company_state; //初选状态  0未操作 1通过初选 2不通过 3待确定
@property (nonatomic, copy) NSString *company_time;
@property (nonatomic, assign) BOOL notOperating;    //YES未做任何操作（等同于company_state == 0）
@property (nonatomic, copy) NSString *read_state;   //0未阅  1已阅

//简历状态枚举
@property (nonatomic, assign) OPResumeType resumeType;

//顾问端特有的字段
@property (nonatomic, copy) NSString *is_contract;
@property (nonatomic, copy) NSString *sendmsg_state;
@property (nonatomic, copy) NSString *company_id;
@property (nonatomic, copy) NSString *pjia_state;
@property (nonatomic, copy) NSString *leave_time;
@property (nonatomic, copy) NSString *tuijian_u_name;
@property (nonatomic, copy) NSString *isdown;
@property (nonatomic, copy) NSString *team_code;
@property (nonatomic, copy) NSString *join_time;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *recom_status;
@property (nonatomic, copy) NSString *ispjia;
@property (nonatomic, copy) NSString *tuijian_state;
@property (nonatomic, copy) NSString *tuijian_name;


@end
