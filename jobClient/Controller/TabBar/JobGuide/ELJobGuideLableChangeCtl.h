//
//  ELJobGuideLableChangeCtl.h
//  jobClient
//
//  Created by 一览iOS on 16/9/9.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "BaseUIViewController.h"
@class AnswerDetialModal;

@interface ELJobGuideLableChangeCtl : BaseUIViewController

@property (nonatomic,assign) BOOL fromTodayList;
@property(nonatomic,assign) NSInteger backCtlIndex;
@property(nonatomic,strong) AnswerDetialModal *editorModel;

@end
