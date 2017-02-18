//
//  MessageListCell.h
//  jobClient
//
//  Created by 一览ios on 15/4/23.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WhoLikeMeDataModal.h"
#import "MLEmojiLabel.h"
@class MessageCenterDataModel;

@interface MessageListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UILabel *countLb;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *countLbWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *countLbLeading;
@property (weak, nonatomic) IBOutlet UIImageView *markBgImgView;

@property (nonatomic,strong) MLEmojiLabel *emojiContent;


-(void)giveDataModal:(WhoLikeMeDataModal *)modal;

- (void)setMessageType:(MessageCenterDataModel *)model;//消息-通知模块使用
@end
