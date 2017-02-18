//
//  AD_dataModal.h
//  jobClient
//
//  Created by YL1001 on 14/12/3.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "PageInfo.h"


@interface AD_dataModal : PageInfo

@property(nonatomic, copy) NSString *adId;
@property(nonatomic,strong) NSString * title_;
@property(nonatomic,strong) NSString * pic_;
@property(nonatomic,strong) NSString * type_;
@property(nonatomic,strong) NSString * typeId_;
//@property(nonatomic,strong) NSString * status_;
@property(nonatomic,strong) NSString * url_;
@property(nonatomic,strong) NSString * target_;

@property(nonatomic,copy) NSString *OANewsCount;//oa消息

//@property(nonatomic,strong) NSString *expert_id;          //行家ID
@property(nonatomic,strong) NSString *aid;         //文章ID
@property(nonatomic,strong) NSString *pid;                //用户ID
@property(nonatomic,strong) NSString *gid;           //社群ID
@property(nonatomic,strong) NSString *code;               //权限
@property(nonatomic,strong) NSString *group_open_status;  //社群打开状态
@property(nonatomic,strong) NSString *zwid;               //职位id
@property(nonatomic,strong) NSString *company_name;              //公司名称
@property(nonatomic,strong) NSString *company_id;                //公司id
@property(nonatomic,strong) NSString *company_logo;               //公司logo
@property(nonatomic,strong) NSString *question_id;        //问答id
@property(nonatomic,strong) NSString *teachins_id;        //宣讲会详情 or招聘会详情的id

@property(nonatomic,strong) NSString *sharePic;
@property(nonatomic,strong) NSString *shareContent;

@property(nonatomic,strong) UIImage *picImage;

@property(nonatomic,strong) NSString *shareUrl;

@property(nonatomic,copy) NSString *articleTitle;
@property(nonatomic,copy) NSString *articleJoinCnt;

-(instancetype)initWithDictionary:(NSDictionary *)subDic;

@end
