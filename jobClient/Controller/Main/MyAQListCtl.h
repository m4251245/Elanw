//
//  MyAQListCtl.h
//  jobClient
//
//  Created by YL1001 on 14/10/30.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseUIViewController.h"

#import "QuestionListCtl.h"
#import "AnswerList_Ctl.h"
@class ELAnswerCenterCtl;

typedef enum
{
    AQleft,
    AQright
}AQLeftRight;

@interface MyAQListCtl : BaseUIViewController<UIScrollViewDelegate>
{
    UIView           *segmentedView_;
    UIButton         *leftBtn_;/**< 提问 */
    UIButton         *rightBtn_;/**< 回答 */
    UIScrollView     *scrollView_;
    int                         modelIndex_;
    
    QuestionListCtl             *questionListCtl_;   //问过
    ELAnswerCenterCtl              *answerListCtl_;     //答过
    
}

@property(nonatomic,assign) int type_;              //1为问答，2为新通知
@property(nonatomic,assign) AQLeftRight  leftRight;
@property(nonatomic,assign) BOOL isPop;
@property(nonatomic,assign) BOOL formPersonCenter;
@property(nonatomic,assign) BOOL showWaitAnswerList;

-(void) changeModel:(int)index;

@end
