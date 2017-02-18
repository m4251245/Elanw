//
//  MessageDailogCellShareFrame.m
//  jobClient
//
//  Created by 一览ios on 15/5/12.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "MessageDailogCellShareFrame.h"
#import "LeaveMessage_DataModel.h"
#import "MyConfig.h"
#import "NSString+Size.h"

//#define UserImgWidth 30
//#define UserImgHeight 30
//#define UserImgMaginSide 10//用户头像左边或者右边的距离
//#define kBgPaddingSideMin 6//背景内间距
//#define kBgPaddingSideMax 20
//#define kBgPaddingUpSide 6
//#define  kBgMarginLeftOrRight 3
//#define kBgWidth 260
//#define kTitleWidth 200
//#define kContentWidth 150
static int UserImgWidth = 30;
static int UserImgHeight = 30;
static int UserImgMaginSide = 10;
static int kBgPaddingSideMin = 6;
static int kBgPaddingSideMax = 20;
static int kBgPaddingUpSide = 6;
static int kBgMarginLeftOrRight = 3;
static int kBgWidth = 260;
static int kTitleWidth = 200;
static int kContentWidth = 150;

@implementation MessageDailogCellShareFrame

- (void)setLeaveMessage:(LeaveMessage_DataModel *)leaveMessage
{
    _leaveMessage = leaveMessage;
    MessageDailogType messageType = leaveMessage.messageType;
    if (messageType != MessageTypeShareUser) {
        return;
    }
    
    NSString *time = leaveMessage.date;
    CGSize size = [time sizeNewWithFont:NINEFONT_TIME];
    CGFloat timeX = (320 - size.width)/2;
    _timeFrame  = CGRectMake(timeX, 0, size.width +8, size.height+4);
//    _timeFrame = CGRectMake(110, 0, 100, 20);
    CGFloat userImgvMarginTop = 10;
    CGFloat userImgvY = CGRectGetMaxY(_timeFrame) + userImgvMarginTop;
    if (leaveMessage.isSend) {//自己
        _userImgFrame = CGRectMake(320-UserImgMaginSide-UserImgWidth-kBgMarginLeftOrRight, userImgvY, UserImgWidth, UserImgHeight);
        NSString *title = leaveMessage.title;
        CGSize size = [title sizeNewWithFont:FOURTEENFONT_CONTENT constrainedToSize:CGSizeMake(kTitleWidth, 40) lineBreakMode:NSLineBreakByTruncatingTail];
        
        CGFloat titleX = CGRectGetMinX(_userImgFrame) - kBgMarginLeftOrRight - kBgWidth + kBgPaddingSideMin;
        _titleLbFrame = CGRectMake(titleX, userImgvY + kBgPaddingUpSide, kTitleWidth, size.height);
        CGFloat thumbY = CGRectGetMaxY(_titleLbFrame) + 5;
        _thumbFrame = CGRectMake(titleX, thumbY, 40, 40);
        CGFloat contentX = CGRectGetMaxX(_thumbFrame) +3;
        NSString *content = leaveMessage.content;
        size = [content sizeNewWithFont:TWEELVEFONT_COMMENT constrainedToSize:CGSizeMake(kContentWidth, 75) lineBreakMode:NSLineBreakByTruncatingTail];
        CGFloat contentHeight = size.height;
        _contentFrame = CGRectMake(contentX, thumbY, kContentWidth, contentHeight);
        CGFloat bgX = CGRectGetMinX(_userImgFrame)+ kBgMarginLeftOrRight-kBgWidth;
        CGFloat bgHeight = CGRectGetMaxY(_contentFrame) + 6;
        _bgBtnFrame = CGRectMake(bgX, userImgvY, kBgWidth, bgHeight);
    }else{//对方
        _userImgFrame = CGRectMake(UserImgMaginSide, userImgvY, UserImgWidth, UserImgHeight);
        NSString *title = leaveMessage.title;
        CGSize size = [title sizeNewWithFont:FOURTEENFONT_CONTENT constrainedToSize:CGSizeMake(kTitleWidth, 40) lineBreakMode:NSLineBreakByTruncatingTail];
        CGFloat titleX = CGRectGetMaxX(_userImgFrame) + kBgMarginLeftOrRight +kBgPaddingSideMax;
        _titleLbFrame = CGRectMake(titleX, userImgvY + kBgPaddingUpSide, kTitleWidth, size.height);
        CGFloat thumbY = CGRectGetMaxY(_titleLbFrame) + 5;
        _thumbFrame = CGRectMake(titleX, thumbY, 40, 40);
        CGFloat contentX = CGRectGetMaxX(_thumbFrame) +3;
        NSString *content = leaveMessage.content;
        size = [content sizeNewWithFont:TWEELVEFONT_COMMENT constrainedToSize:CGSizeMake(kContentWidth, 75) lineBreakMode:NSLineBreakByTruncatingTail];
        CGFloat contentHeight = size.height;
        _contentFrame = CGRectMake(contentX, thumbY, kContentWidth, contentHeight);
        CGFloat bgX = CGRectGetMaxX(_userImgFrame)+ kBgMarginLeftOrRight;
        CGFloat bgHeight = CGRectGetMaxY(_contentFrame) + 6;
        _bgBtnFrame = CGRectMake(bgX, userImgvY, kBgWidth, bgHeight);
    }
    _height = CGRectGetMaxY(_bgBtnFrame) +6;
}

@end
