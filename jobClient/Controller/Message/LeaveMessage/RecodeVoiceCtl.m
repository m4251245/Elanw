//
//  RecodeVoiceCtl.m
//  jobClient
//
//  Created by 一览ios on 15/8/31.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "RecodeVoiceCtl.h"
#import "ExRequetCon.h"

@interface RecodeVoiceCtl ()
{
    UIView *bgView;
}
@end

@implementation RecodeVoiceCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    _isCancelVoice = NO;
    blackBgView.layer.cornerRadius = 4.0;
    blackBgView.layer.masksToBounds = YES;
    cancelTipsLB1.layer.cornerRadius = 2.0;
    cancelTipsLB2.layer.cornerRadius = 2.0;
    [recodeView setHidden:NO];
    [cancelView setHidden:YES];
    _voiceModel = [[VoiceMessageModel alloc] init];
    
    CGRect rect = blackBgView.frame;
    rect.origin.y = ([UIScreen mainScreen].bounds.size.height - rect.size.height)/2;
    rect.origin.x = ([UIScreen mainScreen].bounds.size.width - rect.size.width)/2;
    
    [recodeView setFrame:rect];
    [cancelView setFrame:rect];
    [blackBgView setFrame:rect];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)show
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    if (!bgView) {
        bgView = [[UIView alloc] initWithFrame:keywindow.frame];
        [bgView setBackgroundColor:[UIColor clearColor]];
    }
    [keywindow addSubview:bgView];
    [keywindow addSubview:self.view];
}

- (void)dismiss
{
    [bgView removeFromSuperview];
    [self.view removeFromSuperview];
}

- (void)showCancelView
{
    if (_isCancelVoice == YES) {
        [recodeView setHidden:YES];
        [cancelView setHidden:NO];
    }else{
        [recodeView setHidden:NO];
        [cancelView setHidden:YES];
    }
}

- (void)detectionVoice
{
    [_record updateMeters];//刷新音量数据
    //获取音量的平均值  [recorder averagePowerForChannel:0];
    //音量的最大值  [recorder peakPowerForChannel:0];
    double lowPassResults = pow(10, (0.05 * [_record peakPowerForChannel:0]));
    NSLog(@"lowPassResults %lf",lowPassResults);
    if (0<lowPassResults<=0.14) {
        [voiceValImgv setImage:[UIImage imageNamed:@"RecordingSignal001"]];
    }else if (0.14<lowPassResults<=0.28) {
        [voiceValImgv setImage:[UIImage imageNamed:@"RecordingSignal002"]];
    }else if (0.28<lowPassResults<=0.42) {
        [voiceValImgv setImage:[UIImage imageNamed:@"RecordingSignal003"]];
    }else if (0.42<lowPassResults<=0.56) {
        [voiceValImgv setImage:[UIImage imageNamed:@"RecordingSignal004"]];
    }else if (0.56<lowPassResults<=0.70) {
        [voiceValImgv setImage:[UIImage imageNamed:@"RecordingSignal005"]];
    }else if (0.70<lowPassResults<=0.84) {
        [voiceValImgv setImage:[UIImage imageNamed:@"RecordingSignal006"]];
    }else if (0.84<lowPassResults<=1.00) {
        [voiceValImgv setImage:[UIImage imageNamed:@"RecordingSignal007"]];
    }
}

-(void)stratRecordVoice
{
    _timesCount = 1;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker
                                    error:nil];
//    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
//    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
    //设置文件名和录音路径
    _localVoiceName = [VoiceRecorderBaseVC getCurrentTimeString];
    _localVoicePath = [VoiceRecorderBaseVC getPathByFileName:_localVoiceName ofType:@"aac"];
    [_voiceModel setLocalVoiceName:_localVoiceName];
    [_voiceModel setLocalVoicePath:_localVoicePath];
    NSError *error = [NSError new];
    @try {
        _record = [[AVAudioRecorder alloc]initWithURL:[NSURL URLWithString:_localVoicePath]
                                            settings:[VoiceRecorderBaseVC getAudioRecorderSettingDict]
                                               error:&error];
    }
    @catch (NSException *exception) {
        NSLog(@"recode error = %@",error.description);
    }
    @finally {
        
    }
    _record.delegate = self;
    _record.meteringEnabled = YES;
    [_record recordForDuration:60];
    [_record prepareToRecord];
    //开始录音
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [_record record];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(detectionVoice) userInfo:nil repeats:YES];
}

#pragma mark -录音结束
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    if (_record.isRecording){
        [_record stop];
    }
    //上传语音
    if (_isCancelVoice == NO){
        AVAudioPlayer *playTemp = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:_localVoicePath] error:nil];
        if (playTemp.duration * 10 <10) {
            //[BaseUIViewController showAlertView:nil msg:@"录音时间太短" btnTitle:@"知道了"];
            [BaseUIViewController showAlertViewContent:@"录音时间太短" toView:nil second:1.0 animated:YES];
            return;
        }else if (playTemp.duration * 10 >=600){
            [BaseUIViewController showAlertView:nil msg:@"已达到最大录音长度" btnTitle:@"知道了"];
        }
        if (playTemp.duration * 10 < 10) {
            [_voiceModel setDuration:[NSString stringWithFormat:@"1"]];
        }else{
            [_voiceModel setDuration:[NSString stringWithFormat:@"%.0f",playTemp.duration]];
        }
        [self uploadVoice];
    }else{
        //删除录音
        [self clearData];
    }
}


- (void)clearData
{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    BOOL bRet = [fileMgr fileExistsAtPath:_localVoicePath];
    if (bRet) {
        NSError *err;
        [fileMgr removeItemAtPath:_localVoicePath error:&err];
        if (err != nil) {
            NSLog(@"err %@",err.description);
        }
    }
}

- (void)uploadVoice
{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:_voiceModel.localVoicePath];
    NSData *voiceData = [handle readDataToEndOfFile];
    RequestCon *upLoadCon = [self getNewRequestCon:NO];
    [upLoadCon upLoadVoiceFile:voiceData fileName:[[_voiceModel.localVoicePath componentsSeparatedByString:@"/"]lastObject]];
}

- (void)stopRecordVoice
{
    if (_record.isRecording){
        [_record stop];
    }
    [_timer invalidate];
    _timer = nil;
    [self dismiss];
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon_ code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_UploadVoiceFile:
        {
            Status_DataModal *model = [dataArr objectAtIndex:0];
            if ([model.status_ isEqualToString:@"OK"]) {
                //返回语音URL成功
                _voiceModel.servicePathUrl = [NSString stringWithFormat:@"http://img105.job1001.com/%@",model.exObj_];
                if ([_delegate respondsToSelector:@selector(upLoadVoiceSuccess:)]) {
                    [_delegate upLoadVoiceSuccess:_voiceModel];
                }
                //返回地址成功，这里代理发送消息
            }else{
                [BaseUIViewController showAutoDismissFailView:@"发送失败" msg:@"请重新上传"];
            }
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
