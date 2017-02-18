//
//  FBWebsiteListCtl.h
//  jobClient
//
//  Created by 一览ios on 15/10/17.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "ZWModel.h"

typedef void(^seletedblock)();

@interface FBWebsiteListCtl : BaseListCtl

@property (strong,nonatomic)   ZWModel *inzwmodel;    /**< */

@property (strong,nonatomic)   NSString     *type;    /**<1表示部门选择 2工作年限*/

@property (nonatomic,copy) seletedblock block;

@end
