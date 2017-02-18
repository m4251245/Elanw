//
//  ELGroupInviteModel.h
//  jobClient
//
//  Created by 一览ios on 16/6/16.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"
#import "ELExPertModel.h"
#import "ELGroupInfoModel.h"

@interface ELGroupInviteModel : PageInfo
//msg_type = 251  评论
@property(nonatomic, copy) NSString *yap_id;
@property(nonatomic, copy) NSString *is_read;//是否阅读
@property(nonatomic, copy) NSString *push_type;//推送类型
@property(nonatomic, copy) NSString *msg_type;//消息类型
@property(nonatomic, copy) NSString *title;//标题
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *idatetime;
@property(nonatomic, copy) NSString *person_id;
@property(nonatomic, copy) NSString *person_iname;//长度为0 显示匿名
@property(nonatomic, copy) NSString *person_pic;
@property(nonatomic, copy) NSString *is_expert;//
@property(nonatomic, copy) NSString *article_id;
@property(nonatomic, copy) NSString *article_title;
@property(nonatomic, copy) NSString *group_id;//社群id
@property(nonatomic, copy) NSString *comment_id;
@property(nonatomic, copy) NSString *comment_content;//评论
@property(nonatomic, copy) NSString *parentContent;
- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end


@interface ELGroupMessageModel : PageInfo
@property(nonatomic, copy) NSString *yap_id;
@property(nonatomic, copy) NSString *msg_type;
@property(nonatomic, copy) NSString *idatetime;
@property(nonatomic, copy) NSString *is_agree;
@property(nonatomic, assign) BOOL is_read;
@property(nonatomic, copy) NSString *logs_status;
@property(nonatomic, copy) NSString *creater_id;
@property(nonatomic, copy) NSString *apply_reason;//申请理由
@property(nonatomic, strong) ELExPertModel *expertModel;
@property(nonatomic, strong) ELGroupInfoModel *groupInfoModel;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
