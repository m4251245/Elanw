//
//  MessageDailogListCtl.h
//  jobClient
//
//  Created by 一览ios on 14/12/9.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//留言对话

#import "BaseListCtl.h"
#import "LeaveMessageListCtl.h"
#import "YLWhoLikeMeListCtl.h"
#import <AVFoundation/AVFoundation.h>
#import "ASINetworkQueue.h"

@class ELGroupDetailModal;

@interface ELGroupIMListCtl : BaseListCtl<AVAudioPlayerDelegate>
{
    BOOL                        isplay_;   //是否正在播放
    AVAudioPlayer               *player;
    NSInteger                   index_;
    ASINetworkQueue *queue;
}
@property (nonatomic, strong) ELGroupDetailModal *inDataModel;

@property (weak, nonatomic) IBOutlet UITextView *msgContentTV;
@property (weak, nonatomic) IBOutlet UILabel *voicelb;
@property (weak, nonatomic) IBOutlet UIView *msgContentView;
@property (weak, nonatomic) IBOutlet UIButton    *voiceMessageBtn;
@property (weak, nonatomic) IBOutlet UIButton *faceBtn;

@property(nonatomic,assign) BOOL isRefresh;
@property (strong, nonatomic) IBOutlet UIImageView *delCopyImgv;
@property (weak, nonatomic) UIButton *editorBtn;
@property (strong, nonatomic) UIViewController *tipsCtl;
@property (strong, nonatomic) RequestCon *deleteMsgCon;
@property (strong, nonatomic)  NSMutableArray *messageFrameList;
@property (nonatomic,assign) BOOL isPop;


- (IBAction)sendMsgBtnClick:(id)sender;



@end
