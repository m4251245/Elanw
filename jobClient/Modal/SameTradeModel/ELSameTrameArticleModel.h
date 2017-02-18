//
//  ELSameTrameArticleModel.h
//  jobClient
//
//  Created by 一览iOS on 16/6/6.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"
#import "ELActivityModel.h"
#import "ELArticleVoteModel.h"
#import "ELSalaryModel.h"
#import "ELGroupDetailModal.h"
//@class ELGroupDetailModal;

@interface ELSameTrameArticleModel : PageInfo

@property (nonatomic, copy) NSString *thumb;
@property (nonatomic, copy) NSString *is_expert;
@property (nonatomic, copy) NSString *good_at;
@property (nonatomic, copy) NSString *person_zw;
@property (nonatomic, copy) NSString *article_id;
@property (nonatomic, copy) NSString *person_pic;
@property (nonatomic, copy) NSString *person_nickname;
@property (nonatomic, copy) NSString *personId;
@property (nonatomic, copy) NSString *like_cnt;
@property (nonatomic, copy) NSString *_source_type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *person_iname;
@property (nonatomic, copy) NSString *c_cnt;
@property (nonatomic, copy) NSString *qi_id;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *question_id;
@property (nonatomic, copy) NSString *question_view_count;
@property (nonatomic, copy) NSString *question_replys_count;
@property (nonatomic, copy) NSString *question_title;
@property (nonatomic, copy) NSString *hot_count;
@property (nonatomic, copy) NSString *is_recommend;
@property (nonatomic, copy) NSString *yf_type;
@property (nonatomic, copy) NSString *yf_type_code;
@property (nonatomic, copy) NSString *yf_type_name;
@property (nonatomic, copy) NSString *idatetime;
@property (nonatomic, copy) NSString *_is_new;
@property (nonatomic, copy) NSString *updatetime;
@property (nonatomic, copy) NSString *updatetime_self;
@property (nonatomic, copy) NSString *nf_type_id;
@property (nonatomic, copy) NSString *gnf_id;
@property (nonatomic, copy) NSString *nf_type;
@property (nonatomic, copy) NSString *attachmentStatus;
@property (nonatomic, copy) NSString *fujian_flag;
@property (nonatomic, strong) NSMutableArray *_answer_list;

@property(nonatomic,strong) ELGroupDetailModal *_group_info;
@property(nonatomic,strong) ELActivityModel *_activity_info;
@property(nonatomic,strong) ELSalaryModel *_vote_info;

@property (nonatomic,strong) NSArray *_pic_list;
@property (nonatomic,strong) NSMutableArray *_comment_list;
@property (nonatomic,strong) NSDictionary *_person_detail;

-(id)initWithDictionary:(NSDictionary *)dic;
-(id)initWithFriendDictionary:(NSDictionary *)dic;
-(id)initWithExpertDictionary:(NSDictionary *)dic;

@end
