//
//  ServiceSelectCtl.h
//  jobClient
//
//  Created by 一览ios on 15/3/7.
//  Copyright (c) 2015年 YL1001. All rights reserved.
// 一览直推 服务选择

#import "BaseListCtl.h"
@class OrderService_DataModal;

@protocol ServiceSelectDelegate <NSObject>

@optional
- (void)refreshService:(OrderService_DataModal*)service;

@end
 
@interface RRServiceSelectCtl : BaseListCtl

@property (nonatomic, strong)NSMutableArray * serviceArr;

@property (nonatomic, assign) id<ServiceSelectDelegate> delegate;

@end
