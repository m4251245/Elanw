//
//  TodayFocusFrame_DataModal.h
//  jobClient
//
//  Created by 一览ios on 15/4/7.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ELGroupListTwoModel.h"
#import "ELGroupArticleDetailModel.h"
#import "Article_DataModal.h"
#import "ELSameTrameArticleModel.h"
#import "MLLinkLabel.h"
#import "NSString+MLExpression.h"
#define kEmojiTagId 9999

@class MLEmojiLabel;

@interface TodayFocusFrame_DataModal : PageInfo

@property (strong, nonatomic) Article_DataModal *model;

@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) CGRect sametradeHeadViewFrame;
@property (assign, nonatomic) CGRect titleFrame;//主标题
@property (assign, nonatomic) CGRect articleTitleFrame;//文章标题
@property (assign, nonatomic) CGRect contentLbFrame;
@property (assign, nonatomic) CGRect showImgvFrame;
@property (assign, nonatomic) CGRect toolBarFrame;
@property (assign, nonatomic) CGRect commentViewFrame;
@property (assign, nonatomic) CGRect nameLbFrame;
@property (assign, nonatomic) CGRect jobLbFrame;
@property (assign,nonatomic) CGRect likeViewFrame;
@property (assign,nonatomic) CGRect fromViewFrame;
@property (assign,nonatomic) CGRect allCommentFrame;
@property (assign,nonatomic) CGRect shareLableFrame;
@property (nonatomic,assign) BOOL showAttachmentImage;

@property (nonatomic,strong) ELGroupListTwoModel *joinGroupPeopleModel; //用于社群列表最近来了那些人卡片
@property (nonatomic,strong) ELGroupArticleDetailModel *groupRecommentModel;//用于社群详情置顶文章
@property (nonatomic,strong) ELSameTrameArticleModel *sameTradeArticleModel;//用于同行文章卡片

@property(nonatomic,strong) NSMutableAttributedString *titleAttString;
@property(nonatomic,strong) NSMutableAttributedString *contentAttString;
@property(nonatomic,assign) BOOL isLike_;
@property(nonatomic,assign) BOOL isActivityArtcle;//用于同行判断活动贴
@property(nonatomic,assign) BOOL isRecommentAnswer;//用于同行推荐问答卡片
@property(nonatomic,assign) ArticleType articleType_;//用于同行文章类型

@end
