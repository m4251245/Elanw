//
//  ELSameTradeSearchCtl.h
//  jobClient
//
//  Created by 一览iOS on 15/10/12.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "SameTradeListCtl.h"

@interface ELSameTradeSearchCtl : BaseListCtl

@property (nonatomic,copy) NSString *getExpertFlag;

@property(nonatomic,assign) BOOL fromMessageList;

@property(nonatomic,strong) SameTradeListCtl *sameTradeCtl;

@property(nonatomic,assign) NSInteger jobType;

@end
