//
//  FBCondictionCtl.h
//  jobClient
//
//  Created by 一览ios on 15/10/17.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "ZWModel.h"

typedef void(^seletedblock)();

@interface FBCondictionCtl : BaseListCtl

@property (strong,nonatomic)   ZWModel *inzwmodel;    /**< */

@property (strong,nonatomic)   NSString *type;    /**<默认工作经验  1表示学历  2 薪酬*/

@property (nonatomic,copy) seletedblock block;


+(NSString *)getEduNameWith:(NSString *)eduId;
+(NSString *)getWorkAgeNameWithStart:(NSString *)workStart end:(NSString *)workEnd;

@end
