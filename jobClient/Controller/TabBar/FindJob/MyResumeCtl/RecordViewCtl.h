//
//  RecordViewCtl.h
//  jobClient
//
//  Created by 一览iOS on 14-9-24.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "ChatVoiceRecorderVC.h"
#import "VoiceFileDataModel.h"
#import "ExRequetCon.h"

@protocol RecordViewCtlDelegate <NSObject>

- (void)removeView;
- (void)updateView:(VoiceFileDataModel *)fileModel;

@end

@interface RecordViewCtl : BaseUIViewController<AVAudioRecorderDelegate,AVAudioPlayerDelegate,UIGestureRecognizerDelegate>
{
    IBOutlet    UIButton        *recordBtn_;
    IBOutlet    UIView          *playView_;
    IBOutlet    UIButton        *playBtn_;
    IBOutlet    UILabel         *timesLb_;
    IBOutlet UIButton           *voicePlayBigBtn_;
    IBOutlet    UIView          *toolBarView_;
    IBOutlet    UILabel         *tispLb_;
    IBOutlet    UIButton        *replaceVoiceBtn_;
    IBOutlet    UIButton        *cancelBtn_;
    IBOutlet    UILabel         *longTipsLb_;
    IBOutlet    UIButton        *changBtn_;
    NSTimer                         *timer;
    NSString      *voiceWavPath_;             //封装Wav语音路径，用于本地播放
    NSString      *voiceWavName_;         //封装Wav语音文件名字，用于转码
    NSString      *voiceAmrForService_;     //封装服务器返回的Amr路径
    NSString      *voiceAmrForLocationPath_;    //封装wav转码的amr路径
    VoiceFileDataModel *fileModel;
    VoiceFileDataModel *recordFileModel_;        //用于取消操作时候的model
    int         secCount_;
    BOOL           isplay_;
    int             index_;
    RequestCon                  *addVoiceCon_;
    BOOL                            isopen_;          //麦克风是否打开
    BOOL                            isRecord_;        //YES 表示是录音
    
}

@property (retain, nonatomic)   AVAudioPlayer           *player;
@property (retain, nonatomic)   AVAudioRecorder         *record;
@property (nonatomic, strong)   NSString    *recordFilePathWav;
@property (nonatomic, strong)   NSString    *recordFileNameWav;
@property (copy, nonatomic)     NSString                *convertAmrFileName;        //转换后的amr文件名
@property (copy, nonatomic)     NSString                *convertAmrFilePath;        //转换后的amr文件路径
@property (copy, nonatomic)     NSString                *convertWavFileName;        //amr转wav的文件名
@property (nonatomic,assign) id<RecordViewCtlDelegate> delegate_;
@property (nonatomic,strong)   NSString                 *type;
@property (nonatomic,strong)   NSString                 *interType;
- (void)playVoiceWhenViewShow;

@end
