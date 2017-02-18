//
//  Expert_DataModal.h
//  Association
//
//  Created by 一览iOS on 14-1-17.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "Author_DataModal.h"
#import "Comment_DataModal.h"
#import "ELAspectantDiscuss_Modal.h"
#import "ZWDetail_DataModal.h"

typedef enum
{
    Dynamic_Other,     //其他
    Dynamic_Article,   //发表文章
    Dynamic_Audio,     //上传录音
    Dynamic_Photo,     //上传职业风采照
    Dynamic_Tag,       //添加标签
    Dynamic_Group,     //加入社群
    Dynamic_Follow,    //关注了别人
    Dynamic_Pic,       //上传了头像
    
}Dynamic_Type;

@interface Expert_DataModal : Author_DataModal

@property(nonatomic,copy) NSString * backImagePath;
@property(nonatomic,copy) NSString * backImageUrl;
@property(nonatomic,copy) NSString * backImageId;
@property(nonatomic,copy) NSString * backImageName;

@property(nonatomic,strong) NSString * introduce_;
@property(nonatomic,strong) NSString * expertIntroduce_;
@property(nonatomic,copy) NSString * isHaveBroker;//是否是职业经纪人
@property(nonatomic,strong) NSString * goodat_;
@property(nonatomic,copy) NSString *good_at;//擅长领域
@property(nonatomic,assign) NSInteger  questionCnt_;
@property(nonatomic,assign) NSInteger  yuetabCnt_;
@property(nonatomic,assign) NSInteger  answerCnt_;
@property(nonatomic,assign) NSInteger  followCnt_;
@property(nonatomic,assign) NSInteger  fansCnt_;
@property(nonatomic,assign) NSInteger  letterCnt_;
@property(nonatomic,assign) NSInteger  publishCnt_;
@property(nonatomic,assign) NSInteger  groupsCnt_;
@property(nonatomic,assign) NSInteger  groupsCreateCnt_;
@property(nonatomic,assign) NSInteger  followStatus_;
@property(nonatomic,assign) NSInteger  favoriteCnt_;
@property(nonatomic,strong) NSString * articleId_;
@property(nonatomic,strong) NSString * content_;
@property(nonatomic,strong) NSString * ctime_;
@property(nonatomic,strong) NSString * commentCnt_;
@property(nonatomic,strong) NSString * is_article;
@property(nonatomic,strong) NSString * expertId_;
@property(nonatomic,assign) BOOL       isExpert_;
@property(nonatomic,strong) NSString * followerName_;
@property(nonatomic,strong) NSString * followerId_;
@property(nonatomic,strong) NSString *prestigeCnt;
@property(nonatomic,strong) NSString         *role_;
@property(nonatomic,strong) NSString         *jobStatus;
@property(nonatomic,strong) NSString         *gpId_;
@property(nonatomic,strong) NSString         *tradeId;
@property(nonatomic,strong) NSString         *tradeName;

@property(nonatomic,assign) BOOL             invitePerm_;
@property(nonatomic,assign) BOOL             publishPerm_;
@property(nonatomic,assign) BOOL             is_Hr;
@property(nonatomic,assign) BOOL             is_Rc;
@property(nonatomic,assign) BOOL              isInvite_;
@property(nonatomic,strong) NSString         *sameSchool_;
@property(nonatomic,strong) NSString         *sameCity_;
@property(nonatomic,strong) NSString         *sameHometown_;
@property(nonatomic,strong) NSMutableArray   *relationArray_;

@property(nonatomic,strong) NSString         *cityStr_;
@property(nonatomic,strong) NSString         *hkaStr_;
@property(nonatomic,strong) NSString         *schoolStr_;

@property(nonatomic,strong) NSString         *ylPersonFlag_;
@property(nonatomic,strong) NSString         *sendEmailFlag_;
@property(nonatomic,strong) NSString         *isNewFollow_;

@property(nonatomic,strong) NSString * articleTitle_;
@property(nonatomic,strong) NSString * articleCtime_;
@property(nonatomic,strong) NSString * articleImg_;
@property(nonatomic,strong) NSString * articleSummary_;
@property(nonatomic,assign) NSInteger         articleVCnt_;
@property(nonatomic,assign) NSInteger         articleCCnt_;
@property(nonatomic,assign) NSInteger         articleLCnt_;
@property(nonatomic,assign) BOOL        isArticleLike_;

@property(nonatomic,strong) NSString    *letterContent_;
@property(nonatomic,strong) NSString    *bday_;

@property(nonatomic,strong) NSString    *isSetAudio;
@property(nonatomic,strong) NSString    *isSetPhoto;
@property(nonatomic,assign) BOOL         haveInviteGroup;

@property(nonatomic,copy) NSString *star;

@property (nonatomic,assign) BOOL isHaveInvite;
@property (nonatomic,assign) BOOL isGroupMember;
//动态
@property(nonatomic,strong) NSString        * dynamicType_;
@property(nonatomic,strong) NSString        * dynamicDesc_;
@property(nonatomic,strong) NSDictionary    * dynamicInfo_;
@property(nonatomic,assign) Dynamic_Type      dynamictype_;
@property(nonatomic,copy) NSString *is_jjr;   //经纪人
@property(nonatomic,copy) NSString *is_ghs;   //发展导师
@property(nonatomic,copy) NSString *is_pxs;   //培训师
@property(nonatomic,copy) NSString *is_guWen; //顾问
@property(nonatomic, copy) NSString *myselfIsAgenter;//自己是否是职业经纪人
@property(nonatomic, copy) NSString *myselfIsAgented;//自己是否已经委托
@property(nonatomic,assign) NSInteger expertType;
@property(nonatomic,assign) NSInteger has_jobs;
@property(nonatomic,copy) NSString *jobPeopleBackImage;

@property(nonatomic,assign) BOOL already;

@property(nonatomic,copy) NSString *is_shiming;

//职导行家列表
@property(nonatomic,strong) NSString  *rel;
@property(nonatomic,strong) NSString  *answer_cnt;
@property(nonatomic,strong) NSString  *agreePerson_cnt;
@property(nonatomic,strong) NSMutableArray  *articleListArr;
@property(nonatomic,strong) NSMutableArray  *answerListArr;
@property(nonatomic,strong) Comment_DataModal *commentList;
@property(nonatomic,strong) Author_DataModal  *appraiser;

@property(nonatomic,assign) NSInteger yuetan_cnt;

@property(nonatomic,strong) NSMutableArray  *aspDiscussArr;
@property(nonatomic,strong) ELAspectantDiscuss_Modal *aspDiscuss;

@property(nonatomic,strong) NSMutableArray  *recommendZWArr;
@property(nonatomic,strong) ZWDetail_DataModal *recommendZW;

@property(nonatomic,strong) NSMutableAttributedString *nameAttString;
@property(nonatomic,strong) NSMutableAttributedString *workAttString;

@property(nonatomic,assign) NSInteger dashang_cnt;
@property(nonatomic,assign) NSInteger wtc_cnt;

-(instancetype)initWithDictionary:(NSDictionary *)dic;
-(instancetype)initWithParserLetterListDictionary:(NSDictionary *)subDic;
-(instancetype)initWithExpertDetailDictionary:(NSDictionary *)dic;
-(instancetype)initWithArticleDetailExpertNSDctionary:(NSDictionary *)expertDic;

@end
