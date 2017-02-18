//
//  ELAnswerEditorCtl.h
//  jobClient
//
//  Created by 一览iOS on 16/9/14.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "BaseUIViewController.h"
@class AnswerListModal;
@class AnswerDetialModal;

@interface ELAnswerEditorCtl : BaseEditInfoCtl

@property (nonatomic,copy) NSString *questionId;
@property (nonatomic,strong) AnswerListModal *editorModel;//修改回答时用
@property (nonatomic,copy) NSString *questionTitle;
@property (nonatomic,copy) NSString *questionContent;

@end
