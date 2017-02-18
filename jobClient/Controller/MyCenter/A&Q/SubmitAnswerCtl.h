//
//  SubmitAnswerCtl.h
//  Association
//
//  Created by 一览iOS on 14-4-7.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"
#import "ExRequetCon.h"
#import "Answer_DataModal.h"



@protocol SubmitAnswerCtlDelegate <NSObject>

-(void)submitOK;

@end

@interface SubmitAnswerCtl : BaseUIViewController<UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate>
{
    IBOutlet UILabel * quizzerLb_;
    IBOutlet UILabel * questionLb_;
    IBOutlet UILabel * tipsLb_;
    IBOutlet UITextView * contentTx_;
    IBOutlet UIScrollView * scrollView_;
    //IBOutlet UIButton   * submitBtn_;
    Answer_DataModal * indataModal_;
    UITapGestureRecognizer  *singleTapRecognizer_;  //单击的事件
    
}

@property(nonatomic,assign) id<SubmitAnswerCtlDelegate> delegate_;
@property(nonatomic,strong) UIView      *currentFocusView_;
@property(nonatomic,assign) int         type_;  // 0为用户回答，1为HR回答

@end
