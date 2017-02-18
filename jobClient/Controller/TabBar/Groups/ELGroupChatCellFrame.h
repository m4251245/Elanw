//
//  ELGroupChatCellFrame.h
//  jobClient
//
//  Created by YL1001 on 16/12/26.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LeaveMessage_DataModel;
@class MLEmojiLabel;

static int TOP_INSERT = 10;
static int LEFT_INSERT = 15;
static int RIGHT_INSERT = 20;

@interface ELGroupChatCellFrame : NSObject

@property (nonatomic, strong)LeaveMessage_DataModel *leaveMessage;

@property (assign, nonatomic) CGRect timeLbFrame;

@property (assign, nonatomic) CGRect userImgvFrame;
@property (assign, nonatomic) CGRect nameLabelFrame;
@property (nonatomic, assign) CGRect emojiLabelFrame;
@property (nonatomic, assign) CGRect contentBtnFrame;
@property (nonatomic, assign) CGRect activityFrame;
@property (nonatomic, assign) CGRect retryBtnFrame;
@property (nonatomic, assign) CGPoint retryBtnCenter;

@property (nonatomic, assign)CGFloat height;

+ (MLEmojiLabel *)emojiLabel:(NSString *)text attributedText:(NSMutableAttributedString *)attributeStr;


@end
