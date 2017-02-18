//
//  MessageVoiceRightCell.m
//  jobClient
//
//  Created by 一览ios on 15/8/28.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "MessageVoiceRightCell.h"
#import "ASINetworkQueue.h"
#import "VoiceRecorderBaseVC.h"
#import "ASIHTTPRequest.h"
#import "NSString+Size.h"
#import "UIImageView+WebCache.h"

@interface MessageVoiceRightCell()<ASIHTTPRequestDelegate>
{
    ASINetworkQueue *queue;
    LeaveMessage_DataModel  *tempModel;
}
@end


@implementation MessageVoiceRightCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImage *bgImage = [UIImage imageNamed:@"icon_dailog1.png"];
    _contentBgImg = [bgImage stretchableImageWithLeftCapWidth:bgImage.size.width*0.4 topCapHeight:bgImage.size.height*0.8];
    CALayer *layer = _dateLb.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 4.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void)setAttr
{
    //设置头像圆角
    CALayer *layer = _fromUserImgv.layer;
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:4.0];
    self.backgroundColor = [UIColor clearColor];
    _contentBtn.titleLabel.font = TWEELVEFONT_COMMENT;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setLeaveMessage:(LeaveMessage_DataModel *)leaveMessage
{
    tempModel = leaveMessage;
    [_fromUserImgv sd_setImageWithURL:[NSURL URLWithString:leaveMessage.personPic] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
    [_contentBtn setBackgroundImage:_contentBgImg forState:UIControlStateNormal];
    [_voiceTimeLb setText:[NSString stringWithFormat:@"%@ \"",leaveMessage.voiceTime]];
    [_voiceTimeLb sizeToFit];
    
    double contentWidth = 60 + 2 * ([leaveMessage.voiceTime intValue] % 50);
    contentWidth = (contentWidth > 170) ? 170 : contentWidth;
    
    
    CGRect voicePlayRect = _voicePlayBtn.frame;
    voicePlayRect.origin.y = 38;
    _voicePlayBtn.frame = voicePlayRect;

    CGRect contentBtnRect = _contentBtn.frame;
    contentBtnRect.size.width = contentWidth;
    contentBtnRect.origin.y = 38;
    contentBtnRect.origin.x = self.width-58-contentWidth;
    _contentBtn.frame = contentBtnRect;
    
    CGRect voiceTimeRect = _voiceTimeLb.frame;
    voiceTimeRect.origin.y = 46;
    voiceTimeRect.origin.x = self.width - 63 - contentWidth - voiceTimeRect.size.width;
    _voiceTimeLb.frame = voiceTimeRect;
    
    CGRect retryRect = _retryBtn.frame;
    retryRect.origin.x = CGRectGetMinX(_voiceTimeLb.frame) - 30;
    _retryBtn.frame = retryRect;
    
    if (!leaveMessage.date) {
        _dateLb.hidden = YES;
    }else{
        _dateLb.hidden = NO;
        _dateLb.text = leaveMessage.date;
    }
    
    
    CGSize pSize = [leaveMessage.date sizeNewWithFont:[UIFont systemFontOfSize:9]];
    _dateLb.frame = CGRectMake((ScreenWidth - pSize.width)/2, 10 ,pSize.width+5, 11);
}

/*
//语音播放
- (void)voicePlayBtnClick:(UIButton *)btn
{
    [self loadVoice];
}

- (void)loadVoice
{
    queue = [[ASINetworkQueue alloc]init];
    [queue setShowAccurateProgress:YES];
    [queue setShouldCancelAllRequestsOnFailure:NO];
    queue.delegate = self;
    [queue setQueueDidFinishSelector:@selector(finishOver:)];
    BOOL mark = NO;
    NSString *fileName = [[tempModel.content componentsSeparatedByString:@"/"]lastObject];
    NSString *fileNameNoAmr = [[fileName componentsSeparatedByString:@"."]objectAtIndex:0];
    NSString *filePath = [VoiceRecorderBaseVC getPathByFileName:fileNameNoAmr ofType:@"aac"];
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    if (![fileManager fileExistsAtPath:filePath]) {
        //文件不存在
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:tempModel.content]];
        [request setDownloadDestinationPath:filePath];
        [queue addOperation:request];
        mark = YES;
    }
    tempModel.aacLocalUrl = filePath;
    if (mark){
        [queue go];
    }else{
        [self finishOver:nil];
    }
}

- (void)finishOver:(ASINetworkQueue*)queue1{
    if (isplay_ == YES) {
        [self stopVoice];
    }else{
        [self voicePlay];
    }
}

#pragma mark - 开始播放
-(void)voicePlay
{
    player = [[AVAudioPlayer alloc]init];
    isplay_ = NO;
    [self handleNotification:NO];
    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
                            sizeof(sessionCategory),
                            &sessionCategory);
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                             sizeof (audioRouteOverride),
                             &audioRouteOverride);
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //默认情况下扬声器播放
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    if (![fileManager fileExistsAtPath:tempModel.aacLocalUrl]){
        NSLog(@"文件不存在");
    }
    index_ = 1;
    player = [player initWithContentsOfURL:[NSURL URLWithString:tempModel.aacLocalUrl] error:nil];
    player.meteringEnabled = YES;
    player.delegate = self;
    player.currentTime = 0;
    [player play];
    isplay_ = YES;
    [self changeVoiceImage];
}

#pragma mark - 监听听筒or扬声器
- (void) handleNotification:(BOOL)state
{
    //在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
    [[UIDevice currentDevice] setProximityMonitoringEnabled:state];
    if(state)//添加监听
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(sensorStateChange:) name:@"UIDeviceProximityStateDidChangeNotification"
                                                   object:nil];
    else//移除监听
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
}

//处理监听触发事件
-(void)sensorStateChange:(NSNotificationCenter *)notification;
{
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
    if ([[UIDevice currentDevice] proximityState] == YES)
    {
        NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    else
    {
        NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}

- (void)changeVoiceImage
{
    if (index_ >3) {
        index_ = 1;
    }
    if (isplay_ == NO) {
        [_voicePlayBtn setImage:[UIImage imageNamed:@"SenderVoiceNodePlaying.png"] forState:UIControlStateNormal];
        return;
    }
    [_voicePlayBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"SenderVoiceNodePlaying00%d.png",index_]] forState:UIControlStateNormal];
    index_ ++;
    [self performSelector:@selector(changeVoiceImage) withObject:nil afterDelay:0.25];
}


#pragma mark - 播放结束
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self handleNotification:NO];
    isplay_ = NO;
}

-(void)stopVoice
{
    if (isplay_) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [_voicePlayBtn setImage:[UIImage imageNamed:@"SenderVoiceNodePlaying.png"] forState:UIControlStateNormal];
        [player stop];
        player = nil;
        isplay_ = NO;
    }
}
*/
@end
