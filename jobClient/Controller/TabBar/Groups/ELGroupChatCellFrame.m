//
//  ELGroupChatCellFrame.m
//  jobClient
//
//  Created by YL1001 on 16/12/26.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELGroupChatCellFrame.h"
#import "LeaveMessage_DataModel.h"
#import "MLEmojiLabel.h"
#import "NSString+Size.h"
#import "MyConfig.h"

@implementation ELGroupChatCellFrame

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
    
    /*包含有html的<a>标签  */
//    NSString *text = leaveMessage.content;
//    NSMutableAttributedString *attributedString;
//    if ([text containsString:@"<a"]) {
//        attributedString = [[NSMutableAttributedString alloc] initWithData:[text dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//        attributedString = [[Manager shareMgr] getEmojiStringWithAttString:attributedString withImageSize:CGSizeMake(18, 18)];
//        if (leaveMessage.tagName.length > 0) {
//            [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x0200FF) range:NSMakeRange(attributedString.length-leaveMessage.tagName.length-2, leaveMessage.tagName.length+2)];
//        }
//    }
//    else {
//        attributedString = [[Manager shareMgr] getEmojiStringWithString:text withImageSize:CGSizeMake(18, 18)];
//    }
    
    UILabel *contentLb = [[UILabel alloc] init];
    contentLb.numberOfLines = 0;
    contentLb.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
    contentLb.backgroundColor = [UIColor clearColor];
    contentLb.lineBreakMode = NSLineBreakByCharWrapping;
    CGFloat width = (240 -LEFT_INSERT - RIGHT_INSERT);
    contentLb.frame = CGRectMake(0, 0, width, 0);

    contentLb.attributedText = leaveMessage.attString;
    [contentLb sizeToFit];
    
    CGRect faceFrame = contentLb.frame;
    if ([leaveMessage.isSend isEqualToString:@"1"]) {//自己的消息
        _userImgvFrame = CGRectMake(ScreenWidth-48, userImgvY, 40, 40);
        self.emojiLabelFrame = CGRectMake(LEFT_INSERT, TOP_INSERT-3, faceFrame.size.width, faceFrame.size.height+4);
    }else{//他人发送的消息
        _userImgvFrame = CGRectMake(8, userImgvY, 40, 40);
        self.emojiLabelFrame = CGRectMake(RIGHT_INSERT, TOP_INSERT-3, faceFrame.size.width, faceFrame.size.height+4);
    }
    
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
    
    if (leaveMessage.personIName.length > 0) {
        UILabel *nameLb = [[UILabel alloc] init];
        nameLb.font = [UIFont systemFontOfSize:12.0f];
        nameLb.text = leaveMessage.personIName;
        nameLb.frame = CGRectMake(0, 0, 20, 18);
        [nameLb sizeToFit];
    
        if (![leaveMessage.isSend isEqualToString:@"1"]) {
            self.nameLabelFrame = CGRectMake(contentX, userImgvY, nameLb.frame.size.width, nameLb.frame.size.height);
        }
        
        self.contentBtnFrame = CGRectMake(contentX-5, CGRectGetMaxY(self.nameLabelFrame) + 4, contentWidth, contenHeight);
    }
    else {
        self.contentBtnFrame = CGRectMake(contentX+5, userImgvY, contentWidth, contenHeight);
    }
   
    if ([leaveMessage.isSend isEqualToString:@"1"]) {
        self.activityFrame = CGRectMake(contentX-28, contenHeight/2+userImgvY-10, 20, 20);
    }
    
    
    //totalHeight += emojiLabel.frame.size.height + TOP_INSERT + BOTTOM_INSERT;// + btn inset
    CGFloat bottomPadding = 10;
    _height = CGRectGetMaxY(_contentBtnFrame) +bottomPadding;
}

#pragma mark 初始化表情label
+ (MLEmojiLabel *)emojiLabel:(NSString *)text attributedText:(NSMutableAttributedString *)attributeStr
{
    MLEmojiLabel * emojiLabel;
    if (!emojiLabel) {
        emojiLabel = [[MLEmojiLabel alloc]init];
        emojiLabel.tag =  221;
        emojiLabel.numberOfLines = 0;
        emojiLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
        emojiLabel.backgroundColor = [UIColor clearColor];
        emojiLabel.lineBreakMode = NSLineBreakByCharWrapping;
        emojiLabel.isNeedAtAndPoundSign = YES;
        emojiLabel.customEmojiRegex = Custom_Emoji_Regex;
        emojiLabel.customEmojiPlistName = @"emoticons.plist";
        [emojiLabel setEmojiAttributedText:attributeStr emojiText:text];
    }
    return emojiLabel;
}

@end
