//
//  MessageCenterDataModel.h
//  jobClient
//
//  Created by 一览ios on 15/4/27.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PageInfo.h"
@interface MessageCenterDataModel :PageInfo

@property(nonatomic, strong) NSString   *type;
@property(nonatomic, strong) NSString   *count;
@property(nonatomic, strong) NSString   *title;
@property(nonatomic, strong) NSString   *content;

@property(nonatomic, assign) int            messageCnt;
@property(nonatomic, assign) int            leaveCnt;

@end
