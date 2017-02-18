//
//  MsgDetail_DataModal.h
//  CampusClient
//
//  Created by job1001 job1001 on 13-3-12.
//
//

#import "PageInfo.h"

typedef enum
{
    Web_URL_Type    = 10,
    Sys_URL_Type    = 20,
}LinkType;

@interface MsgDetail_DataModal : PageInfo
{
    NSString                *msgId_;            //消息id
    NSString                *dateTimeDes_;      //时间描述
    NSString                *title_;            //标题
    NSString                *pic_;              //路径
    NSString                *summary_;          //概述
    NSString                *content_;          //内容
    NSString                *linkUrl_;          //链接
    
    BOOL                    bImageLoad_;
    NSData                  *imageData_;
    
    LinkType                type_;
}

@property(nonatomic,retain) NSString                *msgId_;
@property(nonatomic,retain) NSString                *dateTimeDes_;
@property(nonatomic,retain) NSString                *title_;
@property(nonatomic,retain) NSString                *pic_;
@property(nonatomic,retain) NSString                *summary_;
@property(nonatomic,retain) NSString                *content_;
@property(nonatomic,retain) NSString                *linkUrl_;
@property(nonatomic,assign) BOOL                    bImageLoad_;
@property(nonatomic,retain) NSData                  *imageData_;
@property(nonatomic,assign) LinkType                type_;


@property(nonatomic,copy) NSString *id_;
@property(nonatomic,copy) NSString *gaa_id;
@property(nonatomic,copy) NSString *article_Id;
@property(nonatomic,copy) NSString *qi_id;
@property(nonatomic,copy) NSString *regionId;
@property(nonatomic,copy) NSString *address;
@property(nonatomic,copy) NSString *intro;
@property(nonatomic,copy) NSString *own_id;
@property(nonatomic,copy) NSString *start_time;
@property(nonatomic,copy) NSString *end_time;
@property(nonatomic,copy) NSString *last_time;
@property(nonatomic,copy) NSString *need_join;
@property(nonatomic,copy) NSString *need_info;
@property(nonatomic,copy) NSString *idatetime;
@property(nonatomic,copy) NSString *status;
@property(nonatomic,copy) NSString *type;
@property(nonatomic,assign) NSInteger joinPeopleCount;
@property(nonatomic,copy) NSString *gaae_name;
@property(nonatomic,copy) NSString *gaae_contacts;
@property(nonatomic,copy) NSString *remark;
@property(nonatomic,copy) NSString *updatetime;
@property(nonatomic,copy) NSString *company;
@property(nonatomic,copy) NSString *group;
@property(nonatomic,copy) NSString *jobs;
@property(nonatomic,copy) NSString *email;
@property(nonatomic,copy) NSString *person_pic;
@property(nonatomic,copy) NSString *person_zw;
@property(nonatomic,copy) NSString *person_job_now;
@property(nonatomic,copy) NSString *person_company;
@property(nonatomic,copy) NSString *person_id;
@property(nonatomic,copy) NSString *person_name;

@property(nonatomic,strong) NSArray *needArr;

@end
