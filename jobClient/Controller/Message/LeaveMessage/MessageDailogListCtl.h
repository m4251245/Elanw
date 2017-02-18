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

@class MessageContact_DataModel;

@interface MessageDailogListCtl : BaseListCtl<AVAudioPlayerDelegate>
{
    BOOL                        isplay_;   //是否正在播放
    AVAudioPlayer               *player;
    NSInteger                   index_;
    ASINetworkQueue *queue;
}
@property (nonatomic, strong) MessageContact_DataModel *inDataModel;

@property (weak, nonatomic) IBOutlet UITextView *msgContentTV;
@property (weak, nonatomic) IBOutlet UILabel *voicelb;
@property (weak, nonatomic) IBOutlet UIView *msgContentView;
@property (weak, nonatomic) IBOutlet UIImageView *sameSchoolLb;
@property (weak, nonatomic) IBOutlet UIButton    *voiceMessageBtn;
//顶部视图
@property (weak, nonatomic) IBOutlet UIImageView *toUserImg;
@property (weak, nonatomic) IBOutlet UILabel *toUserName;
@property (weak, nonatomic) IBOutlet UIButton *sexAndAgeBtn;

@property (weak, nonatomic) IBOutlet UILabel *summaryLb;

@property (weak, nonatomic) IBOutlet UIButton *faceBtn;

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIView *elanRenZhengLb;

@property (weak, nonatomic) IBOutlet UIButton *companyBtn;

@property(nonatomic,strong) YLWhoLikeMeListCtl *whlCtl;
@property(nonatomic,assign) BOOL isRefresh;

@property(nonatomic,assign) BOOL isHr;

@property(nonatomic,assign) BOOL refreshGuwenCountFlag;  //是否要刷新顾问联系记录

- (IBAction)sendMsgBtnClick:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *delCopyImgv;

@property (weak, nonatomic) UIButton *editorBtn;

@property (strong, nonatomic) UIViewController *tipsCtl;

@property (strong, nonatomic) RequestCon *deleteMsgCon;

@property (strong, nonatomic)  NSMutableArray *messageFrameList;

//约谈私信
@property (nonatomic, strong) NSString *productType; //
@property (nonatomic, strong) NSString *recordId;   //

@property (nonatomic,assign) BOOL isPop;

@end
