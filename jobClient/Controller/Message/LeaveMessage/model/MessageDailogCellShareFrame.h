//
//  MessageDailogCellShareFrame.h
//  jobClient
//
//  Created by 一览ios on 15/5/12.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//留言显示分享的内容 // 暂时不用

#import <Foundation/Foundation.h>
@class LeaveMessage_DataModel;


@interface MessageDailogCellShareFrame : NSObject

@property (nonatomic, strong)LeaveMessage_DataModel *leaveMessage;

@property (assign, nonatomic) CGRect timeFrame;

@property (assign, nonatomic) CGRect userImgFrame;

@property (assign, nonatomic) CGRect bgBtnFrame;

@property (assign, nonatomic) CGRect titleLbFrame;

@property (assign, nonatomic) CGRect thumbFrame;

@property (assign, nonatomic) CGRect contentFrame;

@property (assign, nonatomic) CGFloat height;


@end
