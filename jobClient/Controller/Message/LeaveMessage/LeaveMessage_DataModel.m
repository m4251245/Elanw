//
//  LeaveMessage_DataModel.m
//  jobClient
//
//  Created by 一览ios on 14/12/10.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "LeaveMessage_DataModel.h"
#import "JobSearch_DataModal.h"
#import "User_DataModal.h"
#import "ShareMessageModal.h"
#import "Article_DataModal.h"
#import "Groups_DataModal.h"

@implementation LeaveMessage_DataModel


-(instancetype)initWithShareDictionary:(NSDictionary *)dic
{
    NSDictionary *dict = dic;
    self = [super init];
    if (self) {
        self.msgId = dict[@"pmsg_id"];
        self.isSend = dict[@"is_send"];
        self.personIName = dict[@"person_iname"];
        self.personPic = dict[@"person_pic"];
        self.content = dict[@"content"];
        self.date = dict[@"idate"];
        //[MyCommon getWhoLikeMeListCurrentTime:[MyCommon getDate:self.oldDate] currentTimeString:self.oldDate];
        if (self.date.length == 0) {
            self.date = @"刚刚";
        }
        NSDictionary *shareInfo = dict[@"_share_info"];
        
        if (!shareInfo || ![shareInfo isKindOfClass:[NSDictionary class]])
        {
            shareInfo = dict[@"share"];
        }
        NSString *shareType = shareInfo[@"type"];
        NSDictionary *shareDict = shareInfo[@"slave"];
        if ([shareType isEqualToString:@"20"]) {//职位分享
            self.messageType = MessageTypeShareJob;
            JobSearch_DataModal *jobModel = [[JobSearch_DataModal alloc]init];
            jobModel.zwID_ = shareDict[@"position_id"];
            jobModel.companyLogo_ = shareDict[@"position_logo"];
            jobModel.zwName_ = shareDict[@"position_name"];
            jobModel.salary_  = shareDict[@"position_salary"];
            jobModel.companyName_ = shareDict[@"position_company"];
            jobModel.companyID_ = shareDict[@"position_company_id"];
            self.otherModel = jobModel;
        }else if ([shareType isEqualToString:@"1"]) {//人才分享
            self.messageType = MessageTypeShareUser;
            User_DataModal *userModel = [[User_DataModal alloc]init];
            userModel.img_ = shareDict[@"person_pic"];
            userModel.uname_= shareDict[@"person_iname"];
            userModel.userId_ = shareDict[@"person_id"];
            userModel.zym_ = shareDict[@"person_zw"];
            self.otherModel = userModel;
        }
        else if ([shareType isEqualToString:@"25"])//简历转发
        {
            self.messageType = MessageTypeShareReusme;
            ShareMessageModal *userModel = [[ShareMessageModal alloc]init];
            userModel.personId = shareDict[@"person_id"];
            userModel.personName = shareDict[@"person_iname"];
            userModel.person_pic = shareDict[@"person_pic"];
            userModel.person_zw = shareDict[@"person_zw"];
            userModel.person_gznum = shareDict[@"person_gznum"];
            userModel.person_edu = shareDict[@"person_edu"];
            
            userModel.personName = [MyCommon translateHTML:userModel.personName];
            userModel.person_zw = [MyCommon translateHTML:userModel.person_zw];
            userModel.person_gznum = [MyCommon translateHTML:userModel.person_gznum];
            userModel.person_edu = [MyCommon translateHTML:userModel.person_edu];
            self.otherModel = userModel;
        }
        else if ([shareType isEqualToString:@"30"])// 赞了文章
        {
            self.messageType = MessageTypeLikeArticle;
            Article_DataModal *modal = [[Article_DataModal alloc] init];
            modal.id_ = shareDict[@"article_id"];
            modal.title_ = shareDict[@"article_title"];
            modal.thum_ = shareDict[@"article_thumb"];
            modal.summary_ = shareDict[@"article_summary"];
            modal.xw_type_ = shareDict[@"article_type"];
            self.otherModel = modal;
        }
        else if ([shareType isEqualToString:@"31"])//赞了评论
        {
            self.messageType = MessageTypeLikeComment;
            Article_DataModal *modal = [[Article_DataModal alloc] init];
            modal.personID_ = shareDict[@"comment_id"];
            modal.content_ = shareDict[@"comment_content"];
            modal.id_ = shareDict[@"article_id"];
            modal.title_ = shareDict[@"article_title"];
            modal.xw_type_ = shareDict[@"article_type"];
            self.otherModel = modal;
        }
        else if([shareType isEqualToString:@"11"] || [shareType isEqualToString:@"2"])//社群文章分享
        {
            self.messageType = MessageTypeGroupArticle;
            Article_DataModal *modal = [[Article_DataModal alloc] init];
            modal.id_ = shareDict[@"article_id"];
            modal.title_ = shareDict[@"article_title"];
            modal.thum_ = shareDict[@"article_thumb"];
            modal.summary_ = shareDict[@"article_summary"];
            modal.title_ = [MyCommon translateHTML:modal.title_];
            self.otherModel = modal;
        }
        else if([shareType isEqualToString:@"10"])//社群分享
        {
            self.messageType = MessageTypeGroup;
            Groups_DataModal *modal = [[Groups_DataModal alloc] init];
            modal.id_ = shareDict[@"group_id"];
            modal.name_ = shareDict[@"group_name"];
            modal.pic_ = shareDict[@"group_pic"];
            modal.personCnt_ = [shareDict[@"group_person_cnt"] integerValue];
            modal.articleCnt_ = [shareDict[@"group_article_cnt"] integerValue];
            modal.name_ = [MyCommon translateHTML:modal.name_];
            self.otherModel = modal;
        }
        else if([shareType isEqualToString:@"4"])//图片分享
        {
            self.messageType = MessageTypeImage;
            self.imageUrl_ = shareDict[@"path"];
        }
        else if ([shareType isEqualToString:@"5"]){ //语音消息
            //语音消息封装
            self.messageType = MessageTypeVoice;
            NSString *tempStr = shareDict[@"path"];;
            self.imageUrl_ = tempStr;
            NSArray *voiceArr = [tempStr componentsSeparatedByString:@"#"];
            self.voiceTime = [voiceArr lastObject];
            if ([voiceArr count] >=2) {
                self.voiceTime = [voiceArr lastObject];
            }
            tempStr = [voiceArr firstObject];
            self.content = tempStr;
        }
        else if ([shareType isEqualToString:@"6"])//约谈消息
        {
            self.messageType = MessageTypeQuestioning;
            
            self.aspDiscuss = [[ELAspectantDiscuss_Modal alloc] init];
            self.aspDiscuss.recordId = shareDict[@"record_id"];
            
            if (self.aspDiscuss.recordId == nil || [self.aspDiscuss.recordId isEqualToString:@""]) {
                
                self.questionTitle = shareDict[@"title"];
                self.questionMobile = shareDict[@"mobile"];
                self.questionContent = shareDict[@"question"];
                self.introContent = shareDict[@"intro"];
                self.questionTips = shareDict[@"tips"];
            }
            else
            {
                self.aspDiscuss.course_title = shareDict[@"course_title"];
                self.aspDiscuss.course_price = shareDict[@"course_price"];
                self.aspDiscuss.dataTime = shareDict[@"idatetime"];
                self.aspDiscuss.YTZ_id = shareDict[@"person_id"];
                self.aspDiscuss.BYTZ_Id = shareDict[@"yuetan_person_id"];
                
                if ([[Manager getUserInfo].userId_ isEqualToString:self.aspDiscuss.YTZ_id]) {
                    self.aspDiscuss.user_personId = [Manager getUserInfo].userId_;
                    self.aspDiscuss.user_name = [Manager getUserInfo].name_;
                    self.aspDiscuss.user_pic = [Manager getUserInfo].img_;
                    self.aspDiscuss.user_zw = [Manager getUserInfo].job_;
                    
                    self.aspDiscuss.dis_personId = shareDict[@"yuetan_person_detail"][@"personId"];
                    self.aspDiscuss.dis_personName = shareDict[@"yuetan_person_detail"][@"person_iname"];;
                    self.aspDiscuss.dis_pic = shareDict[@"yuetan_person_detail"][@"person_pic"];
                    self.aspDiscuss.dis_zw = shareDict[@"yuetan_person_detail"][@"person_zw"];
                }
                else
                {
                    self.aspDiscuss.user_personId = shareDict[@"person_detail"][@"personId"];
                    self.aspDiscuss.user_name = shareDict[@"person_detail"][@"person_iname"];
                    self.aspDiscuss.user_pic = shareDict[@"person_detail"][@"person_pic"];
                    self.aspDiscuss.user_zw = shareDict[@"person_detail"][@"person_zw"];
                    
                    self.aspDiscuss.dis_personId = [Manager getUserInfo].userId_;
                    self.aspDiscuss.dis_personName = [Manager getUserInfo].name_;
                    self.aspDiscuss.dis_pic = [Manager getUserInfo].img_;
                    self.aspDiscuss.dis_zw = [Manager getUserInfo].job_;
                }
            }
        }
        else if ([shareType isEqualToString:@"50"])
        {
            self.messageType = MessageTypeWeiTuo;
            self.msgId = dict[@"pmsg_id"];
            self.isSend = dict[@"is_send"];
            self.personIName = dict[@"person_iname"];
            self.personPic = dict[@"person_pic"];
            self.content = dict[@"content"];;
            self.date = dict[@"idate"];
            //[MyCommon getWhoLikeMeListCurrentTime:[MyCommon getDate:self.oldDate] currentTimeString:self.oldDate];
            self.client_user_id = shareDict[@"client_user_id"];
            self.broker_user_id = shareDict[@"broker_user_id"];
        }
        else
        {
            self.messageType = MessageTypeText;
        }
        
        self.title = [MyCommon translateHTML:self.title];
        self.content = [MyCommon translateHTML:self.content];
        
    }
    return self;
}
-(instancetype)initWithTextDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.messageType = MessageTypeText;
        self.msgId = dic[@"pmsg_id"];
        self.isSend = dic[@"is_send"];
        self.personIName = dic[@"person_iname"];
        self.personPic = dic[@"person_pic"];
        self.content = dic[@"content"];
        self.date = dic[@"idate"];
        //[MyCommon getWhoLikeMeListCurrentTime:[MyCommon getDate:self.oldDate] currentTimeString:self.oldDate];
        if (self.date.length == 0) {
            self.date = @"刚刚";
        }
    }
    return self;
}


@end
