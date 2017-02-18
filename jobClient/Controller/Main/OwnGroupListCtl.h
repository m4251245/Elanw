//
//  OwnGroupListCtl.h
//  jobClient
//
//  Created by 一览ios on 15/7/31.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "ELGroupListDetailModel.h"

typedef void (^MessageDetailBolck)(ELGroupListDetailModel *dataModal);

@interface OwnGroupListCtl : BaseListCtl

@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy) MessageDetailBolck block;
@property(nonatomic, assign) BOOL fromMessageDailog;
@property(nonatomic, assign) BOOL noShowMessageButton;
@property(nonatomic, assign)BOOL stateType;
@property(nonatomic,assign) BOOL hideSearchBar;

@end
