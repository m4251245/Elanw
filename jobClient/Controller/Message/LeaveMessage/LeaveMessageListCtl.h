//
//  LeaveMessageListCtl.h
//  jobClient
//
//  Created by 一览ios on 14/12/8.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "LeaveMessageListCtl.h"
@class MessageContact_DataModel;
@class MessageDelTipsCtl;
@class LeaveMessageList_Cell;

typedef void(^block)();

@interface LeaveMessageListCtl : BaseListCtl

@property(nonatomic, copy) block    _redCountBlock;

@property (strong, nonatomic) UIViewController *tipsCtl;

@property (weak, nonatomic) LeaveMessageList_Cell *selectCell;

@property (weak, nonatomic) UIView *maskView;


@end
