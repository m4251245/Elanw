//
//  AnswerDetailCtl.h
//  Association
//
//  Created by 一览iOS on 14-3-7.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "ExRequetCon.h"
#import "AnswerDetailCtl_Cell.h"
#import "TransparencyView.h"

@interface AnswerDetailCtl : BaseListCtl<UITextViewDelegate,TransparencyViewDelegate>
{    
    AnswerDetialModal    *answerDetialModal;
    
    RequestCon           *addSupportCon_;

    UITapGestureRecognizer  *singleTapRecognizer_;  //单击的事件
    int                     selfViewOriginY_;       //自己视图的原始y座标
    RequestCon              *submitCon_;            //用于提交回答
    RequestCon              *shareLogsCon_;
    
    RequestCon              *appraiseCon;
    TransparencyView        *transparency_;

}

@property (nonatomic, weak) IBOutlet UILabel     *questionLb_;
@property (nonatomic, weak) IBOutlet UIView      *headView_;
@property (nonatomic, weak) IBOutlet UIView      *anserTagView_;

@property (strong, nonatomic) IBOutlet UILabel  *questionTimeLb_;
@property (strong, nonatomic) IBOutlet UIButton *questionNameBtn_;

@property(nonatomic,assign) NSInteger backCtlIndex;
@property (nonatomic, assign) BOOL isAsk; //YES表示提问题，NO表示查看
@property (nonatomic, assign) BOOL isPop;
@end
