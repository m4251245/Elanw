//
//  RecordViewCtl.m
//  jobClient
//
//  Created by 一览iOS on 14-9-24.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "RecordViewCtl.h"

@interface RecordViewCtl () <UIAlertViewDelegate>

@end

@implementation RecordViewCtl
@synthesize delegate_,record,player,recordFileNameWav,recordFilePathWav;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isopen_ = YES;
        self.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)tappedCancel:(UIGestureRecognizer *)gesture
{
    if (isplay_ == YES) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [voicePlayBigBtn_ setImage:[UIImage imageNamed:@"recordPlayNormal.png"] forState:UIControlStateNormal];
        [playBtn_ setImage:[UIImage imageNamed:@"bton_yuyinshiting1.png"] forState:UIControlStateNormal];
        [player stop];
        isplay_ = NO;
    }
    if ([delegate_ respondsToSelector:@selector(removeView)]) {
        [delegate_ removeView];
    }
    [self.view removeFromSuperview];
    [longTipsLb_ setHidden:NO];
}

- (void)btnResponse:(id)sender
{
    if (sender == playBtn_) {
        if (isplay_ == YES) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            [playBtn_ setImage:[UIImage imageNamed:@"bton_yuyinshiting1.png"] forState:UIControlStateNormal];
            [player stop];
            isplay_ = NO;
            
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGesture:)];
            [recordBtn_ addGestureRecognizer:longPress];
            [self updateView:NO];
            
        }else{
            for (UIGestureRecognizer *gesutre in [recordBtn_ gestureRecognizers]) {
                if ([gesutre isKindOfClass:[UILongPressGestureRecognizer class]]) {
                    [recordBtn_ removeGestureRecognizer:gesutre];
                }
            }
            
            [self updateView:YES];
            [self voicePlay];
        }
    }
    if (sender == cancelBtn_) {
        if ([delegate_ respondsToSelector:@selector(removeView)]) {
            [delegate_ removeView];
        }
        [self.view removeFromSuperview];
        [longTipsLb_ setHidden:NO];
        [self updateView:YES];
        [timesLb_ setHidden:YES];
    }
    if (sender == replaceVoiceBtn_) {
        //转码
        fileModel.wavName_ = recordFileModel_.wavName_;
        fileModel.wavPath_ = recordFileModel_.wavPath_;
        fileModel.duration_ = recordFileModel_.duration_;
        //上传
        [self upLoadVoiceFile];
    }
    if (sender == voicePlayBigBtn_) {
        if (isplay_ == YES) {
            [voicePlayBigBtn_ setImage:[UIImage imageNamed:@"recordPlayNormal.png"] forState:UIControlStateNormal];
            [player stop];
            isplay_ = NO;
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
        }else{
            [self voicePlay2];
        }
    }
    if (sender == changBtn_) {
        //转播放视图为录音视图
        isRecord_ = YES;
        [voicePlayBigBtn_ setHidden:YES];
        [changBtn_ setHidden:YES];
        [recordBtn_ setHidden:NO];
        [longTipsLb_ setHidden:NO];
        //停止语音播放
        if (isplay_ == YES) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            [voicePlayBigBtn_ setImage:[UIImage imageNamed:@"recordPlayNormal.png"] forState:UIControlStateNormal];
            [player stop];
            isplay_ = NO;
        }
    }
}


#pragma mark -上传语音
- (void)upLoadVoiceFile
{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:fileModel.wavPath_];
    NSData *voiceData = [handle readDataToEndOfFile];
    RequestCon *upLoadCon = [self getNewRequestCon:NO];
    [upLoadCon upLoadVoiceFile:voiceData fileName:[[fileModel.wavPath_ componentsSeparatedByString:@"/"]lastObject]];
}

- (void)updateView:(BOOL)isHiden
{
    CGRect rect = [UIScreen mainScreen].bounds;//[UIApplication sharedApplication].delegate.window.rootViewController.view.frame;
    if (isHiden) {
        [UIView animateWithDuration:0.5 animations:^{
            [toolBarView_ setFrame:CGRectMake(0, rect.size.height, toolBarView_.frame.size.width, toolBarView_.frame.size.height)];
        }];
    }else{
        float height = 20;
        if (IOS8) {
            height = 0;
//            if ([_type isEqualToString:@"2"]) {
//                height = 0;
//            }else{
//                height = 20;
//            }
        }
        
        [UIView animateWithDuration:0.5 animations:^{
            [toolBarView_ setFrame:CGRectMake(0, rect.size.height-toolBarView_.frame.size.height-height, toolBarView_.frame.size.width, toolBarView_.frame.size.height)];
        }];
    }
}

- (void)deleteVocieFile
{
    //沙盒删除
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
    if ([fileManager removeItemAtPath:fileModel.wavPath_ error:nil]) {
        NSLog(@"---------delete voiceFile success !!!------------");
    }
}

#pragma mark -开始播放
-(void)voicePlay
{
    index_ = 1;
    player = [player initWithContentsOfURL:[NSURL URLWithString:recordFileModel_.wavPath_] error:nil];
    player.delegate = self;
    player.currentTime = 0;
    [player play];
    isplay_ = YES;
    [self changeVoiceImage];
}

#pragma mark - 进来播放
-(void)voicePlay2
{
    index_ = 1;
    player = [player initWithContentsOfURL:[NSURL URLWithString:fileModel.wavPath_] error:nil];
    player.delegate = self;
    player.currentTime = 0;
    [player play];
    isplay_ = YES;
    [self changeImage];
}

- (void)changeImage
{
    if (index_ >4) {
        index_ = 1;
    }
    if (isplay_ == NO) {
        [voicePlayBigBtn_ setImage:[UIImage imageNamed:@"recordPlayNormal.png"] forState:UIControlStateNormal];
        return;
    }
    [voicePlayBigBtn_ setImage:[UIImage imageNamed:[NSString stringWithFormat:@"recordPlay%d.png",index_]]forState:UIControlStateNormal];
    index_ ++;
    [self performSelector:@selector(changeImage) withObject:nil afterDelay:0.25];
}

- (void)changeVoiceImage
{
    if (index_ >3) {
        index_ = 1;
    }
    if (isplay_ == NO) {
        [playBtn_ setImage:[UIImage imageNamed:@"bton_yuyinshiting1.png"] forState:UIControlStateNormal];
        return;
    }
    [playBtn_ setImage:[UIImage imageNamed:[NSString stringWithFormat:@"bton_step%d.png",index_]]forState:UIControlStateNormal];
    index_ ++;
    [self performSelector:@selector(changeVoiceImage) withObject:nil afterDelay:0.25];
}

#pragma mark -播放结束
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (isRecord_) {
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGesture:)];
        [recordBtn_ addGestureRecognizer:longPress];
        isplay_ = NO;
        [self handleNotification:NO];
        [self updateView:NO];
    }else{
        isplay_ = NO;
        [self handleNotification:NO];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    recordFileModel_ = [[VoiceFileDataModel alloc]init];
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if (granted) {
            NSLog(@"用户同意使用麦克风");
            isopen_ = YES;
        } else {
            NSLog(@"用户不同意麦克风");
            isopen_ = NO;
        }
    }];
    //初始化视图
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGesture:)];
    [recordBtn_ addGestureRecognizer:longPress];
    longPress.delegate = self;
    
    isRecord_ = YES;
    [voicePlayBigBtn_ setHidden:YES];
    [changBtn_ setHidden:YES];
    [recordBtn_ setHidden:NO];
    [longTipsLb_ setHidden:NO];
    
    playView_.layer.cornerRadius = 30/2;
    playView_.layer.masksToBounds = YES;
    [playView_ setHidden:YES];
    
    player = [[AVAudioPlayer alloc]init];
    CGRect rect = [UIApplication sharedApplication].delegate.window.rootViewController.view.frame;
    [toolBarView_ setFrame:CGRectMake(0, rect.size.height, toolBarView_.frame.size.width, toolBarView_.frame.size.height)];
    
    [longTipsLb_ setFont:FIFTEENFONT_TITLE];
    [timesLb_ setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:20]];
    
    [tispLb_ setFont:SEVENTEENFONT_FRISTTITLE];
    [tispLb_ setTextColor:BLACKCOLOR];
    
    [replaceVoiceBtn_.titleLabel setFont:FIFTEENFONT_TITLE];
    [replaceVoiceBtn_ setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
    
    [cancelBtn_.titleLabel setFont:FIFTEENFONT_TITLE];
    [cancelBtn_ setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
    
    recordBtn_.center = CGPointMake(ScreenWidth/2.0,recordBtn_.center.y);
    voicePlayBigBtn_.center = CGPointMake(ScreenWidth/2.0,voicePlayBigBtn_.center.y);
    playView_.center = CGPointMake(ScreenWidth/2.0,playView_.center.y);
    longTipsLb_.center = CGPointMake(ScreenWidth/2.0,longTipsLb_.center.y);
    changBtn_.center = CGPointMake(ScreenWidth/2.0,changBtn_.center.y);
}

- (void)playVoiceWhenViewShow
{
#pragma mark - 录音或者播放控制
    if (fileModel.serverFilePath_ !=nil) {
        //播放
        NSLog(@"%@",fileModel.serverFilePath_);
        isRecord_ = NO;
        [voicePlayBigBtn_ setHidden:NO];
        [changBtn_ setHidden:NO];
        [recordBtn_ setHidden:YES];
        [longTipsLb_ setHidden:YES];
        [self voicePlay2];
    }else{
        //录音
        isRecord_ = YES;
        [voicePlayBigBtn_ setHidden:YES];
        [changBtn_ setHidden:YES];
        [recordBtn_ setHidden:NO];
        [longTipsLb_ setHidden:NO];
    }
}

- (void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
    if (fileModel.serverFilePath_ == nil) {
        if ([_type isEqualToString:@"1"]) {
            [tispLb_ setText:@"是否上传语音简历"];
        }else if ([_type isEqualToString:@"2"] || [_type isEqualToString:@"3"]){
            [tispLb_ setText:@"是否上传个性语音"];
        }
        [replaceVoiceBtn_ setTitle:@"确定" forState:UIControlStateNormal];
    }else{
        if ([_type isEqualToString:@"1"] || [_type isEqualToString:@"3"]) {
            [tispLb_ setText:@"是否替换现有语音简历"];
        }else if ([_type isEqualToString:@"2"]){
            [tispLb_ setText:@"是否替换现有个性语音"];
        }
        [replaceVoiceBtn_ setTitle:@"替换" forState:UIControlStateNormal];
    }
}


#pragma mark -长按手势 开始录音
- (void)longPressGesture:(UILongPressGestureRecognizer *)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            if (!isopen_)
            {
                if(IOS8)
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"无麦克风访问权限"
                                                                   message:@"请在 “设置-隐私-麦克风” 中进行设置"
                                                                  delegate:self
                                                         cancelButtonTitle:@"取消"
                                                         otherButtonTitles:@"设置", nil];
                    alert.tag = 1001;
                    [alert show];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"无麦克风访问权限"
                                                                   message:@"请在 “设置-隐私-麦克风” 中进行设置"
                                                                  delegate:self
                                                         cancelButtonTitle:@"好"
                                                         otherButtonTitles:nil];
                    alert.tag = 1001;
                    [alert show];
                }
                return;
//                [BaseUIViewController showAlertView:@"无法录音" msg:@"请在 “设置-隐私-麦克风” 选项中进行设置" btnTitle:@"好"];
//                return;
            }
            [self whenStartRecordUpdateView];
            secCount_ = 1;
            [recordBtn_ setImage:[UIImage imageNamed:@"bton_luyin2.png"] forState:UIControlStateNormal];
            [self handleNotification:NO];
            [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error:nil];
            [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker
                                            error:nil];
            [[AVAudioSession sharedInstance] setActive:YES error:nil];
           // UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
            //AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
            //设置文件名和录音路径
            recordFileNameWav = [VoiceRecorderBaseVC getCurrentTimeString];
            recordFilePathWav = [VoiceRecorderBaseVC getPathByFileName:recordFileNameWav ofType:@"aac"];
            NSError *error = [NSError new];
            @try {
                record = [[AVAudioRecorder alloc]initWithURL:[NSURL URLWithString:recordFilePathWav]
                                                    settings:[VoiceRecorderBaseVC getAudioRecorderSettingDict]
                                                       error:&error];
            }
            @catch (NSException *exception) {
                NSLog(@"recode error = %@",error.description);
            }
            @finally {
                
            }
            record.delegate = self;
            record.meteringEnabled = YES;
            [record recordForDuration:60];
            [record prepareToRecord];
            //开始录音
            [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error:nil];
            [[AVAudioSession sharedInstance] setActive:YES error:nil];
            [record record];
            [timesLb_ setHidden:NO];
            timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(detectionVoice) userInfo:nil repeats:YES];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            if (record.isRecording){
                [record stop];
            }
            [timer invalidate];
            timer = nil;
            [recordBtn_ setImage:[UIImage imageNamed:@"recordingNormal.png"] forState:UIControlStateNormal];
        }
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1001)
    {
        if (buttonIndex == 1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
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
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗
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

- (void)detectionVoice
{
    [timesLb_ setText:[NSString stringWithFormat:@"%d \"",secCount_]];
    CGRect playViewRect = playView_.frame;
    CGRect timeLbRect = timesLb_.frame;
    if (secCount_ != 1 && secCount_ < 20) {
        playViewRect.origin.x = playViewRect.origin.x-1;
        playViewRect.size.width = playViewRect.size.width+2;
        
        timeLbRect.origin.x = playViewRect.size.width - timeLbRect.size.width - 5;
        timeLbRect.size.width = timeLbRect.size.width+2;
    }
    secCount_ ++;
    [timesLb_ setFrame:timeLbRect];
    [playView_ setFrame:playViewRect];
}

#pragma mark -录音结束
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    if (record.isRecording){
        [record stop];
    }
    [timer invalidate];
    timer = nil;
    [recordBtn_ setImage:[UIImage imageNamed:@"recordingNormal.png"] forState:UIControlStateNormal];
    NSLog(@"录音文件路径:%@ ,录音文件名:%@",recordFilePathWav,recordFileNameWav);
    AVAudioPlayer *playTemp = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:recordFilePathWav] error:nil];
    if (playTemp.duration * 10 <10) {
        [BaseUIViewController showAlertView:nil msg:@"录音时间太短" btnTitle:@"知道了"];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel:)];
        [self.view addGestureRecognizer:tapGesture];
        return;
    }else if (playTemp.duration * 10 >=600){
        [BaseUIViewController showAlertView:nil msg:@"已达到最大录音长度" btnTitle:@"知道了"];
    }
    [recordFileModel_ setWavPath_:recordFilePathWav];
    [recordFileModel_ setWavName_:recordFileNameWav];
    if (playTemp.duration * 10 < 10) {
        [recordFileModel_ setDuration_:[NSString stringWithFormat:@"1"]];
    }else{
        [recordFileModel_ setDuration_:[NSString stringWithFormat:@"%.0f",playTemp.duration]];
    }
    [playBtn_ setUserInteractionEnabled:YES];
    [self updateView:NO];
}


- (int)getVideopTime:(NSURL * )videourl
{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:videourl options:opts]; // 初始化视频媒体文件
    int minute = 0, second = 0;
    second = (int)(urlAsset.duration.value / urlAsset.duration.timescale); // 获取视频总时长,单位秒
    if (second >= 60) {
        int index = second / 60;
        minute = index;
        second = second - index*60;
    }
    return second;
}

#pragma mark -开始录音前的视图刷新
- (void)whenStartRecordUpdateView
{
//    if (fileModel != nil) {
//        [self deleteVocieFile];
//        fileModel = nil;
    [timesLb_ setText:@"0 \""];
    CGRect rect = playView_.frame;
    rect.size.width = 80;
    rect.origin.x = (ScreenWidth-80)/2.0;
    [playView_ setFrame:rect];
    [playView_ setHidden:NO];
    [self updateView:YES];
//    }
    [playView_ setHidden:NO];
    [longTipsLb_ setHidden:YES];
    [playBtn_ setUserInteractionEnabled:NO];
    for (UIGestureRecognizer *gesutre in [self.view gestureRecognizers]) {
        if ([gesutre isKindOfClass:[UITapGestureRecognizer class]]) {
            [self.view removeGestureRecognizer:gesutre];
        }
    }
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    fileModel = dataModal;
    [timesLb_ setText:@"0 \""];
    CGRect rect = playView_.frame;
    rect.size.width = 80;
    rect.origin.x = (ScreenWidth-80)/2.0;;
    [playView_ setFrame:rect];
    [playView_ setHidden:YES];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel:)];
    [self.view addGestureRecognizer:tapGesture];
}



-(void)getDataFunction:(RequestCon *)con
{
 
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
                fileModel.serverFilePath_ = model.exObj_;
                fileModel.amrName_ = [[fileModel.serverFilePath_ componentsSeparatedByString:@"/"] lastObject];
                if (!addVoiceCon_) {
                    addVoiceCon_ = [self getNewRequestCon:NO];
                }
                [addVoiceCon_ addResumeVoice:[Manager getUserInfo].userId_ voiceName:fileModel.amrName_ voiceDesc:@"" voicePath:fileModel.serverFilePath_ voiceTime:fileModel.duration_ voiceId:fileModel.voiceId_ voiceCateId:fileModel.voiceCateId_ type:_type] ;
            }else{
                [BaseUIViewController showAutoDismissFailView:@"上传失败" msg:@"请重新上传"];
            }
        }
            break;
        case Request_AddResumeVoice:
        {
            Status_DataModal *model = [dataArr objectAtIndex:0];
            if ([model.status_ isEqualToString:@"OK"]) {
                fileModel.voiceId_ = [model.exObjArr_ objectAtIndex:0];
                fileModel.voiceCateId_ = [model.exObjArr_ objectAtIndex:1];
                if (![fileModel.serverFilePath_ containsString:@"http://img105.job1001.com"] && fileModel.serverFilePath_) {
                    if (fileModel.serverFilePath_.length > 0) {
                        NSString *str = [fileModel.serverFilePath_ substringWithRange:NSMakeRange(0,1)];
                        if ([str isEqualToString:@"/"]) {
                            fileModel.serverFilePath_ = [NSString stringWithFormat:@"http://img105.job1001.com%@",fileModel.serverFilePath_];
                        }else{
                            fileModel.serverFilePath_ = [NSString stringWithFormat:@"http://img105.job1001.com/%@",fileModel.serverFilePath_];
                        }
                    }
                }   
                [delegate_ removeView];
                [delegate_ updateView:fileModel];
                [self.view removeFromSuperview];
                [longTipsLb_ setHidden:NO];
                [self updateView:YES];
                [timesLb_ setHidden:YES];
                
                [BaseUIViewController showAutoDismissSucessView:@"上传成功" msg:nil];
            }else{
                [BaseUIViewController showAutoDismissFailView:@"上传失败" msg:@"请重新上传"];
            }
            
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
