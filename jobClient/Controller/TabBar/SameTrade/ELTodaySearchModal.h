//
//  ELTodaySearchModal.h
//  jobClient
//
//  Created by 一览iOS on 15/10/22.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PageInfo.h"
#import "JobSearch_DataModal.h"
#import "OfferPartyTalentsModel.h"
#import "NewJobPositionDataModel.h"

typedef enum
{
    ExpertSearchType,
    SameTradeSearchType,
    ArticleSearchType,
    GroupSearchType,
    OfferSearchType,
    JobSearchType
}SearchDataType;

@interface ELTodaySearchModal : PageInfo

@property(nonatomic,assign) SearchDataType modelType;

@property(nonatomic,strong) NSMutableAttributedString *attStringTitle;
@property(nonatomic,strong) NSMutableAttributedString *attStringContent;
@property(nonatomic,strong) NSMutableAttributedString *attStringDetial;

@property(nonatomic,copy) NSString *personId;
@property(nonatomic,copy) NSString *person_pic;
@property(nonatomic,copy) NSString *person_iname;
@property(nonatomic,copy) NSString *person_zw;
@property(nonatomic,copy) NSString *person_job_now;
@property(nonatomic,copy) NSString *person_gznum;
@property(nonatomic,copy) NSString *is_expert;

@property(nonatomic,copy) NSString *article_id;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *thumb;
@property(nonatomic,copy) NSString *summary;
@property(nonatomic,copy) NSString *ctime;
@property(nonatomic,copy) NSString *person_pic_personality;
@property(nonatomic,copy) NSString *person_nickname;

@property(nonatomic,copy) NSString *group_id;
@property(nonatomic,copy) NSString *group_name;
@property(nonatomic,copy) NSString *group_pic;
@property(nonatomic,copy) NSString *group_person_cnt;
@property(nonatomic,copy) NSString *group_article_cnt;
@property(nonatomic,copy) NSString *group_updatetime_last;
@property(nonatomic,copy) NSString *openstatus;//3为私密社群
@property(nonatomic,copy) NSString *own_id;
@property(nonatomic,copy) NSString *commentId;
@property(nonatomic,copy) NSString *comment_article_id;
@property(nonatomic,copy) NSString *comment_user_id;
@property(nonatomic,copy) NSString *comment_parent_id;
@property(nonatomic,copy) NSString *comment_content;
@property(nonatomic,copy) NSString *comment_ctime;
@property(nonatomic,copy) NSString *comment_personId;
@property(nonatomic,copy) NSString *comment_person_iname;
@property(nonatomic,copy) NSString *comment_person_pic;
@property(nonatomic,copy) NSString *articleListContent;

@property(nonatomic,copy) NSString *public_personId;
@property(nonatomic,copy) NSString *public_person_iname;
@property(nonatomic,copy) NSString *public_person_pic;
@property(nonatomic,copy) NSString *public_person_zw;

@property(nonatomic,strong) OfferPartyTalentsModel *offerModal;
@property(nonatomic,strong) NewJobPositionDataModel  *jobModel;

@property(nonatomic,assign) BOOL showMore;

//add 5.9.5 私密社群
@property(nonatomic, copy) NSString *group_user_rel;//用户与社群关系


-(void)changeColor:(NSMutableAttributedString *)attString withKeyWork:(NSString *)text;
-(instancetype)initExpertModelWithDictionary:(NSDictionary *)dic;
-(instancetype)initSameTradeModelWithDictionary:(NSDictionary *)dic;
-(instancetype)initArticleModalWithDictionary:(NSDictionary *)dic;
-(instancetype)initGroupModalWithDictionary:(NSDictionary *)dic;
-(instancetype)initOfferModalWithDictionary:(NSDictionary *)dataDic;
-(instancetype)initPositionModelWithDictionary:(NSDictionary *)dic;

@end
