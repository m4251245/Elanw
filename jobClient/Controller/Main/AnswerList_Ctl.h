//
//  AnswerList_Ctl.h
//  jobClient
//
//  Created by YL1001 on 14/10/30.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"

@interface AnswerList_Ctl : BaseListCtl

@property(nonatomic, copy) NSString *userId;
@property(nonatomic,assign) BOOL isMyCenter;
@property(nonatomic,assign) BOOL isWaitList;
@property(nonatomic,assign) BOOL formMyAnswer;

@end
