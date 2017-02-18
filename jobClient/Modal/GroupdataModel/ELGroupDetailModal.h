//
//  ELGroupDetailModal.h
//  jobClient
//
//  Created by 一览iOS on 16/6/3.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"
#import "ELSameTradePeopleModel.h"

@interface ELGroupDetailModal : PageInfo

@property (nonatomic, copy) NSString *person_iname;
@property (nonatomic, copy) NSString *person_pic;
@property (nonatomic, copy) NSString *personId;
@property (nonatomic, copy) NSString *status_desc;
@property (nonatomic, copy) NSString *group_id;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *idatetime;
@property (nonatomic, copy) NSString *group_name;
@property (nonatomic, copy) NSString *group_code;
@property (nonatomic, copy) NSString *is_update_pic;
@property (nonatomic, copy) NSString *group_person_id;
@property (nonatomic, copy) NSString *member_invite;
@property (nonatomic, copy) NSString *group_number;
@property (nonatomic, copy) NSString *group_pic;
@property (nonatomic, copy) NSString *group_source;
@property (nonatomic, copy) NSString *group_audit_status;
@property (nonatomic, copy) NSString *group_tag_names;
@property (nonatomic, copy) NSString *topic_publish;
@property (nonatomic, copy) NSString *group_background;
@property (nonatomic, copy) NSString *trade_desc;
@property (nonatomic, copy) NSString *group_article_cnt;
@property (nonatomic, copy) NSString *group_intro;
@property (nonatomic, copy) NSString *group_person_cnt;
@property (nonatomic, copy) NSString *group_open_status;
@property (nonatomic, copy) NSString *gs_view_content;

@property (nonatomic, copy) NSString *zwid;
@property (nonatomic, copy) NSString *istj;
@property (nonatomic, copy) NSString *updatetime;
@property (nonatomic, copy) NSString *sys_product;
@property (nonatomic, copy) NSString *totalid;
@property (nonatomic, copy) NSString *sys_source;
@property (nonatomic, copy) NSString *group_member_cnt_limit;
@property (nonatomic, copy) NSString *sys_source_version;
@property (nonatomic, copy) NSString *fromtype;
@property (nonatomic, copy) NSString *zwname;
@property (nonatomic, copy) NSString *sysUpdatetime;
@property (nonatomic, copy) NSString *checktime;
@property (nonatomic, copy) NSString *group_show_grcode;
@property (nonatomic, copy) NSString *updatetime_act_last;
@property (nonatomic, copy) NSString *tradeid;

//100表示普通+群聊，50表示只有群聊方式，10表示普通
@property (nonatomic, copy) NSString *groups_communicate_mode;
//默认话题Id
@property (nonatomic, copy) NSString *auto_article_id;

//推送消息设置  2 表示不接收本群的推送消息 1表示接收 
@property (nonatomic, copy) NSString *setcode;


@property (nonatomic, strong) ELSameTradePeopleModel *group_person_detail;

-(id)initWithDictionary:(NSDictionary *)dic;
-(id)initWithGroupDictionary:(NSDictionary *)dic;

@end
