//
//  MessageDailogCellFrame.h
//  jobClient
//
//  Created by 一览ios on 15/3/4.
//  Copyright (c) 2015年 YL1001. All rights reserved.
// 留言的frame

#import <Foundation/Foundation.h>
@class LeaveMessage_DataModel;
@class MLEmojiLabel;

//#define kEmojiTagId 221
//#define LINE_WIDTH 240
//#define LEFT_INSERT 15
//#define RIGHT_INSERT 20
//
//#define TOP_INSERT 10 //留言内容与显示框的上边界
//#define BOTTOM_INSERT 7 //留言内容与显示框的下边界
//#define TOP_VIEW_MARGIN 5
//#define kMarginTop 10 //单元格上边界
static int TOP_INSERT = 10;
static int LEFT_INSERT = 15;
static int RIGHT_INSERT = 20;


@interface MessageDailogCellFrame : NSObject

@property (nonatomic, strong)LeaveMessage_DataModel *leaveMessage;

@property (assign, nonatomic) CGRect timeLbFrame;

@property (assign, nonatomic) CGRect userImgvFrame;

@property (nonatomic, assign)CGRect emojiLabelFrame;

@property (nonatomic, assign)CGRect contentBtnFrame;

@property (nonatomic, assign)CGFloat height;

+ (MLEmojiLabel *)emojiLabel:(NSString *)text;

@end
