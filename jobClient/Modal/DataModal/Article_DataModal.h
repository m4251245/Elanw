//
//  Article_DataModal.h
//  Association
//
//  Created by 一览iOS on 14-1-15.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "News_DataModal.h"
#import "Expert_DataModal.h"
#import "CellFrameModel.h"
#import "YLVoteDataModal.h"
#import "ELActivityModel.h"
@class TodayFocusFrame_DataModal;

//#import "Groups_DataModal.h"

typedef enum
{
    Article_Topic,  
    Article_File,
    Article_ViewPoint,
    Article_Follower,
    Article_Group,  //社群
    Article_Share,  //分享
    Article_GXS, //灌薪水
    Article_Trade_Head, //行业头条
    Article_Question //问答
}ArticleType;


@interface Article_DataModal : News_DataModal

@property(nonatomic,strong) NSString * personID_;
@property(nonatomic,strong) NSString * personName_;
@property(nonatomic,strong) NSString * personNickname_;
@property(nonatomic,strong) NSString * personImg_;
@property(nonatomic,strong) NSString * commentContent_;
@property(nonatomic,strong) NSString * commentpersonName_;
@property(nonatomic,assign) BOOL       isNew;
@property(nonatomic,assign) ArticleType  articleType_;
@property(nonatomic,strong) NSString * isarticle_;       //精品观点中区分是文章还是评论
@property(nonatomic,strong) NSString * commentPersonImg1_;
@property(nonatomic,strong) NSString * commentPersonImg2_;
@property(nonatomic,strong) NSString * commentPersonImg3_;
@property(nonatomic,strong) NSMutableArray  *  commentArr_;
@property(nonatomic,strong) NSMutableArray  *  zwArr_;
@property(nonatomic,strong) NSMutableArray  *  otherArticleArr_;
@property(nonatomic,strong) NSMutableArray  *  imageArray_;         //动态列表显示文章图片
@property(nonatomic,strong) NSString            *articleOwnName_;   //原文作者名字
@property(nonatomic,strong) NSString            *isXinwen_;   //原文作者名字
@property(nonatomic,assign) BOOL                isTJExpertArticle_;
@property(nonatomic,assign) BOOL                isTop_;
@property(nonatomic,assign) BOOL                isLike_;
@property(nonatomic,assign) BOOL                isFavorite;
@property(nonatomic,strong) Expert_DataModal * expert_;
@property(nonatomic,strong) CellFrameModel *frameModel;
@property(nonatomic,strong) id cellFrame;
@property(nonatomic,strong) NSString * groupId_;
@property(nonatomic,strong) NSString * grouppersonId_;
@property(nonatomic,strong) NSString * grouppersonIname_;
@property(nonatomic,strong) NSString * groupName_;
@property(nonatomic,strong) NSString * groupPic_;
@property(nonatomic,strong) NSString * groupSource;

@property(nonatomic,strong) NSString * code;      //权限
@property(nonatomic,strong) NSString * group_open_status;   //开放状态

@property(nonatomic,strong) NSString * majiaName;
@property(nonatomic,strong) NSString * majiaPic;
@property(nonatomic,strong) NSString *majiaId;

@property(nonatomic,strong) NSString *articleStatus;
@property (nonatomic,strong) NSMutableArray *arrMedia;

@property (nonatomic, strong) NSString *groups_communicate_mode;//群类型  10 普通群

//file才有的字段
@property(nonatomic,strong) NSString * fileId_;
@property(nonatomic,strong) NSString * fileUrl_;
@property(nonatomic,strong) NSString * fileName_;
@property(nonatomic,strong) NSString * fileExe_;
@property(nonatomic,strong) NSString * fileSize_;
@property(nonatomic,assign) NSInteger        filePages_;
@property(nonatomic,assign) NSInteger        fileDownloadCnt_;
@property(nonatomic,strong) NSString * fileGrade_;
@property(nonatomic,strong) NSString * filePath_;
@property(nonatomic,strong) NSString * fileHtmlPath_;
@property(nonatomic,assign) NSInteger        fileViewCnt_;
@property(nonatomic,strong) NSString * fileImg_;
@property(nonatomic,strong) NSString * fileWH_;
@property(nonatomic,copy) NSString *file_swf;

//灌薪水才有字段
@property(nonatomic,strong) NSString * zhiyeId_;
@property(nonatomic,strong) NSString * zhiyeName_;
@property(nonatomic,strong) NSString * nickName_;
@property(nonatomic,assign) BOOL       isRecommendGXS_;
@property(nonatomic,strong) UIColor  * bgColor_;
@property(nonatomic,strong) NSString * sourceContent_;
@property(nonatomic,strong) NSString * isJing_;
@property(nonatomic,assign) BOOL       isSalaryDetail;

//文章收藏才有的字段
@property(nonatomic, copy) NSString *typeCode;//@"xinwen"
@property(nonatomic, copy) NSString *typeName;//@"薪闻"
@property(nonatomic,copy) NSString *collectType;
@property(nonatomic,copy) NSString *collectId;
@property(nonatomic,copy) NSString *collectFileSwf;
@property(nonatomic,copy) NSString *collectFilePage;
@property(nonatomic,copy) NSString *collectSrc;

//互动字段
@property(nonatomic,copy) NSString *isVote;
@property(nonatomic,copy) NSString *canVote;
@property(nonatomic,copy) NSString *status;
@property(nonatomic,copy) NSString *allVote;
@property(nonatomic,strong) NSMutableArray *resultDataArr;
@property(nonatomic,strong) NSIndexPath *indexPath;

@property(nonatomic,strong) ELActivityModel *_activity_info;
@property(nonatomic,strong) NSDictionary *dicJoinName;
@property(nonatomic,assign) BOOL isRealName;
@property(nonatomic,assign) BOOL isRefresh;

@property(nonatomic,assign) BOOL already;

@property(nonatomic,copy) NSString *activityTitle;
@property(nonatomic,copy) NSString *startTime;
@property(nonatomic,copy) NSString *endTime;
@property(nonatomic,copy) NSString *activityAddress;
@property(nonatomic,copy) NSString *activityRegionId;
@property(nonatomic,copy) NSString *lastJoinTime;
@property(nonatomic,assign) NSInteger joinPeopleCount; 
@property(nonatomic,assign) BOOL isActivityArtcle;

@property(nonatomic,strong) NSMutableArray *likeImageArr;
@property(nonatomic,strong) NSMutableArray *commentAttStringArr;

@property(nonatomic,strong) NSMutableAttributedString *titleAttString;
@property(nonatomic,strong) NSMutableAttributedString *contentAttString;
@property(nonatomic,strong) NSMutableAttributedString *groupAttString;

@property(nonatomic,strong) TodayFocusFrame_DataModal *groupFrameModal;
@property(nonatomic,assign) BOOL isHaveData;
//问答字段
@property(nonatomic,copy) NSString *hotCount;  // 热度
@property(nonatomic,copy) NSString *isRewardQuesion;  // 1悬赏问答，0或空不是
@property(nonatomic,assign) CGFloat cellHeight;
@property(nonatomic,assign) CGRect titleFrame;

-(instancetype)initWithGroupArticleListDictionary:(NSDictionary *)dic;
-(instancetype)initWithArticleDetailDictionary:(NSDictionary *)dic;

@end

