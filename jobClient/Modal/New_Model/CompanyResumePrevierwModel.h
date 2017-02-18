//
//  CompanyResumePrevierwModel.h
//  jobClient
//
//  Created by YL1001 on 16/9/21.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyResumePrevierwModel : NSObject


@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *resume_swf;
@property (nonatomic, copy) NSString *resume_pages;
@property (nonatomic, copy) NSString *is_download;   // 0未下载，>0下载了
@property (nonatomic, copy) NSString *role_id;       //公司Id
@property (nonatomic, copy) NSString *fortype;
@property (nonatomic, copy) NSString *desc;       //来源描述（追踪用）
@property (nonatomic, copy) NSString *is_temp;    //1暂存  其他
@property (nonatomic, copy) NSString *is_show;

//转发给我列表特有字段
@property (nonatomic, copy) NSString *send_to_me_result;
@property (nonatomic, copy) NSString *state;     // 0 未处理  1合适，5不合适
@property (nonatomic, copy) NSString *type;      // 0 表示转发评审，1表示面试评审
@property (nonatomic, copy) NSString *sr_accept_m_id;
@property (nonatomic, copy) NSString *company_id;
@property (nonatomic, copy) NSString *sr_send_m_id;
@property (nonatomic, copy) NSString *jobname;
@property (nonatomic, copy) NSString *sr_idate;
@property (nonatomic, copy) NSString *jobid;
@property (nonatomic, copy) NSString *person_id;
@property (nonatomic, copy) NSString *sr_content;
@property (nonatomic, copy) NSString *person_type;
@property (nonatomic, copy) NSString *person_iname;
@property (nonatomic, copy) NSString *cmailbox_id;
@property (nonatomic, copy) NSString *sr_id;
@property (nonatomic, copy) NSString *update_time;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *work_state;

//其他列表
@property (nonatomic, copy) NSString *company_person_result;
@property (nonatomic, copy) NSString *forkey;
@property (nonatomic, copy) NSString *reid;
@property (nonatomic, copy) NSString *isshow;
@property (nonatomic, copy) NSString *sysupdatetime;
@property (nonatomic, copy) NSString *isDel;
@property (nonatomic, copy) NSString *process_state;
@property (nonatomic, copy) NSString *newmail;
@property (nonatomic, copy) NSString *company_state;

//暂存简历列表
@property (nonatomic, copy) NSString *temp_result;
@property (nonatomic, copy) NSString *isDown;
@property (nonatomic, copy) NSString *resumeCfolderId;
@property (nonatomic, copy) NSString *idate;
@property (nonatomic, copy) NSString *regionid;
@property (nonatomic, copy) NSString *uname;
@property (nonatomic, copy) NSString *resumeTempId;
@property (nonatomic, copy) NSString *personId;


@property (nonatomic, copy) NSString *totalid;
@property (nonatomic, copy) NSString *tradeid;
@property (nonatomic, copy) NSString *uid;      //公司ID
@property (nonatomic, copy) NSString *uids;     //集团ID

@property(nonatomic, copy) NSString *action_state;//简历状态
@property(nonatomic, copy) NSString *tj_laber; //主动投递 0  顾问推荐 1


@end
