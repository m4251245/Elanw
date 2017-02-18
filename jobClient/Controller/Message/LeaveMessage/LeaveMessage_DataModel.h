//
//  LeaveMessage_DataModel.h
//  jobClient
//
//  Created by 一览ios on 14/12/10.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//留言

#import "PageInfo.h"
#import "ELAspectantDiscuss_Modal.h"
#import <UIKit/UIKit.h>

typedef  NS_ENUM(NSInteger, MessageDailogType){
    MessageTypeText, //文本消息
    MessageTypeShareUser, //分享用户
    MessageTypeShareJob, //分享职位
    MessageTypeLikeArticle,
    MessageTypeLikeComment,
    MessageTypeGroupArticle,
    MessageTypeVoice,    //语音消息
    MessageTypeGroup,
    MessageTypeImage,
    MessageTypeQuestioning,
    MessageTypeWeiTuo,
    MessageTypeShareReusme//转发简历
};

//消息发送状态
typedef  NS_ENUM(NSInteger, MsgUploadStatus){
    MsgUploadStatusInit = 1,         //开始上传
    MsgUploadStatusUpLoading = 2,    //上传中
    MsgUploadStatusFailed = 3,       //上传失败
    MsgUploadStatusOk = 4,           //上传完成
};

@interface LeaveMessage_DataModel : PageInfo

//消息类型
@property (assign, nonatomic) MessageDailogType messageType;
//消息上传状态
@property (assign, nonatomic) MsgUploadStatus msgUploadStatus;
//对方用户名
@property(nonatomic, copy) NSString *toUserName;
//对方用户ID
@property(nonatomic, copy) NSString *toUserId;

@property(nonatomic, copy) NSString *msgId;
@property(nonatomic, copy) NSString *isSend;
@property(nonatomic, copy) NSString *personIName;
@property(nonatomic, copy) NSString *personPic;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *aacLocalUrl;
@property(nonatomic, copy) NSString *voiceTime;
@property(nonatomic, copy) NSString *date;
@property(nonatomic, copy) NSString *code;//返回代码

@property(nonatomic,copy) NSString *imageUrl_;
@property (nonatomic, strong) UIImage *image;
//分享消息专用
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *thum;//缩略图

@property (strong, nonatomic) id otherModel;

@property(assign,nonatomic) BOOL isImage;

@property(copy,nonatomic) NSString *questionTitle;
@property(copy,nonatomic) NSString *questionMobile;
@property(copy,nonatomic) NSString *questionContent;
@property(copy,nonatomic) NSString *introContent;
@property(copy,nonatomic) NSString *questionTips;

@property(nonatomic,copy) NSString *client_user_id;
@property(nonatomic,copy) NSString *broker_user_id;

//群聊才用到
@property(nonatomic, copy) NSString *article_id;
@property(nonatomic, copy) NSString *qi_id_isdefault;
@property(nonatomic, copy) NSString *tagName;
@property(nonatomic, copy) NSMutableAttributedString *attString;

//数据库操作需要用到
@property (nonatomic, copy) NSString *personId;
@property (nonatomic, copy) NSString *groupId;

@property(strong,nonatomic) ELAspectantDiscuss_Modal *aspDiscuss;

-(instancetype)initWithShareDictionary:(NSDictionary *)dic;
-(instancetype)initWithTextDictionary:(NSDictionary *)dic;

@end
