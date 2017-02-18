//
//  MessageVoiceLeftCell.h
//  jobClient
//
//  Created by 一览ios on 15/8/28.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeaveMessage_DataModel.h"
#import "MyConfig.h"
#import "LeaveMessage_DataModel.h"
#import <AVFoundation/AVFoundation.h>
//#define LINE_WIDTH 240
//#define TOP_INSERT 10
//#define BOTTOM_INSERT 7

@interface MessageVoiceLeftCell : UITableViewCell<AVAudioPlayerDelegate>
{
@public
    UIImage *_contentBgImg;
    BOOL                        isplay_;   //是否正在播放
    AVAudioPlayer               *player;
    NSInteger                   index_;
}
@property (weak, nonatomic) IBOutlet UIImageView *toUserImgv;
@property (weak, nonatomic) IBOutlet UIButton *contentBtn;
@property (weak, nonatomic) IBOutlet UIButton *voicePlayBtn;
@property (weak, nonatomic) IBOutlet UILabel *voiceTimeLb;
@property (weak, nonatomic) IBOutlet UILabel *dateLb;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (assign, nonatomic) BOOL isShowNameLb;

- (void)setAttr;

- (void) setLeaveMessage:(LeaveMessage_DataModel *)leaveMessage;


@end
