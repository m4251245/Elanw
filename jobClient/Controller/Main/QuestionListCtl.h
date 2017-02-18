//
//  QuestionListCtl.h
//  jobClient
//
//  Created by YL1001 on 14/10/30.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "ExRequetCon.h"
//#import "AQDetailListCtl.h"

@interface QuestionListCtl : BaseListCtl

@property (nonatomic,copy) NSString *userId;
@property(nonatomic,assign) BOOL formPersonCenter;

@end
