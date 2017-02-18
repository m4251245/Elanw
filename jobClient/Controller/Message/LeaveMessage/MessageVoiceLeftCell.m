//
//  MessageVoiceLeftCell.m
//  jobClient
//
//  Created by 一览ios on 15/8/28.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "MessageVoiceLeftCell.h"
#import "ASINetworkQueue.h"
#import "VoiceRecorderBaseVC.h"
#import "ASIHTTPRequest.h"
#import "NSString+Size.h"
#import "UIImageView+WebCache.h"

@interface MessageVoiceLeftCell()<ASIHTTPRequestDelegate>
{
    ASINetworkQueue *queue;
    LeaveMessage_DataModel  *tempModel;
}
@end

@implementation MessageVoiceLeftCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImage *bgImage = [UIImage imageNamed:@"icon_dailog2.png"];
    _contentBgImg = [bgImage stretchableImageWithLeftCapWidth:bgImage.size.width*0.6 topCapHeight:bgImage.size.height*0.8];
    CALayer *layer = _dateLb.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 4.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setAttr
{
    //设置头像圆角
    CALayer *layer = _toUserImgv.layer;
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:4.0];
    self.backgroundColor = [UIColor clearColor];
    _contentBtn.titleLabel.font = TWEELVEFONT_COMMENT;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void) setLeaveMessage:(LeaveMessage_DataModel *)leaveMessage
{
    tempModel = leaveMessage;
    [_toUserImgv sd_setImageWithURL:[NSURL URLWithString:leaveMessage.personPic] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
    [_contentBtn setBackgroundImage:_contentBgImg forState:UIControlStateNormal];
    [_voiceTimeLb setText:[NSString stringWithFormat:@"%@ \"",leaveMessage.voiceTime]];

    CGRect contentBtnRect = _contentBtn.frame;
    CGRect voiceTimeRect = _voiceTimeLb.frame;
    CGRect voicePlayRect = _voicePlayBtn.frame;
    if (_isShowNameLb) {
        _nameLb.hidden = NO;
        _nameLb.text = leaveMessage.personIName;
    }
    else {
        _nameLb.hidden = YES;
        contentBtnRect.origin.y = 38;
        voiceTimeRect.origin.y = 38;
        voicePlayRect.origin.y = 38;
    }
    _voicePlayBtn.frame = voicePlayRect;
    
    contentBtnRect.size.width = 60+2*([leaveMessage.voiceTime intValue] % 50);
    _contentBtn.frame = contentBtnRect;
    
    voiceTimeRect.origin.x = _contentBtn.frame.origin.x + _contentBtn.frame.size.width +8;
    _voiceTimeLb.frame = voiceTimeRect;
    
    if (!leaveMessage.date) {
        _dateLb.hidden = YES;
    }else{
        _dateLb.hidden = NO;
        _dateLb.text = leaveMessage.date;
    }
    
    CGSize pSize = [leaveMessage.date sizeNewWithFont:[UIFont systemFontOfSize:9]];
    _dateLb.frame = CGRectMake((ScreenWidth - pSize.width)/2, 10, pSize.width+5, 11);
}

@end
