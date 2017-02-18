//
//  ELSameTradePeopleModel.h
//  jobClient
//
//  Created by 一览iOS on 16/6/8.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"
#import "ELGroupExpertModel.h"
#import "ELGroupCountModel.h"

@interface ELSameTradePeopleModel : PageInfo

@property (nonatomic, copy) NSString *is_expert;
@property (nonatomic, copy) NSString *person_zw;
@property (nonatomic, copy) NSString *same_city;
@property (nonatomic, copy) NSString *person_sex;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *person_pic;
@property (nonatomic, copy) NSString *personId;
@property (nonatomic, copy) NSString *person_id;
@property (nonatomic, copy) NSString *rel;
@property (nonatomic, copy) NSString *yl_person_flag;
@property (nonatomic, copy) NSString *person_job_now;
@property (nonatomic, copy) NSString *is_shiming;
@property (nonatomic, copy) NSString *same_hka;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *person_gznum;
@property (nonatomic, copy) NSString *send_mail_flag;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *person_iname;
@property (nonatomic, copy) NSString *person_age;
@property (nonatomic, copy) NSString *same_school;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, copy) NSString *good_at;
@property (nonatomic, copy) NSString *publish_count;
@property (nonatomic, copy) NSString *answer_count;
@property (nonatomic, copy) NSString *fans_count;
@property (nonatomic, copy) NSString *groups_count;

@property (nonatomic,strong) NSDictionary *info;

@property (nonatomic, copy) NSString *ip;
@property (nonatomic, copy) NSString *person_pic_personality;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *person_rctype;
@property (nonatomic, copy) NSString *person_nickname;
@property (nonatomic, copy) NSString *idatetime;
@property (nonatomic, copy) NSString *person_user_type;
@property (nonatomic, copy) NSString *person_mobile_quhao;
@property (nonatomic, copy) NSString *person_reg_type;
@property (nonatomic, copy) NSString *person_idate;
@property (nonatomic, copy) NSString *totalid;
@property (nonatomic, copy) NSString *be_id;
@property (nonatomic, copy) NSString *person_signature;
@property (nonatomic, copy) NSString *person_email;
@property (nonatomic, copy) NSString *person_mobile;
@property (nonatomic, copy) NSString *person_reg_url;
@property (nonatomic, copy) NSString *person_company;
@property (nonatomic, copy) NSString *be_client_user_id;
@property (nonatomic, copy) NSString *client_ip;
@property (nonatomic, copy) NSString *tradeid;
@property (nonatomic, copy) NSString *be_user_id;
@property (nonatomic, copy) NSString *addtime;
@property (nonatomic, copy) NSString *is_group_member;
@property (nonatomic, copy) NSString *trade_job_desc;

@property (nonatomic, copy) NSString *topic_publish;
@property (nonatomic, copy) NSString *member_invite;
@property (nonatomic, copy) NSString *group_user_role;
@property (nonatomic, copy) NSString *group_id;
@property (nonatomic, copy) NSString *gp_id;

@property (nonatomic, strong) ELGroupExpertModel *expert_detail;
@property (nonatomic, strong) ELGroupCountModel *count_list;

-(id)initWithDictionary:(NSDictionary *)dic;

@end
