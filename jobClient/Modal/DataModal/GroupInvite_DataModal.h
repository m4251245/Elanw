//
//  GroupInvite_DataModal.h
//  Association
//
//  Created by YL1001 on 14-5-14.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "PageInfo.h"
#import "Groups_DataModal.h"
#import "Expert_DataModal.h"
@class MLEmojiLabel;

@interface GroupInvite_DataModal : PageInfo

@property(nonatomic,strong) NSString * type_;
@property(nonatomic,strong) NSString * id_;
@property(nonatomic,strong) NSString * idatetime_;
@property(nonatomic,assign) BOOL       hasDeleted_;
@property(nonatomic,strong) NSString * resultStatus_;
@property(nonatomic,strong) NSString * updatatime_;
@property(nonatomic,strong) NSString * typeName_;
@property(nonatomic,strong) NSString * statusName_;
@property(nonatomic,assign) BOOL       isAgree_;
@property(nonatomic,assign) BOOL       bRead_;
@property(nonatomic,strong) NSString * createrId_;
@property(nonatomic,strong) NSString * reason;
@property(nonatomic,strong) Groups_DataModal  * groupInfo_;
@property(nonatomic,strong) Expert_DataModal  * requestInfo_;
@property(nonatomic,strong) Expert_DataModal  * responeInfo_;

@property(nonatomic,copy) NSString *yap_id;
@property(nonatomic,copy) NSString *is_read;
@property(nonatomic,copy) NSString *push_type;
@property(nonatomic,copy) NSString *msg_type;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *content;
@property(nonatomic,copy) NSString *person_id;
@property(nonatomic,copy) NSString *person_iname;
@property(nonatomic,copy) NSString *person_pic;
@property(nonatomic,copy) NSString *is_expert;
@property(nonatomic,copy) NSString *article_id;
@property(nonatomic,copy) NSString *article_title;
@property(nonatomic,copy) NSString *group_id;
@property(nonatomic,copy) NSString *group_name;
@property(nonatomic,copy) NSString *is_agree;
@property(nonatomic,copy) NSString *group_pic;
@property(nonatomic,copy) NSString *creater_id;
@property(nonatomic,copy) NSString *comment_id;
@property(nonatomic,copy) NSString *comment_content;
@property(nonatomic,copy) NSString *idatetime;
@property(nonatomic,copy) NSString *parentContent;

@property(nonatomic,copy) NSMutableAttributedString *contentAttString;
@property(nonatomic,assign) CGFloat cellHeight;

-(instancetype)initWithGroupMessageDictionary:(NSDictionary *)dic;
-(instancetype)initWithDictionary:(NSDictionary *)subDic;
-(instancetype)initWithGroupMessageTwoDictionary:(NSDictionary *)dic;
-(instancetype)initWithGroupMessageOneDictionary:(NSDictionary *)dic;
-(void)activityMessageContent;

+(MLEmojiLabel *)emojiLabel:(NSString *)text numberOfLines:(int)num;

@end
