//
//  InterviewAnswerCtl.h
//  jobClient
//
//  Created by 一览iOS on 14-11-5.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"
#import "ExRequetCon.h"
#import "InterviewDataModel.h"

@protocol InterviewAnswerCtlDelegate <NSObject>
@optional
-(void)answerSuccess;

@end

typedef void(^interAnserBlock) ();

@interface InterviewAnswerCtl : BaseEditInfoCtl
{
    IBOutlet        UILabel         *questLb_;
    IBOutlet        UITextView      *answerTextv_;
    RequestCon      *answerCon_;
    InterviewDataModel  *inModel_;
}

@property(nonatomic,assign) id<InterviewAnswerCtlDelegate>  delegate;

@property(nonatomic,copy) interAnserBlock block;

@end
