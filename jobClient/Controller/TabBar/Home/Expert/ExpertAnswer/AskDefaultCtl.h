//
//  AskDefaultCtl.h
//  Association
//
//  Created by 一览iOS on 14-6-4.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "BaseEditInfoCtl.h"
@class AnswerDetialModal;

@interface AskDefaultCtl :BaseEditInfoCtl
{

}

@property(nonatomic,assign) BOOL fromTodayList;
@property(nonatomic,assign) NSInteger backCtlIndex;
@property(nonatomic,strong) AnswerDetialModal *editorModel;

@end
