//
//  Answer_DataModal.h
//  Association
//
//  Created by 一览iOS on 14-3-6.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PageInfo.h"
#import "Expert_DataModal.h"

@interface Answer_DataModal : PageInfo

@property(nonatomic,strong) NSString * answerId_;
@property(nonatomic,strong) NSString * questionId_;
@property(nonatomic,strong) NSString * questionContent_;
@property(nonatomic,strong) NSString * quizzerId_;
@property(nonatomic,strong) NSString * quizzerName_;
@property(nonatomic,strong) NSString * content_;
@property(nonatomic,strong) NSString * supportCnt_;
@property(nonatomic,strong) NSString * unsupportCnt_;
@property(nonatomic,strong) NSString * commentCnt_;
@property(nonatomic,strong) NSString * collectCnt_;
@property(nonatomic,strong) NSString * reportCnt_;
@property(nonatomic,strong) NSString * lastUpdatetime;
@property(nonatomic,strong) NSString * questionTime_;
@property(nonatomic,strong) NSString * managerstatus_;
@property(nonatomic,strong) NSString * questionTitle_;
@property(nonatomic,strong) NSString * sysUpdatetime_;
@property(nonatomic,strong) NSString * quesReplyCnt_;
@property(nonatomic,strong) NSString * quesViewCnt_;
@property(nonatomic,strong) NSString * quesLastUpdate_;
@property(nonatomic,strong) NSString * quesFollowCnt_;
@property(nonatomic,assign) BOOL       isMine_;
@property(nonatomic,assign) BOOL       bImageLoad_;        //是否已经加载图片
@property(nonatomic,strong) NSData   * imageData_;        //图片data
@property(nonatomic,strong) NSString * img_;
@property(nonatomic,strong) NSString * expertName_;
@property(nonatomic,strong) NSString * expertJob_;
@property(nonatomic,strong) NSString * expertgznum_;
@property(nonatomic,strong) NSString * expertId_;
@property(nonatomic,strong) Expert_DataModal * expert_;       //回答专家的信息
@property(nonatomic,strong) Expert_DataModal * ask_expert_;   //被提问的专家的信息
@property(nonatomic,strong) NSString * anserTime_;            //回答时间
@property(nonatomic,strong) NSString * isSupport_;            //1赞 | 0 未赞
//@property(nonatomic,strong) NSArray  * tagInfoArray_;          //问题标签
@property(nonatomic,assign) NSInteger        allAnswerCnt_;

@property(nonatomic,strong) NSString *hotCount;            // 热度
@property(nonatomic,strong) NSString *isRecommend;         // 是否为悬赏问答，1是 0或空不是

@property (nonatomic,strong) NSArray *tagInfoArray;           //问题标签
@property (nonatomic,strong) NSString *question_replys_count;
@property (nonatomic,strong) NSString *question_view_count;
@property (nonatomic,strong) NSMutableArray *arrPl;

@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,assign) CGRect titleFrame;
@property (nonatomic,assign) CGRect contentFrame;
@property (nonatomic,strong) NSMutableAttributedString *titleAttString;
@property (nonatomic,strong) NSMutableAttributedString *contentAttString;

@end
