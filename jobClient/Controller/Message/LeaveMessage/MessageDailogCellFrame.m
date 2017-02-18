//
//  MessageDailogCellFrame.m
//  jobClient
//
//  Created by 一览ios on 15/3/4.
//  Copyright (c) 2015年 YL1001. All rights reserved.
// 暂时不用

#import "MessageDailogCellFrame.h"
#import "LeaveMessage_DataModel.h"
#import "MLEmojiLabel.h"
#import "NSString+Size.h"
#import "MyConfig.h"

@implementation MessageDailogCellFrame

- (void)setLeaveMessage:(LeaveMessage_DataModel *)leaveMessage
{
    _leaveMessage = leaveMessage;
    
    if ([leaveMessage.code isEqualToString:@"401"] ||[leaveMessage.code isEqualToString:@"403"]) {
        _height =  40;
        return;
    }
    
    NSString *time = leaveMessage.date;
    CGSize size = [time sizeNewWithFont:NINEFONT_TIME];
    CGFloat timeX = (ScreenWidth - size.width)/2;
    _timeLbFrame  = CGRectMake(timeX, 10, size.width +8,11);
    
    CGFloat userImgvY = CGRectGetMaxY(_timeLbFrame) +6;
    
    NSString *text = leaveMessage.content;
    MLEmojiLabel *emojiLabel = [MessageDailogCellFrame emojiLabel:text];
    CGFloat width = (240 -LEFT_INSERT - RIGHT_INSERT);
    emojiLabel.frame = CGRectMake(0, 0, width, 0);
    [emojiLabel sizeToFit];
    CGRect faceFrame = emojiLabel.frame;
    if ([leaveMessage.isSend isEqualToString:@"1"]) {//自己的消息
        _userImgvFrame = CGRectMake(ScreenWidth-48, userImgvY, 40, 40);
        self.emojiLabelFrame = CGRectMake(LEFT_INSERT, TOP_INSERT-3, faceFrame.size.width, faceFrame.size.height+4);
    }else{//他人发送的消息
        _userImgvFrame = CGRectMake(8, userImgvY, 40, 40);
        self.emojiLabelFrame = CGRectMake(RIGHT_INSERT, TOP_INSERT-3, faceFrame.size.width, faceFrame.size.height+4);
    }

    //
    size = faceFrame.size;
    CGFloat maxContentX = ScreenWidth-60;
    CGFloat contentWidth = size.width+LEFT_INSERT+RIGHT_INSERT;
    CGFloat contentX;
    CGFloat contenHeight = size.height + TOP_INSERT + 7;
    if ([leaveMessage.isSend isEqualToString:@"1"]) {//自己的消息
        contentX = maxContentX - contentWidth;
    }else{//他人发送的消息
        contentX = 60;
    }
    if (leaveMessage.messageType == MessageTypeWeiTuo && ![leaveMessage.isSend isEqualToString:@"1"]) {
        contenHeight += 25;
    }
    self.contentBtnFrame = CGRectMake(contentX, userImgvY, contentWidth, contenHeight);
   
//    totalHeight += emojiLabel.frame.size.height + TOP_INSERT + BOTTOM_INSERT;// + btn inset
    CGFloat bottomPadding = 10;
    _height = CGRectGetMaxY(_contentBtnFrame) +bottomPadding;
}

#pragma mark 初始化表情label
+ (MLEmojiLabel *)emojiLabel:(NSString *)text
{
    MLEmojiLabel * emojiLabel;
    if (!emojiLabel) {
        emojiLabel = [[MLEmojiLabel alloc]init];
        emojiLabel.tag = 221;
        emojiLabel.numberOfLines = 0;
        emojiLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
        emojiLabel.backgroundColor = [UIColor clearColor];
        emojiLabel.lineBreakMode = NSLineBreakByCharWrapping;
        emojiLabel.isNeedAtAndPoundSign = YES;
        emojiLabel.customEmojiRegex = Custom_Emoji_Regex;
        emojiLabel.customEmojiPlistName = @"emoticons.plist";
        [emojiLabel setEmojiText:text];
    }
    return emojiLabel;
}
@end
