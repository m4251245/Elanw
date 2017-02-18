//
//  ELArticleDetailModel.h
//  jobClient
//
//  Created by 一览iOS on 16/8/2.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"
#import "ELGroupDetailModal.h"
@class ELSameTradePeopleModel;
@class ELActivityModel;
//@class ELGroupDetailModal;

@interface ELArticleDetailModel : PageInfo

@property(nonatomic,copy) NSString *id_;
@property(nonatomic,copy) NSString *content;
@property(nonatomic,copy) NSString *ctime;
@property(nonatomic,copy) NSString *status;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *v_cnt;
@property(nonatomic,copy) NSString *c_cnt;
@property(nonatomic,copy) NSString *summary;
@property(nonatomic,copy) NSString *thumb;
@property(nonatomic,copy) NSString *_is_favorite;
@property(nonatomic,copy) NSString *like_cnt;
@property(nonatomic,copy) NSString *_is_majia;
@property(nonatomic,copy) NSString *_group_source;
@property(nonatomic,strong) NSMutableArray *zhiwei;
@property(nonatomic,strong) NSArray *_pic_list;
@property(nonatomic,strong) ELSameTradePeopleModel *person_detail;
@property(nonatomic,strong) ELActivityModel *_activity_info;
@property(nonatomic,strong) ELGroupDetailModal *_group_info;
@property(nonatomic,strong) NSMutableArray *_media;
@property(nonatomic,strong) ELSameTradePeopleModel *_majia_info;
@property(nonatomic,strong) NSMutableArray *other_article;
@property(nonatomic,strong) NSDictionary *dicJoinName;
@property(nonatomic,strong) NSDictionary *groupUserRel;
@property(nonatomic,strong) NSDictionary *apply_status_info;

@property(nonatomic,assign) BOOL isLike_;

//招聘群 表示是不是默认话题 1是默认话题 2是简历话题 0是其他类型
@property (nonatomic, copy) NSString *qi_id_isdefault;
@property (nonatomic, copy) NSString *url;

-(instancetype)initWithDictionary:(NSDictionary *)dic;

@end
