//
//  Message_DataModal.h
//  Association
//
//  Created by 一览iOS on 14-4-15.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PageInfo.h"

/*
 消息类型
 160 薪闻
 180 提问被回答
 181 收到新提问
 190 用户发表
 200 社群新发表
 251 社群话题有新评论
 201 收到加入社群的邀请
 202 收到加入社群的饿申请
 40  面试通知
 210 职位订阅
 250 发表的文章有新评论
 50  简历被查看
 310 成功加入社群
 350 新增听众
*/

@interface Message_DataModal : PageInfo

@property(nonatomic,strong) NSString * userId_;             //接收者Id
@property(nonatomic,strong) NSString * messageId_;          //消息id
@property(nonatomic,strong) NSString * type_;               //消息类型
@property(nonatomic,strong) NSString * publishName_;        //类型对应显示名称
@property(nonatomic,strong) NSString * content_;            //显示内容
@property(nonatomic,strong) NSString * time_;               //推送时间
@property(nonatomic,strong) NSString * beNew_;              //是否是新消息
@property(nonatomic,strong) NSString * status_;             //0为失败，1为成功
@property(nonatomic,strong) NSString * objectId_;           //对应的内容的id
@property(nonatomic,strong) NSDictionary * extraDic_;       //必要的数据内容
@property(nonatomic,assign) BOOL            group_bExist_;
@property(nonatomic,assign) BOOL            group_bMember_;


@property(nonatomic,assign) NSInteger         toolBarGroupCnt;          /**<toolbar 社群消息总数*/
@property(nonatomic,assign) NSInteger         companyCnt;               /**<toolbar 我的招聘的数量)*/
@property(nonatomic,assign) NSInteger         resumeCnt;                 /**<简历消息的数量*/
@property(nonatomic,assign) NSInteger         messageCnt;                /**<我的消息的数量(包括私信和系统通知)*/
@property(nonatomic,assign) NSInteger         questionCnt;               /**<我的问答的数量*/
@property(nonatomic,assign) NSInteger         sameTradeMessageCnt;       //朋友圈消息个数
@property(nonatomic,assign) NSInteger         friendMessageCnt;
@property(nonatomic,assign) NSInteger         myInterViewCnt;            //我的约谈消息个数

@property(nonatomic,assign) NSInteger         oaMsgCount;              //oa消息个数

@end
