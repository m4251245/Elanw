//
//  RecodeVoiceCtl.h
//  jobClient
//
//  Created by 一览ios on 15/8/31.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ChatVoiceRecorderVC.h"
#import "VoiceMessageModel.h"

@protocol  RecodeVoiceCtlDelegate<NSObject>

- (void)upLoadVoiceSuccess:(VoiceMessageModel *)model;

@end

@interface RecodeVoiceCtl : BaseUIViewController<AVAudioRecorderDelegate>
{
    
    __weak IBOutlet UIView *blackBgView;
    __weak IBOutlet UIView *recodeView;
    __weak IBOutlet UIView *cancelView;
    __weak IBOutlet UILabel *cancelTipsLB1;
    __weak IBOutlet UILabel *cancelTipsLB2;
    __weak IBOutlet UIImageView *voiceValImgv;

}

@property (nonatomic, strong)AVAudioRecorder         *record;
@property (nonatomic, strong)NSString                *localVoiceName;
@property (nonatomic, strong)NSString                *localVoicePath;
@property (nonatomic, strong)NSTimer                 *timer;
@property (nonatomic, assign)NSInteger               timesCount;
@property (nonatomic, assign)BOOL                    isCancelVoice;
@property (nonatomic, strong)VoiceMessageModel       *voiceModel;
@property (nonatomic, assign) id<RecodeVoiceCtlDelegate> delegate;

- (void)dismiss;
-(void)show;
-(void)stratRecordVoice;
- (void)stopRecordVoice;
- (void)showCancelView;

@end
