//
//  MessageDailogListCtl.m
//  jobClient
//
//  Created by 一览ios on 14/12/9.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//他人给自己私信对话

#import "MessageDailogListCtl.h"
#import "ExRequetCon.h"
#import "LeaveMessage_DataModel.h"
#import "MessageContact_DataModel.h"
#import "MessageDailogList_Cell.h"
#import "MessageDailogList_Cell2.h"
#import "MessageDailog_ShareLeftCell.h"
#import "MessageDailog_ShareRightCell.h"
#import "FaceScrollView.h"
#import "MLEmojiLabel.h"
#import "MessageDailogCellFrame.h"
#import "JobSearch_DataModal.h"
#import "MyJobSearchCtlCell.h"
#import "YLMessageLikeLeftCell.h"
#import "YLMessageLikeRightCell.h"
#import "MessageDelTipsCtl.h"
#import "MessageVoiceLeftCell.h"
#import "MessageVoiceRightCell.h"
#import "PhotoSelectCtl.h"
#import "RecodeVoiceCtl.h"
#import "MyFavoriteCenterCtl.h"
#import "ShareMessageModal.h"
#import "NSString+URLEncoding.h"
#import "ELMessageImage_Cell.h"
#import "Upload_DataModal.h"
#import "ELMessageQuestioning_Cell.h"
#import "ELMyAspectantDiscussCtl.h"
#import "ELMessageQuestionLeftCell.h"
#import "ELMessageQuestionRightCell.h"
#import "AlbumListCtl.h"
#import "ELPersonCenterCtl.h"
#import "OwnGroupListCtl.h"
#import "ResumePreviewController.h"
#import "ASIHTTPRequest.h"
#import "ELNewResumePreviewCtl.h"

#define IOS7 [[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0
static int kTagIdOffSet = 1001;

@interface MessageDailogListCtl ()<UITextViewDelegate,SameTradeListCtlDelegate,JobSearchMessageDelegate,FavoriteMessageDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,RecodeVoiceCtlDelegate,ImageCellDelegate, PhotoSelectCtlDelegate,UIActionSheetDelegate,UIScrollViewDelegate,ASIHTTPRequestDelegate>
{
    BOOL _isKeyboardShow;
    CGFloat _keyboardHeight;
    UITapGestureRecognizer *_singleTapRecognizer;
    RequestCon *_sendPesonalMsgCon;//发私信
    LeaveMessage_DataModel *_sendLeaveMessage;//发送的私信
    FaceScrollView *_faceScrollView;//表情面板
    CGFloat _move;//tableview的滚动距离
    RequestCon *hrCon;
    Expert_DataModal *hrMessageModel;
    UITapGestureRecognizer *copyTap;
    __weak IBOutlet UIButton *shareAddBtn;
    IBOutlet UIView *shareAddView;
    RecodeVoiceCtl  *recodeVoiceCtl;
    RequestCon *shareCon;
    ShareMessageModal *shareModal;
    ShareMessageModal *resumeShareModal;
    BOOL isShareViewShow;
    UIImage *shareImage;
    NSString *shareImageUrl;
    CGPoint     pointBegin;
    CGPoint  tableViewSet;
    IBOutlet UIButton *sendBtn;
    NSInteger alertType;
    UIButton    *tempBtn;
    LeaveMessage_DataModel *tempModel;
    UIButton  *voicePlayLeftBtn;
    UIButton  *voicePlayRightBtn;
    NSString  *voiceType;  //1左
    NSString *receiveMessageId;
    
    __weak IBOutlet UIImageView *lineImage;
    
    __weak IBOutlet UIView *msgBackView;
    
    CGFloat textViewHeight;
    NSInteger sendLeaveMessageTime;//记录连续时间间隔
    NSInteger indirectTimeInterval;//间接时间间隔
}
@end

@implementation MessageDailogListCtl
#pragma mark - LifeCycle
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"receiveNewMessageFromPush" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mykeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mykeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNewMessageDetailList:) name:@"receiveNewMessageFromPush" object:nil];
    
    if (_isPop) {
        self.fd_interactivePopDisabled = YES;
    }
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    inputCount = 1;
    CGRect rect = tableView_.frame;
    rect.size.width = self.view.frame.size.width;
    tableView_.frame = rect;
    [tableView_ setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_faceBtn setImage:[UIImage imageNamed:@"ToolViewKeyboard.png"] forState:UIControlStateSelected];
    [shareAddBtn setImage:[UIImage imageNamed:@"ToolViewKeyboard.png"] forState:UIControlStateSelected];
    msgBackView.layer.borderWidth = 0.3;
    msgBackView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    msgBackView.layer.cornerRadius = 4.0;
    _msgContentTV.delegate = self;
    _voicelb.layer.borderWidth = 0.3;
    _voicelb.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _voicelb.layer.cornerRadius = 4.0;
    [_toUserImg.layer setMasksToBounds:YES];
    [_toUserImg.layer setCornerRadius:4.0];
    [_sexAndAgeBtn.layer setMasksToBounds:YES];
    [_sexAndAgeBtn.layer setCornerRadius:2.0];
    _messageFrameList = [NSMutableArray array];
    [_delCopyImgv addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(copyDelImgvClick:)]];
    
    UILongPressGestureRecognizer *longPre = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGesture:)];
    longPre.minimumPressDuration = 0.1;
    [_voicelb addGestureRecognizer:longPre];
    _voicelb.userInteractionEnabled = YES;
    CGRect frame = shareAddView.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height - 20;
    frame.size.width = ScreenWidth;
    shareAddView.frame = frame;
    [self.view addSubview:shareAddView];
    
    CGFloat width = (ScreenWidth -46*4-27*2)/3.0;
    
    for (NSInteger i = 0;i<7;i++)
    {
        UIButton *btn = (UIButton *)[shareAddView viewWithTag:340+i];
        UILabel *lable = (UILabel *)[shareAddView viewWithTag:540+i];
//        UIImageView *imageView = (UIImageView *)[shareAddView viewWithTag:440+i];
        
        CGRect frame = btn.frame;
//        frame.origin.x = width + (i%4)*(width+64);
        frame.origin.x = ((i%4)>0)? (27+(i%4)*(width+46)):27;
        btn.frame = frame;
        
        lable.center = CGPointMake(btn.center.x,lable.center.y);
    }
    
    CGRect frame2 = _msgContentView.frame;
    frame2.origin.y = ScreenHeight-64-frame2.size.height;
    _msgContentView.frame = frame2;
    
    if ([self respondsToSelector:@selector(setAllowsNonContiguousLayout:)]) {
        _msgContentTV.layoutManager.allowsNonContiguousLayout = NO;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged) name: UITextViewTextDidChangeNotification object:nil];
    
}

//-----------键盘处理－－－－－－－－－－

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    self.navigationItem.title = _inDataModel.userIname;
    //[super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(voicePlayIndex:) name:@"VoicePlayIndex" object:nil];
    
//    if (tableViewSet.y > 0)
//    {
//        if ((tableViewSet.y + 100) > (tableView_.contentSize.height - ([[UIScreen mainScreen] bounds].size.height - 104)))
//        {
//            CGFloat contentY = tableView_.contentSize.height - ([[UIScreen mainScreen] bounds].size.height - 104);
//            tableView_.contentOffset = CGPointMake(0,contentY > 0 ? contentY:0);
//        }
//        else
//        {
//            tableView_.contentOffset = tableViewSet;
//        }
//    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    CGRect rect = tableView_.frame;
    double height ;//= _isKeyboardShow?(ScreenHeight-_keyboardHeight-104):(ScreenHeight-104);
    if (_isKeyboardShow) {
        height = (ScreenHeight-_keyboardHeight-104);
    }else if (_faceScrollView.isShow){
        height = ScreenHeight-104-_faceScrollView.frame.size.height;
    }else if (isShareViewShow){
        height = ScreenHeight-104-shareAddView.frame.size.height;
    }else{
        height = ScreenHeight-104;
    }
    rect.size.height = height-rect.origin.y;
    tableView_.frame = rect;
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"VoicePlayIndex" object:nil];
    
//    [self viewSingleTap:nil];
    [self stopVoice];
}

-(void)viewDidDisappear:(BOOL)animated{
//    self.navigationItem.title = @"";
}

-(void)textChanged
{
    [self changeTextViewFrame];
}

-(void)changeTextViewFrame
{
    CGRect textFrame=[[_msgContentTV layoutManager]usedRectForTextContainer:[_msgContentTV textContainer]];
    CGFloat height = textFrame.size.height+2;
    if (fabs(height -textViewHeight) < 10) {
        return;
    }
    textViewHeight = height;
    _msgContentTV.textContainerInset = UIEdgeInsetsMake(0,0,0,0);
    CGRect frame = msgBackView.frame;
    if (height > 90) {
        frame.size.height = 84;
    }else{
        frame.size.height = height > 30 ? height:30; 
    }
    msgBackView.frame = frame;
    
    frame = _msgContentTV.frame;
    if (height < 20 || _msgContentTV.text.length <= 0) {
        frame.origin.y = 8;
    }else{
        frame.origin.y = 0;
    }
    _msgContentTV.frame = frame;
    
    CGFloat heightOne = 0;
    if (_isKeyboardShow) {
        heightOne = _keyboardHeight;
    }
    else if (_faceScrollView.isShow)
    {
        heightOne = _faceScrollView.frame.size.height;
    }
    frame = _msgContentView.frame;
    frame.size.height = msgBackView.frame.size.height +10;
    frame.origin.y = ScreenHeight- 64 -  heightOne - frame.size.height;
    _msgContentView.frame = frame;
    
    if(msgBackView.frame.size.height >= 84){
        [_msgContentTV scrollRangeToVisible:_msgContentTV.selectedRange]; 
    }
    lineImage.frame = CGRectMake(-10,CGRectGetHeight(_msgContentView.frame)-1,ScreenWidth+10,1);
//    if (inputCount != count && count <= 5) {
//        inputCount = count;
//
//        [UIView animateWithDuration:0.2 animations:^{
//            tableView_.contentInset = UIEdgeInsetsMake(0, 0, CGRectGetHeight(_faceScrollView.frame)+textViewHeight, 0);
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(_messageFrameList.count - 1) inSection:0];
//            [tableView_ scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//        } completion:^(BOOL finished) {
//            
//        }];
//    }
}


- (MLEmojiLabel *)emojiLabel:(NSString *)text
{
    MLEmojiLabel * emojiLabel;
    if (!emojiLabel) {
        emojiLabel = [[MLEmojiLabel alloc]init];
        emojiLabel.tag =  kTagIdOffSet + 3000;
        emojiLabel.numberOfLines = 0;
        emojiLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
        emojiLabel.backgroundColor = [UIColor clearColor];
        emojiLabel.lineBreakMode = NSLineBreakByCharWrapping;
        emojiLabel.isNeedAtAndPoundSign = YES;
        emojiLabel.customEmojiRegex = Custom_Emoji_Regex;
        emojiLabel.customEmojiPlistName = @"emoticons.plist";
        [emojiLabel setEmojiText:text];
    }
    return emojiLabel;
}



- (void)voicePlayIndex:(NSNotification *)foby
{
    
}

#pragma mark -长按手势 开始录音
- (void)longGesture:(UILongPressGestureRecognizer *)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            recodeVoiceCtl = [[RecodeVoiceCtl alloc] init];
            recodeVoiceCtl.delegate = self;
            [recodeVoiceCtl show];
            [recodeVoiceCtl stratRecordVoice];
            pointBegin = [gesture locationInView:_voicelb];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint location=[gesture locationInView:_voicelb];
            if (pointBegin.y - location.y > 100) {
                //删除
                if (!recodeVoiceCtl.isCancelVoice) {
                    recodeVoiceCtl.isCancelVoice = YES;
                    [recodeVoiceCtl showCancelView];
                }
            }else{
                if (recodeVoiceCtl.isCancelVoice) {
                    recodeVoiceCtl.isCancelVoice = NO;
                    [recodeVoiceCtl showCancelView];
                }
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [recodeVoiceCtl stopRecordVoice];
            
        }
            break;
        default:
            break;
    }
}

- (void)upLoadVoiceSuccess:(VoiceMessageModel *)model
{
    NSLog(@"%@",model.servicePathUrl);
    [self sendVoiceMessage:model];
}

#pragma mark 发送语音
- (void)sendVoiceMessage:(VoiceMessageModel *)model{
    if (!_sendPesonalMsgCon) {
        _sendPesonalMsgCon = [self getNewRequestCon:NO];
    }
    if (_faceScrollView.isShow) {
        [self hideFaceView:YES];
    }
    User_DataModal *user = [Manager getUserInfo];
    NSString *fromUserId = user.userId_;
    NSString *toUserId = _inDataModel.userId;
    [_sendPesonalMsgCon leaveMsgContent:[NSString stringWithFormat:@"%@#%@",model.servicePathUrl,model.duration] from:fromUserId to:toUserId hrFlag:_isHr shareType:@"5" productType:@"" recordId:@""];
    _sendLeaveMessage = [[LeaveMessage_DataModel alloc]init];
    _sendLeaveMessage.content = model.servicePathUrl;
    _sendLeaveMessage.voiceTime = model.duration;
    _sendLeaveMessage.isSend = @"1";
    _sendLeaveMessage.personPic = user.img_;
//    _sendLeaveMessage.date = @"刚刚";
    //
    [self timeInterval];
    _sendLeaveMessage.messageType = MessageTypeVoice;
    [_messageFrameList addObject:_sendLeaveMessage];
    [tableView_ reloadData];
    [self scrollTableToFoot:YES];
    [_msgContentTV resignFirstResponder];
    _msgContentTV.text = @"";
    [self changeTextViewFrame];
}

#pragma mark 复制或者删除消息
- (void)copyDelImgvClick:(UIGestureRecognizer *)tap
{
    UIView *sender = tap.view;
    CGPoint point = [tap locationInView:sender];
    if (point.x< tap.view.bounds.size.width*0.5) {//复制
        MessageDailogCellFrame *cellFrame = _messageFrameList[sender.tag];
        LeaveMessage_DataModel *leaveMessage = cellFrame.leaveMessage;
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = leaveMessage.content;
        
    }else{//删除
        [self deleteMsg:sender];
    }
    [_delCopyImgv removeFromSuperview];
}

#pragma mark 删除消息
- (void)deleteMsg:(UIView *) sender
{
    
    [_msgContentTV resignFirstResponder];
    id frame = _messageFrameList[sender.tag];
    if ([frame isKindOfClass:[MessageDailogCellFrame class]])
    {
        MessageDailogCellFrame *frameOne = (MessageDailogCellFrame *)frame;
        if (frameOne.leaveMessage.msgId.length == 0) {
            return;
        }
    }
    else if ([frame isKindOfClass:[LeaveMessage_DataModel class]])
    {
        LeaveMessage_DataModel *modal = (LeaveMessage_DataModel *)frame;
        if (modal.msgId.length == 0) {
            return;
        }
    }
    
    MessageDelTipsCtl *delTipsCtl = [[MessageDelTipsCtl alloc]init];
    delTipsCtl.row = sender.tag;
    __weak typeof(MessageDailogListCtl) *weakSelf = self;
    delTipsCtl.delMessageBlock = ^(NSInteger row){
        NSLog(@"%ld", (long)row);
        if(!weakSelf.deleteMsgCon){
            weakSelf.deleteMsgCon = [weakSelf getNewRequestCon:NO];
        }
        MessageDailogCellFrame *messageModel = weakSelf.messageFrameList[row];
        if ([messageModel isKindOfClass:[MessageDailogCellFrame class]]) {
            [weakSelf.messageFrameList removeObjectAtIndex:row];
            [weakSelf.deleteMsgCon  deletePersonMsg:[Manager getUserInfo].userId_ msgId:messageModel.leaveMessage.msgId];
        }else if ([messageModel isKindOfClass:[LeaveMessage_DataModel class]]){
            [weakSelf.messageFrameList removeObjectAtIndex:row];
            [weakSelf.deleteMsgCon  deletePersonMsg:[Manager getUserInfo].userId_ msgId:((LeaveMessage_DataModel*)messageModel).msgId];
        }
    };
    [sender removeFromSuperview];
    delTipsCtl.view.frame = [UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:delTipsCtl.view];
    _tipsCtl = delTipsCtl;
}

//-----------数据请求与刷新－－－－－－－－－－

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    _inDataModel = dataModal;
//    self.navigationItem.title = _inDataModel.userIname;
    [self setNavTitle:_inDataModel.userIname];
    [super beginLoad:dataModal exParam:exParam];
    
    [self loadResumeInfomation:[Manager getUserInfo].userId_];
}


-(void)getDataFunction:(RequestCon *)con
{
    if(con == requestCon_){
        NSString *myId = [Manager getUserInfo].userId_;
        if (!myId) {
            [BaseUIViewController showAutoDismissFailView:@"登录后才能查看私信" msg:nil seconds:2.0];
            return;
        }
        
        if (![_productType isEqualToString:@"1"]) {
            _productType = @"";
            _recordId = @"";
        }
        
        NSString *userId;
        if (_inDataModel.userId.length > 0) {
            userId = _inDataModel.userId;
        }
        else{
            userId = @"";
        }
        
        [requestCon_ getPersonalMsgListWithFrom:userId to:myId productType:_productType recordId:_recordId];
        if (!hrCon) {
            hrCon = [self getNewRequestCon:NO];
        }
        [hrCon getHrMessageWithLoginId:[Manager getUserInfo].userId_ visitorId:_inDataModel.userId];
    }else if(con == _sendPesonalMsgCon){
        
    }
}

-(void)updateCom:(RequestCon *)con
{
    double height = 0;
    if (_isKeyboardShow) {
        height = (ScreenHeight-_keyboardHeight-104);
    }else if (_faceScrollView.isShow){
        height = ScreenHeight-104-_faceScrollView.frame.size.height;
    }else if (isShareViewShow){
        height = ScreenHeight-104-shareAddView.frame.size.height;
    }else{
        height = ScreenHeight-104;
    }
    if (hrMessageModel != nil) {
        
        [tableView_ setFrame:CGRectMake(0, 66, ScreenWidth, height - 66)];
        [_toUserImg sd_setImageWithURL:[NSURL URLWithString:hrMessageModel.img_] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
        _toUserName.text = hrMessageModel.iname_;
        CGSize nameSize = [_toUserName.text sizeNewWithFont:[UIFont systemFontOfSize:15] forWidth:MAXFLOAT lineBreakMode:NSLineBreakByWordWrapping];
        CGRect frame = _toUserName.frame;
        if (nameSize.width>95) {
            nameSize.width = 95;
        }
        frame.size.width = nameSize.width;
        _toUserName.frame = frame;
        CGFloat sexX = CGRectGetMaxX(_toUserName.frame) +5;
        CGRect sexFrame = _sexAndAgeBtn.frame;
        sexFrame.origin.x = sexX;
        _sexAndAgeBtn.frame = sexFrame;
        if ([hrMessageModel.sex_ isEqualToString:@"男"]) {
            [_sexAndAgeBtn setBackgroundImage:[UIImage imageNamed:@"icon_boy2.png"] forState:UIControlStateNormal];
        }else if ([hrMessageModel.sex_ isEqualToString:@"女"]){
            [_sexAndAgeBtn setBackgroundImage:[UIImage imageNamed:@"icon_girl2.png"] forState:UIControlStateNormal];
        }else{
            [_sexAndAgeBtn setBackgroundImage:nil forState:UIControlStateNormal];
            [_sexAndAgeBtn setBackgroundColor:[UIColor colorWithRed:151.f/255 green:204.f/255 blue:244.f/255 alpha:1.f]];
        }
        if ([hrMessageModel.age_ isEqualToString:@"0"] || [hrMessageModel.age_ isEqualToString:@""]) {
            hrMessageModel.age_ = @"保密";
        }
        [_sexAndAgeBtn setTitle:hrMessageModel.age_ forState:UIControlStateNormal];
        
        if (hrMessageModel.is_Hr) {
            [_companyBtn setTitle:@"进入公司招聘主页" forState:UIControlStateNormal];
            [_elanRenZhengLb setHidden:NO];
            CGRect rect = _summaryLb.frame;
            [_summaryLb setFrame:CGRectMake(rect.origin.x, rect.origin.y, 150, rect.size.height)];
            _summaryLb.text = hrMessageModel.company_;
            [_topView setHidden:NO];
        }else if (hrMessageModel.is_Rc){
            NSString *gzNumStr;
            if ([hrMessageModel.gznum_ isEqualToString:@"0.0"] ||[hrMessageModel.gznum_ isEqualToString:@""]) {
                gzNumStr = @"工作经验保密";
            }else{
                NSInteger gzNum = [hrMessageModel.gznum_ integerValue];
                gzNumStr = [NSString stringWithFormat:@"%ld年工作经验", (long)gzNum];
            }
            if ([hrMessageModel.job_ isEqualToString:@""]) {
                hrMessageModel.job_ = @"职位保密";
            }
            NSString *summary = [NSString stringWithFormat:@"%@ | %@", gzNumStr, hrMessageModel.job_];
            _summaryLb.text = summary;
            [_companyBtn setTitle:@"查看简历" forState:UIControlStateNormal];
            CGRect rect = _summaryLb.frame;
            [_summaryLb setFrame:CGRectMake(rect.origin.x, rect.origin.y, 190, rect.size.height)];
            [_elanRenZhengLb setHidden:YES];
            [_topView setHidden:NO];
        }else{
            [_topView setHidden:YES];
            [tableView_ setFrame:CGRectMake(0, 0, ScreenWidth, height)];
        }
    }else{
        [_topView setHidden:YES];
        [tableView_ setFrame:CGRectMake(0, 0, ScreenWidth, height)];
    }
    if(con != _deleteMsgCon)
    {
        [self performSelector:@selector(scrollToTableBottom) withObject:nil afterDelay:0.3];
    }
}

- (void)updateHrView
{
    if (hrMessageModel != nil) {
        [_topView setHidden:NO];
    }else{
        [_topView setHidden:YES];
    }
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case getHrMessageWithLoginId:
        {
            if ([dataArr count] != 0) {
                hrMessageModel = [dataArr objectAtIndex:0];
                [self updateHrView];
            }
        }
            break;
        case Request_GetPersonalMsgList:
        {
            [_messageFrameList removeAllObjects];
            for (LeaveMessage_DataModel *model in dataArr) {
                if (model.messageType != MessageTypeText && model.messageType != MessageTypeWeiTuo) {
                    [_messageFrameList addObject:model];
                    continue;
                }
                MessageDailogCellFrame *cellFrame = [[MessageDailogCellFrame alloc]init];
                cellFrame.leaveMessage = model;
                [_messageFrameList addObject:cellFrame];
            }
            
            [requestCon_.dataArr_ removeAllObjects];
            if (_isRefresh)
            {
                [_whlCtl refreshLoad:nil];
            }
            
        }
            break;
        case Request_LeaveMessage:
        {
            Status_DataModal *dataModal = [dataArr objectAtIndex:0];
            _sendLeaveMessage.code = dataModal.code_;
            _sendLeaveMessage.msgId = dataModal.exObj_;
            if( [dataModal.status_ isEqualToString:Success_Status] ){//发送留言成功
                //顾问联系人数量刷新代码
                if (_refreshGuwenCountFlag) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ConsultantFreshCount" object:nil];
                }
            }else{
                if([dataModal.code_ isEqualToString:@"401"] ||[dataModal.code_ isEqualToString:@"403"]){//对方未回复或超过2个人
                    if (_messageFrameList.count) {
                        MessageDailogCellFrame *cellFrame = _messageFrameList.lastObject;
                        LeaveMessage_DataModel *leaveMessage = cellFrame.leaveMessage;
                        if ([leaveMessage.code isEqualToString:dataModal.code_]) {//相同的错误连续第二次
                            [tableView_ reloadData];
                            return;
                        }
                    }
                    //                [requestCon_.dataArr_ addObject:_sendLeaveMessage];
                    MessageDailogCellFrame *cellFrame = [[MessageDailogCellFrame alloc]init];
                    cellFrame.leaveMessage = _sendLeaveMessage;
                    [_messageFrameList addObject:cellFrame];
                    [tableView_ reloadData];
                    [self scrollTableToFoot:YES];
                }else{
                    
                }
            }
        }
            break;
        case Request_deleteMsgById:
        {
            Status_DataModal *dataModal = [dataArr objectAtIndex:0];
            _sendLeaveMessage.code = dataModal.code_;
            [BaseUIViewController showAutoDismissSucessView:@"" msg:dataModal.des_];
            if( [dataModal.status_ isEqualToString:Success_Status] ){//发送留言成功
                [tableView_ reloadData];
            }
        }
            break;
        case Request_getShareMessageOther:
        {
            Status_DataModal * dataModal = [dataArr objectAtIndex:0];
            
            if ([dataModal.status_ isEqualToString:Success_Status])
            {
                [BaseUIViewController showAutoDismissSucessView:@"分享成功" msg:nil];
                if ([shareModal.shareType isEqualToString:@"4"])
                {
                    _sendLeaveMessage = [[LeaveMessage_DataModel alloc]init];
                    _sendLeaveMessage.personPic = [Manager getUserInfo].img_;
                    _sendLeaveMessage.messageType = MessageTypeImage;
                    _sendLeaveMessage.imageUrl_ = shareImageUrl;
                    _sendLeaveMessage.isSend = @"1";
//                    _sendLeaveMessage.date = @"刚刚";
                    _sendLeaveMessage.msgId = dataModal.exObj_;
                    [_messageFrameList addObject:_sendLeaveMessage];
                    [tableView_ reloadData];
                    [self scrollTableToFoot:YES];
                }
                else
                {
                    [self creatMessageData:dataModal.exObj_];
                }
//                [self hideShareView:YES];
            }
            else
            {
                [BaseUIViewController showAutoDismissFailView:dataModal.des_ msg:@"请稍后再试"];
            }
        }
            break;
        case Request_UploadPhotoFile:
        {
            Upload_DataModal *modal = dataArr[0];
            NSString *str = @"";
            for (Upload_DataModal *modalOne in modal.pathArr_) {
                if ([modalOne.size_ isEqualToString:@"670"])
                {
                    str = modalOne.path_;
                    break;
                }
            }
            shareImageUrl = [NSString stringWithFormat:@"%@#%@",modal.path_,str];
            if(shareImageUrl.length < 10)
            {
                [BaseUIViewController showAlertViewContent:@"图片上传失败，请稍后再试" toView:nil second:1.0 animated:YES];
                return;
            }
            User_DataModal *user = [Manager getUserInfo];
            NSString *fromUserId = user.userId_;
            NSString *toUserId = _inDataModel.userId;
            
            shareModal = [[ShareMessageModal alloc] init];
            shareModal.shareContent = @"图片";
            shareModal.shareType = @"4";
            shareModal.imageUrl = shareImageUrl;
            
            if (!shareCon) {
                shareCon = [self getNewRequestCon:NO];
            }
            [shareCon getShareMessageWithSend_uid:fromUserId receiveId:toUserId  receiveName:_inDataModel.userIname content:shareModal.shareContent dataModal:shareModal];
        }
            break;
        default:
            break;
    }
}

- (void)errorGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type
{
    [super errorGetData:requestCon code:code type:type];
    switch (type) {
        case Request_UploadPhotoFile:
        {
            [self uploadPhoto];
        }
            break;
    }
    NSLog(@"%d",  code);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark--scrollView Delegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if(scrollView == tableView_){
        [_msgContentTV resignFirstResponder];

        [self hideFaceView:YES];
        [self hideShareView:YES];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _messageFrameList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MessageDailogCellFrame *cellFrame = _messageFrameList[indexPath.row];
    if ([cellFrame isKindOfClass:[LeaveMessage_DataModel class]]) {//留言模型
        LeaveMessage_DataModel *messageModel = (LeaveMessage_DataModel *)cellFrame;
        if (messageModel.messageType == MessageTypeVoice) {
            return 80;
        }else if (messageModel.messageType == MessageTypeShareUser || messageModel.messageType == MessageTypeShareReusme) {//人的分享
            return 118 +20;
        }else if (messageModel.messageType == MessageTypeShareJob || messageModel.messageType == MessageTypeGroup){//职位分享
            return 118 +20;
        }
        else if(messageModel.messageType == MessageTypeLikeArticle || messageModel.messageType == MessageTypeLikeComment || messageModel.messageType == MessageTypeGroupArticle)
        {
            return 160;
        }
        else if(messageModel.messageType == MessageTypeImage)
        {
            return 120;
        }
        else if (messageModel.messageType == MessageTypeQuestioning)
        {
            CGFloat height = 160;
            CGSize size = [messageModel.questionContent sizeNewWithFont:FOURTEENFONT_CONTENT constrainedToSize:CGSizeMake(ScreenWidth-100,100000)];
            height += size.height;
            size = [messageModel.introContent sizeNewWithFont:FOURTEENFONT_CONTENT constrainedToSize:CGSizeMake(ScreenWidth-100,100000)];
            height += size.height;
            size = [messageModel.questionTips sizeNewWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(ScreenWidth-50,100000)];
            height += size.height;
            
            return height + 15;
        }
    }
    
    return cellFrame.height+6;
}

/*
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageDailogCellFrame *cellFrame = _messageFrameList[indexPath.row];
    LeaveMessage_DataModel *messageModel;
    if ([cellFrame isKindOfClass:[LeaveMessage_DataModel class]])
    {
        messageModel = (LeaveMessage_DataModel *)cellFrame;
    }
    if ([cell isKindOfClass:[MessageDailog_ShareLeftCell class]]) {
        MessageDailog_ShareLeftCell *shareLeftCell = (MessageDailog_ShareLeftCell *)cell;
        
        shareLeftCell.messageModel = messageModel;
        shareLeftCell.userBtn.tag = indexPath.row + kTagIdOffSet;
        shareLeftCell.bgBtn.tag = indexPath.row + kTagIdOffSet;
        NSString *time = messageModel.date;
        CGSize size = [time sizeNewWithFont:NINEFONT_TIME];
        CGFloat timeX = (ScreenWidth - size.width)/2;
        
        shareLeftCell.timeLb.frame = CGRectMake(timeX, 10, size.width +8,11);
        [shareLeftCell.userBtn addTarget:self action:@selector(goPersonalCenter:) forControlEvents:UIControlEventTouchUpInside];
        [shareLeftCell.bgBtn addTarget:self action:@selector(bgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [shareLeftCell.bgBtn addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(shareBtnLongPress:)]];
    }
    else if ([cell isKindOfClass:[MessageDailog_ShareRightCell class]]){
        MessageDailog_ShareRightCell *shareRightCell = (MessageDailog_ShareRightCell *)cell;
        
        shareRightCell.messageModel = messageModel;
        NSString *time = messageModel.date;
        CGSize size = [time sizeNewWithFont:NINEFONT_TIME];
        CGFloat timeX = (ScreenWidth - size.width)/2;
        
        shareRightCell.timeLb.frame = CGRectMake(timeX, 10, size.width +8,11);
        shareRightCell.userBtn.tag = indexPath.row + kTagIdOffSet;
        shareRightCell.bgBtn.tag = indexPath.row + kTagIdOffSet;
        [shareRightCell.userBtn addTarget:self action:@selector(goPersonalCenter:) forControlEvents:UIControlEventTouchUpInside];
        [shareRightCell.bgBtn addTarget:self action:@selector(bgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [shareRightCell.bgBtn addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(shareBtnLongPress:)]];
    }
    else if ([cell isKindOfClass:[YLMessageLikeRightCell class]]){
        YLMessageLikeRightCell *likeRightCell = (YLMessageLikeRightCell *)cell;
        likeRightCell.titleImageBtn.tag = indexPath.row + kTagIdOffSet;
        [likeRightCell.titleImageBtn addTarget:self action:@selector(goPersonalCenter:) forControlEvents:UIControlEventTouchUpInside];
        
        likeRightCell.pushArticleBtn.tag = indexPath.row + kTagIdOffSet;
        [likeRightCell.pushArticleBtn addTarget:self action:@selector(pushArticleDetail:) forControlEvents:UIControlEventTouchUpInside];
        [likeRightCell giveDataModal:messageModel];
        [likeRightCell.contentView bringSubviewToFront:likeRightCell.pushArticleBtn];
        [likeRightCell.pushArticleBtn addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(shareBtnLongPress:)]];
        
    }
    else if ([cell isKindOfClass:[YLMessageLikeLeftCell class]]){
        YLMessageLikeLeftCell *likeLeftCell = (YLMessageLikeLeftCell *)cell;
        likeLeftCell.titleImageBtn.tag = indexPath.row + kTagIdOffSet;
        [likeLeftCell.titleImageBtn addTarget:self action:@selector(goPersonalCenter:) forControlEvents:UIControlEventTouchUpInside];
        
        likeLeftCell.pushArticleBtn.tag = indexPath.row + kTagIdOffSet;
        [likeLeftCell.pushArticleBtn addTarget:self action:@selector(pushArticleDetail:) forControlEvents:UIControlEventTouchUpInside];
        [likeLeftCell giveDataModal:messageModel];
        [likeLeftCell.contentView bringSubviewToFront:likeLeftCell.pushArticleBtn];
        [likeLeftCell.pushArticleBtn addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(shareBtnLongPress:)]];
        
    }
    else if ([cell isKindOfClass:[MessageVoiceRightCell class]]){
        MessageVoiceRightCell *voiceRightCell = (MessageVoiceRightCell *)cell;
        [voiceRightCell setLeaveMessage:messageModel];
        [voiceRightCell.voicePlayBtn addTarget:self action:@selector(voicePlayRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        voiceRightCell.voicePlayBtn.tag = indexPath.row + 1000;
        voiceRightCell.fromUserImgv.userInteractionEnabled = YES;
        voiceRightCell.fromUserImgv.tag = kTagIdOffSet + indexPath.row;
        [voiceRightCell.fromUserImgv addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goPersonalCenter:)]];
    }
    else if ([cell isKindOfClass:[MessageVoiceLeftCell class]]){
        MessageVoiceLeftCell *voiceLeftCell = (MessageVoiceLeftCell *)cell;
        [voiceLeftCell setLeaveMessage:messageModel];
        [voiceLeftCell.voicePlayBtn addTarget:self action:@selector(voicePlayLeftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        voiceLeftCell.voicePlayBtn.tag = indexPath.row + 1000;
        voiceLeftCell.toUserImgv.userInteractionEnabled = YES;
        voiceLeftCell.toUserImgv.tag = kTagIdOffSet + indexPath.row;
        [voiceLeftCell.toUserImgv addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goPersonalCenter:)]];
    }
    else if ([cell isKindOfClass:[ELMessageImage_Cell class]]){
        ELMessageImage_Cell *cellImage = (ELMessageImage_Cell *)cell;
        cellImage.cellDelegate = self;
        [cellImage giveDataModal:messageModel];
        cellImage.titleImage.userInteractionEnabled = YES;
        cellImage.titleImage.tag = kTagIdOffSet + indexPath.row;
        [cellImage.titleImage addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goPersonalCenter:)]];
    }
    else if ([cell isKindOfClass:[ELMessageQuestioning_Cell class]]){
        ELMessageQuestioning_Cell *cellImage = (ELMessageQuestioning_Cell *)cell;
        
        [cellImage giveDataModal:messageModel];
        
        cellImage.titleImage.userInteractionEnabled = YES;
        cellImage.titleImage.tag = kTagIdOffSet + indexPath.row;
        cellImage.bgBtnView.tag = kTagIdOffSet + indexPath.row;
        cellImage.backView.userInteractionEnabled = NO;
        [cellImage.titleImage addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goPersonalCenter:)]];
        [cellImage.bgBtnView addTarget:self action:@selector(bgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if ([cell isKindOfClass:[ELMessageQuestionRightCell class]]){
        ELMessageQuestionRightCell *cellImage = (ELMessageQuestionRightCell *)cell;
        
        [cellImage giveDataModal:messageModel];
        
        NSString *time = messageModel.date;
        CGSize size = [time sizeNewWithFont:NINEFONT_TIME];
        CGFloat timeX = (ScreenWidth - size.width)/2;
        
        cellImage.TimeLb.frame = CGRectMake(timeX, 10, size.width +8,11);
        
        cellImage.userBtn.tag = indexPath.row + kTagIdOffSet;
        cellImage.backBtn.tag = indexPath.row + kTagIdOffSet;
        [cellImage.userBtn addTarget:self action:@selector(goPersonalCenter:) forControlEvents:UIControlEventTouchUpInside];
        [cellImage.backBtn addTarget:self action:@selector(bgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cellImage.backBtn addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(shareBtnLongPress:)]];
        
    }
    else if ([cell isKindOfClass:[ELMessageQuestionLeftCell class]]){
        ELMessageQuestionLeftCell *cellImage = (ELMessageQuestionLeftCell *)cell;
        
        [cellImage giveDataModal:messageModel];
        
        NSString *time = messageModel.date;
        CGSize size = [time sizeNewWithFont:NINEFONT_TIME];
        CGFloat timeX = (ScreenWidth - size.width)/2;
        
        cellImage.TimeLb.frame = CGRectMake(timeX, 10, size.width +8,11);
        
        cellImage.userBtn.tag = indexPath.row + kTagIdOffSet;
        cellImage.backBtn.tag = indexPath.row + kTagIdOffSet;
        [cellImage.userBtn addTarget:self action:@selector(goPersonalCenter:) forControlEvents:UIControlEventTouchUpInside];
        [cellImage.backBtn addTarget:self action:@selector(bgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cellImage.backBtn addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(shareBtnLongPress:)]];
    }
    else if ([cell isKindOfClass:[MessageDailogList_Cell2 class]]){
        MessageDailogList_Cell2 *myCell = (MessageDailogList_Cell2 *)cell;
        
        [myCell.fromUserImgv sd_setImageWithURL:[NSURL URLWithString:leaveMessage.personPic]];
        myCell.fromUserImgv.userInteractionEnabled = YES;
        myCell.fromUserImgv.tag = kTagIdOffSet + indexPath.row;
        [myCell.fromUserImgv addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goPersonalCenter:)]];
        
        NSString *text = leaveMessage.content;
        emojiLabel = (MLEmojiLabel *)[myCell.contentBtn viewWithTag:3000 + kTagIdOffSet];
        if (emojiLabel) {
            emojiLabel.emojiText = text;
        }else{
            emojiLabel = [self emojiLabel:text];
            [myCell.contentBtn addSubview:emojiLabel];
        }
        emojiLabel.frame = cellFrame.emojiLabelFrame;
        myCell.contentBtn.frame = cellFrame.contentBtnFrame;
        myCell.fromUserImgv.frame = cellFrame.userImgvFrame;
        myCell.dateLb.frame = cellFrame.timeLbFrame;
        
        [myCell.contentBtn setBackgroundImage:myCell->_contentBgImg forState:UIControlStateNormal];
        
        if (!leaveMessage.date) {
            myCell.dateLb.hidden = YES;
        }else{
            myCell.dateLb.hidden = NO;
            myCell.dateLb.text = leaveMessage.date;
        }
        
        myCell.contentBtn.tag = indexPath.row;
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
        longPress.minimumPressDuration = 0.5; //定义按的时间
        [myCell.contentBtn addGestureRecognizer:longPress];
    }
    else if (cell isKindOfClass:[MessageDailogList_Cell class]){
        MessageDailogList_Cell *fromCell = (MessageDailogList_Cell *)cell;
        
        NSString *text = leaveMessage.content;
        emojiLabel = (MLEmojiLabel *)[fromCell.contentBtn viewWithTag:3000 +kTagIdOffSet];
        if (emojiLabel) {
            emojiLabel.emojiText = text;
        }else{
            emojiLabel = [self emojiLabel:text];
            [fromCell.contentBtn addSubview:emojiLabel];
        }
        emojiLabel.frame = cellFrame.emojiLabelFrame;
        
        [fromCell.toUserImgv sd_setImageWithURL:[NSURL URLWithString:leaveMessage.personPic]];
        fromCell.toUserImgv.userInteractionEnabled = YES;
        fromCell.toUserImgv.tag = kTagIdOffSet + indexPath.row;
        [fromCell.toUserImgv addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goPersonalCenter:)]];
        
        fromCell.contentBtn.frame = cellFrame.contentBtnFrame;
        fromCell.toUserImgv.frame = cellFrame.userImgvFrame;
        fromCell.dateLb.frame = cellFrame.timeLbFrame;
        [fromCell.contentBtn setBackgroundImage:fromCell->_contentBgImg forState:UIControlStateNormal];
        if (!leaveMessage.date) {
            fromCell.dateLb.hidden = YES;
        }else{
            fromCell.dateLb.hidden = NO;
            fromCell.dateLb.text = leaveMessage.date;
        }
        
        fromCell.contentBtn.tag = indexPath.row;
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
        longPress.minimumPressDuration = 0.5; //定义按的时间
        [fromCell.contentBtn addGestureRecognizer:longPress];
        
        if (leaveMessage.messageType == MessageTypeWeiTuo)
        {
            fromCell.resumeBtn.hidden = NO;
            fromCell.resumeBtn.tag = 200+indexPath.row;
            CGRect frame = fromCell.resumeBtn.frame;
            frame.origin.x = cellFrame.contentBtnFrame.origin.x+15;
            frame.origin.y = CGRectGetMaxY(cellFrame.contentBtnFrame)-30;
            fromCell.resumeBtn.frame = frame;
            [fromCell.resumeBtn addTarget:self action:@selector(resumeBtnRespone:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            fromCell.resumeBtn.hidden = YES;
        }

    }
    
    LeaveMessage_DataModel *leaveMessage = cellFrame.leaveMessage;
    if ([leaveMessage.code isEqualToString:@"401"] ||[leaveMessage.code isEqualToString:@"403"])
    {
        UITableViewCell *waiteCell = [[UITableViewCell alloc]init];
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(40, 5, ScreenWidth-80, 30);
        if ([leaveMessage.code isEqualToString:@"401"]) {
            label.text = @"同一用户每天可以留言给五位陌生好友";
        }else{
            label.text = @"等待对方回复，对方回复后畅聊无限";
        }
        label.font = TWEELVEFONT_COMMENT;
        label.backgroundColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        CALayer *layer = label.layer;
        layer.masksToBounds = YES;
        layer.cornerRadius = 15.0;
        [waiteCell.contentView addSubview:label];
        waiteCell.backgroundColor = [UIColor clearColor];
        waiteCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    MessageDailogList_Cell2 *myCell;
    MessageDailogList_Cell *fromCell;
    
    MLEmojiLabel *emojiLabel;
    
}
*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageDailogCellFrame *cellFrame = _messageFrameList[indexPath.row];
    if ([cellFrame isKindOfClass:[LeaveMessage_DataModel class]])
    {//分享 留言模型 //职位分享
        LeaveMessage_DataModel *messageModel = (LeaveMessage_DataModel *)cellFrame;
        
        if (messageModel.messageType == MessageTypeShareUser || messageModel.messageType == MessageTypeShareJob || messageModel.messageType == MessageTypeGroup || messageModel.messageType == MessageTypeShareReusme)
        {//人的分享
            if([messageModel.isSend isEqualToString:@"0"])
            {//对方
                static NSString *shareLeftCellIdentify = @"MessageDailog_ShareLeftCell";
                MessageDailog_ShareLeftCell *shareLeftCell = [tableView dequeueReusableCellWithIdentifier:shareLeftCellIdentify];
                if (shareLeftCell == nil)
                {
                    shareLeftCell = [[[NSBundle mainBundle] loadNibNamed:@"MessageDailog_ShareLeftCell" owner:self options:nil] lastObject];
                }
                shareLeftCell.messageModel = messageModel;
                shareLeftCell.userBtn.tag = indexPath.row + kTagIdOffSet;
                shareLeftCell.bgBtn.tag = indexPath.row + kTagIdOffSet;
                NSString *time = messageModel.date;
                CGSize size = [time sizeNewWithFont:NINEFONT_TIME];
                CGFloat timeX = (ScreenWidth - size.width)/2;
                
                shareLeftCell.timeLb.frame = CGRectMake(timeX, 10, size.width +8,11);
                [shareLeftCell.userBtn addTarget:self action:@selector(goPersonalCenter:) forControlEvents:UIControlEventTouchUpInside];
                [shareLeftCell.bgBtn addTarget:self action:@selector(bgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [shareLeftCell.bgBtn addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(shareBtnLongPress:)]];
                return shareLeftCell;
            }
            else if([messageModel.isSend isEqualToString:@"1"])
            {//ziji
                static NSString *shareRightCellIdentify = @"MessageDailog_ShareRightCell";
                MessageDailog_ShareRightCell *shareRightCell = [tableView dequeueReusableCellWithIdentifier:shareRightCellIdentify];
                if (shareRightCell == nil) {
                    shareRightCell = [[[NSBundle mainBundle] loadNibNamed:@"MessageDailog_ShareRightCell" owner:self options:nil] lastObject];
                }
                shareRightCell.messageModel = messageModel;
                NSString *time = messageModel.date;
                CGSize size = [time sizeNewWithFont:NINEFONT_TIME];
                CGFloat timeX = (ScreenWidth - size.width)/2;
                
                shareRightCell.timeLb.frame = CGRectMake(timeX, 10, size.width +8,11);
                shareRightCell.userBtn.tag = indexPath.row + kTagIdOffSet;
                shareRightCell.bgBtn.tag = indexPath.row + kTagIdOffSet;
                [shareRightCell.userBtn addTarget:self action:@selector(goPersonalCenter:) forControlEvents:UIControlEventTouchUpInside];
                [shareRightCell.bgBtn addTarget:self action:@selector(bgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [shareRightCell.bgBtn addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(shareBtnLongPress:)]];
                return shareRightCell;
            }
        }
        else if (messageModel.messageType == MessageTypeLikeComment || messageModel.messageType == MessageTypeLikeArticle|| messageModel.messageType == MessageTypeGroupArticle )//赞了评论,文章
        {
            if ([messageModel.isSend isEqualToString:@"1"]) {
                static NSString *CellIdentifier = @"YLMessageLikeRightCell";
                YLMessageLikeRightCell *cell = (YLMessageLikeRightCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"YLMessageLikeRightCell" owner:self options:nil] lastObject];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                }
                cell.titleImageBtn.tag = indexPath.row + kTagIdOffSet;
                [cell.titleImageBtn addTarget:self action:@selector(goPersonalCenter:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.pushArticleBtn.tag = indexPath.row + kTagIdOffSet;
                [cell.pushArticleBtn addTarget:self action:@selector(pushArticleDetail:) forControlEvents:UIControlEventTouchUpInside];
                [cell giveDataModal:messageModel];
                [cell.contentView bringSubviewToFront:cell.pushArticleBtn];
                [cell.pushArticleBtn addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(shareBtnLongPress:)]];
                return cell;
            }
            else if([messageModel.isSend isEqualToString:@"0"])
            {
                static NSString *CellIdentifier = @"YLMessageLikeLeftCell";
                YLMessageLikeLeftCell *cell = (YLMessageLikeLeftCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"YLMessageLikeLeftCell" owner:self options:nil] lastObject];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                }
                cell.titleImageBtn.tag = indexPath.row + kTagIdOffSet;
                [cell.titleImageBtn addTarget:self action:@selector(goPersonalCenter:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.pushArticleBtn.tag = indexPath.row + kTagIdOffSet;
                [cell.pushArticleBtn addTarget:self action:@selector(pushArticleDetail:) forControlEvents:UIControlEventTouchUpInside];
                [cell giveDataModal:messageModel];
                [cell.contentView bringSubviewToFront:cell.pushArticleBtn];
                [cell.pushArticleBtn addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(shareBtnLongPress:)]];
                return cell;
            }
        }
        else if (messageModel.messageType == MessageTypeVoice)
        {
            if ([messageModel.isSend isEqualToString:@"1"])
            {
                static NSString *CellIdentifier = @"MessageVoiceRightCell";
                MessageVoiceRightCell *voiceRightCell = (MessageVoiceRightCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (voiceRightCell == nil) {
                    voiceRightCell = [[[NSBundle mainBundle] loadNibNamed:@"MessageVoiceRightCell" owner:self options:nil] lastObject];
                    [voiceRightCell setAttr];
                }
                [voiceRightCell setLeaveMessage:messageModel];
                [voiceRightCell.voicePlayBtn addTarget:self action:@selector(voicePlayRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                voiceRightCell.voicePlayBtn.tag = indexPath.row + 1000;
                voiceRightCell.fromUserImgv.userInteractionEnabled = YES;
                voiceRightCell.fromUserImgv.tag = kTagIdOffSet + indexPath.row;
                [voiceRightCell.fromUserImgv addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goPersonalCenter:)]];
                return voiceRightCell;
            }else{
                //
                static NSString *CellIdentifier = @"MessageVoiceLeftCell";
                MessageVoiceLeftCell *voiceLeftCell = (MessageVoiceLeftCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (voiceLeftCell == nil) {
                    voiceLeftCell = [[[NSBundle mainBundle] loadNibNamed:@"MessageVoiceLeftCell" owner:self options:nil] lastObject];
                    [voiceLeftCell setAttr];
                }
                [voiceLeftCell setLeaveMessage:messageModel];
                [voiceLeftCell.voicePlayBtn addTarget:self action:@selector(voicePlayLeftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                voiceLeftCell.voicePlayBtn.tag = indexPath.row + 1000;
                voiceLeftCell.toUserImgv.userInteractionEnabled = YES;
                voiceLeftCell.toUserImgv.tag = kTagIdOffSet + indexPath.row;
                [voiceLeftCell.toUserImgv addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goPersonalCenter:)]];
                return voiceLeftCell;
            }
        }
        else if(messageModel.messageType == MessageTypeImage)
        {
            static NSString *cellImageStr = @"ELMessageImageCell";
            ELMessageImage_Cell *cellImage = [tableView dequeueReusableCellWithIdentifier:cellImageStr];
            if (cellImage == nil) {
                cellImage = [[ELMessageImage_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellImageStr];
                [cellImage setSelectionStyle:UITableViewCellSelectionStyleNone];
                cellImage.nameLb.hidden = YES;
            }
            cellImage.cellDelegate = self;
            [cellImage giveDataModal:messageModel];
            cellImage.titleImage.userInteractionEnabled = YES;
            cellImage.titleImage.tag = kTagIdOffSet + indexPath.row;
            [cellImage.titleImage addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goPersonalCenter:)]];
            return cellImage;
        }
        else if (messageModel.messageType == MessageTypeQuestioning)
        {
            if (messageModel.aspDiscuss.recordId == nil || [messageModel.aspDiscuss.recordId isEqualToString:@""]) {
                
                static NSString *cellImageStr = @"ELMessageQuestioning_Cell";
                ELMessageQuestioning_Cell *cellImage = [tableView dequeueReusableCellWithIdentifier:cellImageStr];
                if (cellImage == nil) {
                    cellImage = [[ELMessageQuestioning_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellImageStr];
                    [cellImage setSelectionStyle:UITableViewCellSelectionStyleNone];
                    cellImage.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
                }
                [cellImage giveDataModal:messageModel];
                
                cellImage.titleImage.userInteractionEnabled = YES;
                cellImage.titleImage.tag = kTagIdOffSet + indexPath.row;
                cellImage.bgBtnView.tag = kTagIdOffSet + indexPath.row;
                cellImage.backView.userInteractionEnabled = NO;
                [cellImage.titleImage addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goPersonalCenter:)]];
                [cellImage.bgBtnView addTarget:self action:@selector(bgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                return cellImage;
            }
            else
            {
                if ([messageModel.isSend isEqualToString:@"1"]) {
                    
                    static NSString *cellImageStr = @"ELMessageQuestionRightCell";
                    ELMessageQuestionRightCell *cellImage = (ELMessageQuestionRightCell *)[tableView dequeueReusableCellWithIdentifier:cellImageStr];
                    if (cellImage == nil) {
                        cellImage = [[[NSBundle mainBundle] loadNibNamed:@"ELMessageQuestionRightCell" owner:self options:nil] lastObject];
                        [cellImage setSelectionStyle:UITableViewCellSelectionStyleNone];
                        cellImage.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
                    }
                    [cellImage giveDataModal:messageModel];
                    
                    NSString *time = messageModel.date;
                    CGSize size = [time sizeNewWithFont:NINEFONT_TIME];
                    CGFloat timeX = (ScreenWidth - size.width)/2;
                    
                    cellImage.TimeLb.frame = CGRectMake(timeX, 10, size.width +8,11);
                    
                    cellImage.userBtn.tag = indexPath.row + kTagIdOffSet;
                    cellImage.backBtn.tag = indexPath.row + kTagIdOffSet;
                    [cellImage.userBtn addTarget:self action:@selector(goPersonalCenter:) forControlEvents:UIControlEventTouchUpInside];
                    [cellImage.backBtn addTarget:self action:@selector(bgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cellImage.backBtn addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(shareBtnLongPress:)]];
                    
                    return cellImage;
                }
                else if ([messageModel.isSend isEqualToString:@"0"])
                {
                    static NSString *cellImageStr = @"ELMessageQuestionLeftCell";
                    ELMessageQuestionLeftCell *cellImage = (ELMessageQuestionLeftCell *)[tableView dequeueReusableCellWithIdentifier:cellImageStr];
                    if (cellImage == nil) {
                        cellImage = [[[NSBundle mainBundle] loadNibNamed:@"ELMessageQuestionLeftCell" owner:self options:nil] lastObject];
                        [cellImage setSelectionStyle:UITableViewCellSelectionStyleNone];
                        cellImage.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
                    }
                    [cellImage giveDataModal:messageModel];
                    
                    NSString *time = messageModel.date;
                    CGSize size = [time sizeNewWithFont:NINEFONT_TIME];
                    CGFloat timeX = (ScreenWidth - size.width)/2;
                    
                    cellImage.TimeLb.frame = CGRectMake(timeX, 10, size.width +8,11);
                    
                    cellImage.userBtn.tag = indexPath.row + kTagIdOffSet;
                    cellImage.backBtn.tag = indexPath.row + kTagIdOffSet;
                    [cellImage.userBtn addTarget:self action:@selector(goPersonalCenter:) forControlEvents:UIControlEventTouchUpInside];
                    [cellImage.backBtn addTarget:self action:@selector(bgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cellImage.backBtn addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(shareBtnLongPress:)]];
                    
                    return cellImage;
                }
            }
            
        }
    }
    
    LeaveMessage_DataModel *leaveMessage = cellFrame.leaveMessage;
    if ([leaveMessage.code isEqualToString:@"401"] ||[leaveMessage.code isEqualToString:@"403"])
    {
        UITableViewCell *waiteCell = [[UITableViewCell alloc]init];
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(40, 5, ScreenWidth-80, 30);
        if ([leaveMessage.code isEqualToString:@"401"]) {
            label.text = @"同一用户每天可以留言给五位陌生好友";
        }else{
            label.text = @"等待对方回复，对方回复后畅聊无限";
        }
        label.font = TWEELVEFONT_COMMENT;
        label.backgroundColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        CALayer *layer = label.layer;
        layer.masksToBounds = YES;
        layer.cornerRadius = 15.0;
        [waiteCell.contentView addSubview:label];
        waiteCell.backgroundColor = [UIColor clearColor];
        waiteCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return waiteCell;
    }
    
    static NSString *CellFromIdentify = @"Cell1";
    static NSString *MyCellIdentify = @"Cell2";
    
    MessageDailogList_Cell2 *myCell;
    MessageDailogList_Cell *fromCell;
    
    MLEmojiLabel *emojiLabel;
    
    if ([leaveMessage.isSend isEqualToString:@"1"])
    {
        //自己
        myCell = [tableView dequeueReusableCellWithIdentifier:MyCellIdentify];
        if (myCell == nil) {
            myCell = [[[NSBundle mainBundle] loadNibNamed:@"MessageDailogList_Cell2" owner:self options:nil] lastObject];
            myCell.nameLb.hidden = YES;
            [myCell setAttr];
        }
        [myCell.fromUserImgv sd_setImageWithURL:[NSURL URLWithString:leaveMessage.personPic]];
        myCell.fromUserImgv.userInteractionEnabled = YES;
        myCell.fromUserImgv.tag = kTagIdOffSet + indexPath.row;
        [myCell.fromUserImgv addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goPersonalCenter:)]];
        
        NSString *text = leaveMessage.content;
        emojiLabel = (MLEmojiLabel *)[myCell.contentBtn viewWithTag:3000 + kTagIdOffSet];
        if (emojiLabel) {
            emojiLabel.emojiText = text;
        }else{
            emojiLabel = [self emojiLabel:text];
            [myCell.contentBtn addSubview:emojiLabel];
        }
        emojiLabel.frame = cellFrame.emojiLabelFrame;
        myCell.contentBtn.frame = cellFrame.contentBtnFrame;
        myCell.fromUserImgv.frame = cellFrame.userImgvFrame;
        myCell.dateLb.frame = cellFrame.timeLbFrame;
        
        [myCell.contentBtn setBackgroundImage:myCell->_contentBgImg forState:UIControlStateNormal];

        if (!leaveMessage.date) {
            myCell.dateLb.hidden = YES;
        }else{
            myCell.dateLb.hidden = NO;
            myCell.dateLb.text = leaveMessage.date;
        }
        
        myCell.contentBtn.tag = indexPath.row;
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
        longPress.minimumPressDuration = 0.5; //定义按的时间
        [myCell.contentBtn addGestureRecognizer:longPress];
        
        return myCell;
    }
    else{
        fromCell = [tableView dequeueReusableCellWithIdentifier:CellFromIdentify];
        if (fromCell == nil) {
            fromCell = [[[NSBundle mainBundle] loadNibNamed:@"MessageDailogList_Cell" owner:self options:nil] lastObject];
            fromCell.nameLb.hidden = YES;
            [fromCell setAttr];
        }
        NSString *text = leaveMessage.content;
        emojiLabel = (MLEmojiLabel *)[fromCell.contentBtn viewWithTag:3000 +kTagIdOffSet];
        if (emojiLabel) {
            emojiLabel.emojiText = text;
        }else{
            emojiLabel = [self emojiLabel:text];
            [fromCell.contentBtn addSubview:emojiLabel];
        }
        emojiLabel.frame = cellFrame.emojiLabelFrame;
        
        [fromCell.toUserImgv sd_setImageWithURL:[NSURL URLWithString:leaveMessage.personPic]];
        fromCell.toUserImgv.userInteractionEnabled = YES;
        fromCell.toUserImgv.tag = kTagIdOffSet + indexPath.row;
        [fromCell.toUserImgv addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goPersonalCenter:)]];
        
        fromCell.contentBtn.frame = cellFrame.contentBtnFrame;
        fromCell.toUserImgv.frame = cellFrame.userImgvFrame;
        fromCell.dateLb.frame = cellFrame.timeLbFrame;
        [fromCell.contentBtn setBackgroundImage:fromCell->_contentBgImg forState:UIControlStateNormal];
        if (!leaveMessage.date) {
            fromCell.dateLb.hidden = YES;
        }else{
            fromCell.dateLb.hidden = NO;
           fromCell.dateLb.text = leaveMessage.date;
        }
        
        
        fromCell.contentBtn.tag = indexPath.row;
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
        longPress.minimumPressDuration = 0.5; //定义按的时间
        [fromCell.contentBtn addGestureRecognizer:longPress];
        
        if (leaveMessage.messageType == MessageTypeWeiTuo)
        {
            fromCell.resumeBtn.hidden = NO;
            fromCell.resumeBtn.tag = 200+indexPath.row;
            CGRect frame = fromCell.resumeBtn.frame;
            frame.origin.x = cellFrame.contentBtnFrame.origin.x+15;
            frame.origin.y = CGRectGetMaxY(cellFrame.contentBtnFrame)-30;
            fromCell.resumeBtn.frame = frame;
            [fromCell.resumeBtn addTarget:self action:@selector(resumeBtnRespone:) forControlEvents:UIControlEventTouchUpInside];

        }
        else
        {
            fromCell.resumeBtn.hidden = YES;
        }
        return fromCell;
    }
}

-(void)resumeBtnRespone:(UIButton *)sender
{
    MessageDailogCellFrame *cellFrame = _messageFrameList[sender.tag-200];
    LeaveMessage_DataModel *modal = cellFrame.leaveMessage;
    
    ShareMessageModal * dataModal = [[ShareMessageModal alloc]init];
    dataModal.personId = modal.client_user_id;
    dataModal.personName = modal.personIName;
    dataModal.person_pic = modal.personPic;
    
    ResumePreviewController *resumeCtl = [[ResumePreviewController alloc] init];
    resumeCtl.showTranspontResumeBtn = YES;
    [self.navigationController pushViewController:resumeCtl animated:YES];
    [resumeCtl beginLoad:dataModal exParam:nil];
}

-(void)btnLong:(UILongPressGestureRecognizer *)sender
{
    [_editorBtn removeFromSuperview];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        UIButton *btn = (UIButton *)sender.view;
        UITableViewCell *cell = (UITableViewCell *)[btn superview];
        CGRect frame = btn.frame;
        CGRect rect1 = [cell convertRect:frame toView:self.view];
        
        CGRect copyFrame = _delCopyImgv.frame;
        copyFrame.origin.x = rect1.origin.x + rect1.size.width/2 - copyFrame.size.width/2;
        copyFrame.origin.y = rect1.origin.y - _delCopyImgv.frame.size.height;
        if (copyFrame.origin.y<0) {
            copyFrame.origin.y = 0;
        }
        _delCopyImgv.frame = copyFrame;
        _delCopyImgv.tag = sender.view.tag;
        [self.view addSubview:_delCopyImgv];
        [self.view bringSubviewToFront:_delCopyImgv];
        
        if (!copyTap) {
            copyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeCopyBtn:)];
            copyTap.numberOfTapsRequired = 1;
        }
        [tableView_ addGestureRecognizer:copyTap];
    }
}


#pragma mark 分享长按手势删除
- (void)shareBtnLongPress:(UILongPressGestureRecognizer *)sender
{
    [_delCopyImgv removeFromSuperview];
    
    id frame = _messageFrameList[sender.view.tag - kTagIdOffSet];
    if ([frame isKindOfClass:[MessageDailogCellFrame class]])
    {
        MessageDailogCellFrame *frameOne = (MessageDailogCellFrame *)frame;
        if (frameOne.leaveMessage.msgId.length == 0) {
            return;
        }
    }
    else if ([frame isKindOfClass:[LeaveMessage_DataModel class]])
    {
        LeaveMessage_DataModel *modal = (LeaveMessage_DataModel *)frame;
        if (modal.msgId.length == 0) {
            return;
        }
    }
    
    if (sender.state == UIGestureRecognizerStateBegan) {//开始长按
        UIView *bgBtn = (UIView *)sender.view;
        UIView *superView = [bgBtn superview];
        CGPoint point = [sender locationInView:superView];
        if (!_editorBtn) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.bounds = CGRectMake(0, 0, 64, 40);
            [btn setTitle:@"删除" forState:UIControlStateNormal];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 7, 0)];
            btn.titleLabel.font = FOURTEENFONT_CONTENT;
            [btn setBackgroundImage:[UIImage imageNamed:@"longpress_editor.png"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(deleteMsg:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = bgBtn.tag - kTagIdOffSet;
            btn.center = point;
            [superView addSubview:btn];
            [_editorBtn removeFromSuperview];
            _editorBtn = btn;
        }else{
            _editorBtn.tag = bgBtn.tag - kTagIdOffSet;
            _editorBtn.center = point;
            [_editorBtn removeFromSuperview];
            [superView addSubview:_editorBtn];
        }
        
    }
}

-(void)removeCopyBtn:(UITapGestureRecognizer *)sender
{
    [_delCopyImgv removeFromSuperview];
    [_editorBtn removeFromSuperview];
    copyTap = nil;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    tableViewSet = scrollView.contentOffset;
    
    [_delCopyImgv removeFromSuperview];
    [_editorBtn removeFromSuperview];
    [super scrollViewDidScroll:scrollView];
    
}

- (void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
}

- (MLEmojiLabel *)emojiLabel:(NSString *)text numberOfLines:(int)num textColor:(UIColor *)color textFont:(UIFont *)font
{
    MLEmojiLabel * emojiLabel;
    emojiLabel = [[MLEmojiLabel alloc]init];
    emojiLabel.numberOfLines = num;
    emojiLabel.font = font;
    if (color) {
        emojiLabel.textColor = color;
    }
    emojiLabel.backgroundColor = [UIColor clearColor];
    emojiLabel.lineBreakMode = NSLineBreakByCharWrapping;
    emojiLabel.isNeedAtAndPoundSign = YES;
    emojiLabel.customEmojiRegex = Custom_Emoji_Regex;
    emojiLabel.customEmojiPlistName = @"emoticons.plist";
    [emojiLabel setEmojiText:text];
    return emojiLabel;
}

-(void)pushArticleDetail:(UIButton *)sender
{
    LeaveMessage_DataModel *dataModal = _messageFrameList[sender.tag - kTagIdOffSet];
    Article_DataModal *modalOne = dataModal.otherModel;
    Article_DataModal * article = [[Article_DataModal alloc] init];
    ArticleDetailCtl * detailCtl = [[ArticleDetailCtl alloc] init];
    if (dataModal.messageType == MessageTypeLikeComment) {
        article.id_ = modalOne.id_;
        article.title_ = modalOne.title_;
        detailCtl.bScrollToComment_ = YES;
    }
    else if (dataModal.messageType == MessageTypeLikeArticle || dataModal.messageType == MessageTypeGroupArticle)
    {
        article.id_ = modalOne.id_;
        article.title_ = modalOne.title_;
        detailCtl.bScrollToComment_ = NO;
    }
    detailCtl.isFromGroup_ = YES;
    [self.navigationController pushViewController:detailCtl animated:YES];
    [detailCtl beginLoad:article exParam:nil];
}


#pragma mark 点击分享的信息，调转到分享的详情
- (void)bgBtnClick:(UIButton *)sender
{
    NSInteger index = sender.tag - kTagIdOffSet;
    LeaveMessage_DataModel *messageModel = _messageFrameList[index];
    if (messageModel.messageType == MessageTypeShareUser) {//名片分享
        User_DataModal *userModel = messageModel.otherModel;
        ELPersonCenterCtl *personCenterCtl = [[ELPersonCenterCtl alloc] init];
        personCenterCtl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:personCenterCtl animated:NO];
        [personCenterCtl beginLoad:userModel.userId_ exParam:nil];
    }else if (messageModel.messageType == MessageTypeShareJob) {//分享职位
        PositionDetailCtl *detailCtl = [[PositionDetailCtl alloc] init];
        detailCtl.type_ = 1;
        detailCtl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailCtl animated:YES];
        [detailCtl beginLoad:messageModel.otherModel exParam:nil];
        return;
    }
    else if(messageModel.messageType == MessageTypeGroup)
    {
        ELGroupDetailCtl *detaliCtl = [[ELGroupDetailCtl alloc]init];
        detaliCtl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detaliCtl animated:YES];
        [detaliCtl beginLoad:messageModel.otherModel exParam:nil];
    }
    else if (messageModel.messageType == MessageTypeQuestioning)
    {
        if (messageModel.aspDiscuss.recordId == nil || [messageModel.aspDiscuss.recordId isEqualToString:@""]) {
            ELMyAspectantDiscussCtl *myAspDisCtl = [[ELMyAspectantDiscussCtl alloc] init];
            myAspDisCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myAspDisCtl animated:YES];
            [myAspDisCtl beginLoad:nil exParam:nil];
        }
        else
        {
            ELMyAspectantDiscussCtl *aspDetailtCtl = [[ELMyAspectantDiscussCtl alloc] init];
            aspDetailtCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aspDetailtCtl animated:YES];
            [aspDetailtCtl beginLoad:messageModel.aspDiscuss exParam:nil];
        }
    }
    else if (messageModel.messageType == MessageTypeShareReusme)//简历
    {
        ResumePreviewController *resumePreview = [[ResumePreviewController alloc]init];
        resumePreview.showTranspontResumeBtn = YES;
        resumePreview.hidesBottomBarWhenPushed = YES;
        resumePreview.formMessage = YES;
        [self.navigationController pushViewController:resumePreview animated:YES];
        [resumePreview beginLoad:messageModel.otherModel exParam:nil];
    }
}

//自己视图的单击事件
-(void) viewSingleTap:(id)sender
{
    [self hideFaceView:YES];
    [_msgContentTV resignFirstResponder];
    [self hideShareView:YES];
//    [self scrollTableToFoot:YES];
}

-(void)hideShareView:(BOOL)toolBar
{
    isShareViewShow = NO;
    CGRect frameOne = shareAddView.frame;
    frameOne.origin.y = [UIScreen mainScreen].bounds.size.height - 64;
    shareAddView.frame = frameOne;
    
    frameOne = _msgContentView.frame;
    frameOne.origin.y = [UIScreen mainScreen].bounds.size.height - 64 - frameOne.size.height;
    if (!_faceScrollView.isShow && !_isKeyboardShow && toolBar)
    {
        [UIView animateWithDuration:0.26 animations:^{
//            tableView_.contentInset = UIEdgeInsetsZero;
            CGRect rect = tableView_.frame;
            rect.size.height = ScreenHeight-rect.origin.y-104;
            tableView_.frame = rect;
            _msgContentView.frame = frameOne;
        }];
    }
    
    [MyCommon removeTapGesture:tableView_ ges:_singleTapRecognizer];
    _singleTapRecognizer = nil;
    shareAddBtn.selected = NO;
}

-(void)hideKeyBord
{
    [self viewSingleTap:nil];
}

-(void)mykeyboardWillShow:(NSNotification *)notification
{
    _faceScrollView.isShow = NO;
    isShareViewShow = NO;
    //    isHideMethod_ = NO;
    _isKeyboardShow = YES;
    //停止scrollview的滚动
    [tableView_ setContentOffset:tableView_.contentOffset animated:YES];
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    _keyboardHeight = keyboardRect.size.height;
    
    _faceBtn.selected = NO;
    CGRect newFrame = self.view.frame;
    [UIView animateWithDuration:animationDuration animations:^{
        self.view.frame = newFrame;
    }];
    
    CGRect newTextViewFrame = _msgContentView.frame;
    if (IOS7) {
        newTextViewFrame.origin.y = [UIScreen mainScreen].bounds.size.height - keyboardRect.size.height - newTextViewFrame.size.height-20 -44;
    }else{
        newTextViewFrame.origin.y = [UIScreen mainScreen].bounds.size.height - keyboardRect.size.height - newTextViewFrame.size.height-20 -44;
    }
    [UIView animateWithDuration:animationDuration animations:^{
        _msgContentView.frame = newTextViewFrame;
    }];
    
    //添加点击事件
    if (!_singleTapRecognizer) {
        _singleTapRecognizer = [MyCommon addTapGesture:tableView_ target:self numberOfTap:1 sel:@selector(viewSingleTap:)];
    }
    
   
    //滚动内容
    if (_messageFrameList.count) {
        CGRect rect = tableView_.frame;
        rect.size.height = ScreenHeight-104-rect.origin.y-keyboardRect.size.height;
        tableView_.frame = rect;
        
//        rect.size.height -= keyboardRect.size.height;
        
//        tableView_.contentInset = UIEdgeInsetsMake(0, 0, keyboardRect.size.height, 0);
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(_messageFrameList.count - 1) inSection:0];
        [tableView_ scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
     
    }
    
    shareAddBtn.selected = NO;
    [self changeTextViewFrame];
}

-(void)mykeyboardWillHide:(NSNotification *)notification
{
    [MyCommon removeTapGesture:tableView_ ges:_singleTapRecognizer];
//    _singleTapRecognizer = nil;
    _isKeyboardShow = NO;
    
    CGRect newTextViewFrame = _msgContentView.frame;
    newTextViewFrame.origin.y = self.view.frame.size.height -newTextViewFrame.size.height;
    
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    CGRect rect = tableView_.frame;
    if (!isShareViewShow && !_faceScrollView.isShow)
    {
//        tableView_.contentInset = UIEdgeInsetsZero;
        if (rect.size.height != ScreenHeight - rect.origin.y - 104) {
            
           rect.size.height += _keyboardHeight;
            tableView_.frame = rect;
            
        }
        _msgContentView.frame = newTextViewFrame;
//        [self hideFaceView:YES];
//        [self hideShareView:YES];
        [self viewSingleTap:nil];
        
    }
    
    [UIView commitAnimations];
}

//显示表情
- (void)showFaceView {
    //添加点击事件
    if( !_singleTapRecognizer )
        _singleTapRecognizer = [MyCommon addTapGesture:tableView_ target:self numberOfTap:1 sel:@selector(viewSingleTap:)];
    //    tableView_.contentInset = UIEdgeInsetsZero;
    if (_faceScrollView == nil) {
        [self initFaceView];
    }
    
    _faceScrollView.isShow = YES;
    _faceBtn.selected = YES;
    CGFloat faceBoardH = CGRectGetHeight(_faceScrollView.frame) ;
    //滚动内容
    if (_messageFrameList.count) {
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect rect = tableView_.frame;
            rect.size.height = ScreenHeight-104-rect.origin.y-faceBoardH;
            tableView_.frame = rect;
//            tableView_.contentInset = UIEdgeInsetsMake(0, 0, faceBoardH, 0);
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(_messageFrameList.count - 1) inSection:0];
            [tableView_ scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }];
    }
    
    shareAddBtn.selected = NO;
    CGRect frameOne = shareAddView.frame;
    frameOne.origin.y = [UIScreen mainScreen].bounds.size.height - 64;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGFloat y = CGRectGetHeight(self.view.bounds) - faceBoardH;
        CGRect frame = _faceScrollView.frame;
        frame.origin.y = y;
        _faceScrollView.frame = frame;
        
        CGRect frame2 = _msgContentView.frame;
        frame2.origin.y = y-frame2.size.height;
        _msgContentView.frame = frame2;
        
        shareAddView.frame = frameOne;
    } completion:^(BOOL finished) {
        
    }];
    isShareViewShow = NO;
    
    [self changeTextViewFrame];
}

- (void)initFaceView
{
    if (_faceScrollView == nil) {
        __weak MessageDailogListCtl *this = self;
        _faceScrollView = [[FaceScrollView alloc] initWithBlock:^(NSString *faceName) {
            if ([faceName isEqualToString:@"delete"]) {
                NSString *text = this.msgContentTV.text;
                if (!text || [text isEqualToString:@""]) {
                    return ;
                }
                NSString *result = [MyCommon substringExceptLastEmoji:text];
                if (![text isEqualToString:result]) {
                    this.msgContentTV.text = result;
                }else{
                    this.msgContentTV.text = [text substringToIndex:text.length-1];
                }
                [self changeTextViewFrame];
                return;
            }
            NSString *temp = this.msgContentTV.text;
            this.msgContentTV.text = [temp stringByAppendingFormat:@"%@", faceName];
            [self changeTextViewFrame];
        }];
        _faceScrollView.backgroundColor = [UIColor whiteColor];
        _faceScrollView->faceView.backgroundColor = [UIColor whiteColor];
        _faceScrollView.frame = CGRectMake(0, self.view.bounds.size.height, 0, 0);
        
        [sendBtn removeFromSuperview];
        sendBtn.clipsToBounds = YES;
        sendBtn.layer.cornerRadius = 4.0;
        CGRect frame = sendBtn.frame;
        frame.origin.x = _faceScrollView.frame.size.width - frame.size.width - 3;
        frame.origin.y = _faceScrollView.frame.size.height - frame.size.height - 3;
        sendBtn.frame = frame;
        [_faceScrollView addSubview:sendBtn];
        [_faceScrollView bringSubviewToFront:sendBtn];
        
        [self.view addSubview:_faceScrollView];
    }
}


//隐藏表情,是否隐藏工具栏
- (void)hideFaceView:(BOOL)hideToolBar
{
    [MyCommon removeTapGesture:tableView_ ges:_singleTapRecognizer];
    _singleTapRecognizer = nil;
    _faceScrollView.isShow = NO;
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat y = CGRectGetHeight(self.view.bounds);
        CGRect frame = _faceScrollView.frame;
        frame.origin.y = y;
        _faceScrollView.frame = frame;
        
        //工具栏
        if (hideToolBar ) {
            CGRect frame2 = _msgContentView.frame;
            frame2.origin.y = y-frame2.size.height;
            _msgContentView.frame = frame2;
//            tableView_.contentInset = UIEdgeInsetsZero;
            CGRect  rect = tableView_.frame;
            if (rect.size.height != ScreenHeight - rect.origin.y - 104) {
                rect.size.height += _faceScrollView.frame.size.height;
                tableView_.frame = rect;
            }
            
            
        }
    }];
    _faceBtn.selected = NO;
}

#pragma mark - textViewdelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _faceBtn.selected = NO;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([MyCommon stringContainsEmoji:textView.text])
    {
        [BaseUIViewController showAutoDismissFailView:@"提示" msg:@"当前不支持输入法自带表情" seconds:2.0];
        return;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [self sendMsgBtnClick:nil];
        return NO;
    }
    
    NSString *content = textView.text;
    if(range.length == 1 && [text isEqualToString:@""]) {
        NSString *result = [MyCommon substringExceptLastEmoji:content];
        if (![content isEqualToString:result]) {
            textView.text = result;
            [self changeTextViewFrame];
            return NO;
        }
    }
    return YES;
}

#pragma mark -留言推送消息处理
- (void)receiveNewMessageDetailList:(NSNotification *)info
{
    NSDictionary *msgDic = info.object;
    if (msgDic) {
        NSInteger type = [msgDic[@"msg_type"] integerValue];
        if([_messageFrameList isKindOfClass:[NSMutableArray class]]){
            if (_messageFrameList.count > 0) {
                MessageDailogCellFrame *cellFrame = [_messageFrameList lastObject];
                LeaveMessage_DataModel *leaveMessage;
                if ([cellFrame isKindOfClass:[LeaveMessage_DataModel class]]){
                    leaveMessage = (LeaveMessage_DataModel *)cellFrame;
                }else{
                    leaveMessage = cellFrame.leaveMessage;
                }
                receiveMessageId = leaveMessage.msgId;
            }
        }
        
        if ([_inDataModel.userId isEqualToString:msgDic[@"send_person_id"]])
        {
            if (type == 3 || type == 2) {//分享
                LeaveMessage_DataModel *dataModel = [[LeaveMessage_DataModel alloc]initWithShareDictionary:msgDic];
                dataModel.isSend = @"0";
                if (receiveMessageId.length > 0)
                {
                    if ([receiveMessageId isEqualToString:dataModel.msgId]) {
                        return;
                    }
                }
                [_messageFrameList addObject:dataModel];
                
                receiveMessageId = dataModel.msgId;
            }
            else
            {
                //文本消息
                LeaveMessage_DataModel *dataModel = [[LeaveMessage_DataModel alloc]initWithTextDictionary:msgDic];
                NSString *tempNameStr = [NSString stringWithFormat:@"%@:",msgDic[@"person_iname"]];
                NSString *tempStr = [[msgDic[@"content"] componentsSeparatedByString:tempNameStr]lastObject];
                dataModel.content = tempStr;
                dataModel.isSend = @"0";
                if (receiveMessageId.length > 0)
                {
                    if ([receiveMessageId isEqualToString:dataModel.msgId]) {
                        return;
                    }
                }
                MessageDailogCellFrame *cellFrame = [[MessageDailogCellFrame alloc]init];
                cellFrame.leaveMessage = dataModel;
                [_messageFrameList addObject:cellFrame];
                
                receiveMessageId = dataModel.msgId;
            }
            [tableView_ reloadData];
            [self scrollTableToFoot:YES];
        }
        [Manager shareMgr].messageCountDataModal.messageCnt = 0;
    }
    
//    [[Manager shareMgr].tabView_ setTabBarNewMessage];
}

- (void)scrollTableToFoot:(BOOL)animated {
    NSInteger s = [tableView_ numberOfSections];
    if (s<1) return;
    NSInteger r = [tableView_ numberOfRowsInSection:s-1];
    if (r<1) return;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];
    [tableView_ scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

#pragma mark 留言
- (IBAction)sendMsgBtnClick:(id)sender
{
    if(![MyCommon IsEnable3G] && ![MyCommon IsEnableWIFI])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无网络访问" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if ([[_msgContentTV.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        //[BaseUIViewController showAutoDismissFailView:@"留言内容不能为空" msg:nil seconds:2.0];
        return;
    }
    if ([MyCommon stringContainsEmoji:_msgContentTV.text])
    {
        [BaseUIViewController showAutoDismissFailView:@"提示" msg:@"当前不支持输入法自带表情" seconds:2.0];
        return;
    }
    
    if (!_sendPesonalMsgCon) {
        _sendPesonalMsgCon = [self getNewRequestCon:NO];
    }
//    if (_faceScrollView.isShow) {
//        [self hideFaceView:YES];
//    }
    User_DataModal *user = [Manager getUserInfo];
    NSString *fromUserId = user.userId_;
    if (!fromUserId) {
        [BaseUIViewController showAutoDismissFailView:@"登录后才能发私信" msg:nil seconds:2.0];
        return;
    }
    NSString *toUserId = _inDataModel.userId;
    [_sendPesonalMsgCon leaveMsgContent:_msgContentTV.text from:fromUserId to:toUserId hrFlag:_isHr shareType:@"" productType:_productType recordId:_recordId];
    _sendLeaveMessage = [[LeaveMessage_DataModel alloc]init];
    _sendLeaveMessage.content = _msgContentTV.text;
    _sendLeaveMessage.isSend = @"1";
    
    _sendLeaveMessage.personPic = user.img_;
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    [self timeInterval];
    
    MessageDailogCellFrame *cellFrame = [[MessageDailogCellFrame alloc]init];
    cellFrame.leaveMessage = _sendLeaveMessage;
    [_messageFrameList addObject:cellFrame];
   
    [tableView_ reloadData];
    [self scrollTableToFoot:YES];
//    [self viewSingleTap:nil];
    _msgContentTV.text = @"";
    [self changeTextViewFrame];
}

- (void)timeInterval
{
    NSDictionary *dic = [NSDictionary dictionary];
    NSMutableDictionary *saveDic = [NSMutableDictionary dictionary];
    dic = [[NSUserDefaults standardUserDefaults] objectForKey:_inDataModel.userId];
    
    NSInteger indirect = (long)[[NSDate date] timeIntervalSince1970] - [dic[@"indirectTimeInterval"] integerValue];
    if (indirect >= 2*60) {
        _sendLeaveMessage.date = @"刚刚";
        [saveDic setObject:[NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]] forKey:@"sendLeaveMessageTime"];
    }else{
        NSInteger timeInterval = (long)[[NSDate date] timeIntervalSince1970] - [dic[@"sendLeaveMessageTime"] integerValue];
        if (timeInterval >= 5*60) {
            _sendLeaveMessage.date = @"刚刚";
            
            [saveDic setObject:[NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]] forKey:@"sendLeaveMessageTime"];
        }else{
            _sendLeaveMessage.date = nil;
            [saveDic setObject:dic[@"sendLeaveMessageTime"] forKey:@"sendLeaveMessageTime"];
        }
    }
    [saveDic setObject:[NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]] forKey:@"indirectTimeInterval"];
    NSDictionary *tempDic = [NSDictionary dictionaryWithDictionary:saveDic];
    [[NSUserDefaults standardUserDefaults] setObject:tempDic forKey:_inDataModel.userId];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)btnResponse:(id)sender
{
    if (sender == _voiceMessageBtn) {
        if (_voiceMessageBtn.selected) {//显示
            //移除facescrollview 的手势
            [MyCommon removeTapGesture:tableView_ ges:_singleTapRecognizer];
            _singleTapRecognizer = nil;
            [_msgContentTV becomeFirstResponder];
            [_msgContentTV setHidden:NO];
            [_voicelb setHidden:YES];
            _voiceMessageBtn.selected = NO;
        }else{//隐藏
            if ([_msgContentTV isFirstResponder]) {
                [_msgContentTV resignFirstResponder];
            }
            CGRect frame = _msgContentView.frame;
            frame.size.height = 40;
            _msgContentView.frame = frame;
            
            [_msgContentTV setHidden:YES];
            [_voicelb setHidden:NO];
            [self viewSingleTap:nil];
            _voiceMessageBtn.selected = YES;
        }
    }
    if (sender == _faceBtn)
    {//表情
        [self hideShareView:NO];
        if (_faceBtn.selected) {//隐藏faceview 显示键盘
            //移除facescrollview 的手势
            [MyCommon removeTapGesture:tableView_ ges:_singleTapRecognizer];
            _singleTapRecognizer = nil;
            [_msgContentTV becomeFirstResponder];
            
//            _msgContentTV.inputView = nil;
            _faceScrollView.isShow = NO;
        }
        else
        {//只显示faceview
            _faceScrollView.isShow = YES;
            
            if ([_msgContentTV isFirstResponder])
            {
                [_msgContentTV resignFirstResponder];
            }
//             _msgContentTV.inputView = _faceScrollView;
            [self showFaceView];
        }
        [_msgContentTV setHidden:NO];
        [_voicelb setHidden:YES];
        _voiceMessageBtn.selected = NO;
        
    }else if (sender == _companyBtn) {
        if (hrMessageModel.is_Hr) {
            //是hr
            ZWDetail_DataModal * dataModel =[[ZWDetail_DataModal alloc] init];
            dataModel.companyID_ = hrMessageModel.companyId_;
            dataModel.companyName_ = hrMessageModel.company_;
            PositionDetailCtl *positionCtl = [[PositionDetailCtl alloc]init];
            positionCtl.type_ = 2;
            positionCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:positionCtl animated:YES];
            [positionCtl beginLoad:dataModel exParam:nil];
        }else if(hrMessageModel.is_Rc){
            //是人才
            ELNewResumePreviewCtl *resumePreviewCtl = [[ELNewResumePreviewCtl alloc] init];
            resumePreviewCtl.forType = @"0";
            [self.navigationController pushViewController:resumePreviewCtl animated:YES];
            User_DataModal *model = [[User_DataModal alloc] init];
            model.userId_ = hrMessageModel.id_;
            model.name_ = hrMessageModel.iname_;
            model.mobile_ = hrMessageModel.mobile_;
            [resumePreviewCtl beginLoad:model exParam:hrMessageModel.companyId_];
        }
    }
    else if(sender == shareAddBtn)
    {
        [self hideFaceView:NO];
        
        CGRect frame = shareAddView.frame;
        CGRect frameOne = _msgContentView.frame;
        if (!shareAddBtn.selected)
        {
            isShareViewShow = YES;
            [_msgContentTV resignFirstResponder];
            frame.origin.y = [UIScreen mainScreen].bounds.size.height - 264;
            frameOne.origin.y = [UIScreen mainScreen].bounds.size.height - 264 - frameOne.size.height;
            shareAddBtn.selected = YES;
            [UIView animateWithDuration:0.26 animations:^{
                shareAddView.frame = frame;
                _msgContentView.frame = frameOne;
                
                CGRect rect = tableView_.frame;
                rect.size.height = ScreenHeight - rect.origin.y - 104-shareAddView.frame.size.height;
                tableView_.frame = rect;
//                rect.size.height -= shareAddView.frame.size.height;
//                tableView_.frame = rect;
//                tableView_.contentInset = UIEdgeInsetsMake(0,0,200,0);
                if (_messageFrameList.count > 0)
                {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(_messageFrameList.count - 1) inSection:0];
                    [tableView_ scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                }
            }];
        }
        else
        {
            isShareViewShow = NO;
            //            tableView_.contentInset = UIEdgeInsetsZero;
            [_msgContentTV becomeFirstResponder];
            //            frame.origin.y = [UIScreen mainScreen].bounds.size.height - 64;
            //            frameOne.origin.y = [UIScreen mainScreen].bounds.size.height - 104;
            shareAddBtn.selected = NO;
        }
        if (!_singleTapRecognizer) {
            _singleTapRecognizer = [MyCommon addTapGesture:tableView_ target:self numberOfTap:1 sel:@selector(viewSingleTap:)];
        }
        
        [_msgContentTV setHidden:NO];
        [_voicelb setHidden:YES];
        _voiceMessageBtn.selected = NO;
        
    }
}



- (void)showKeyboard
{
    [_msgContentTV becomeFirstResponder];
}

#pragma mark 滚动到表格的末尾
- (void)scrollToTableBottom
{
    NSInteger count = _messageFrameList.count;
    if (count <= 0) {
        return;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(count - 1) inSection:0];
    [tableView_ selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
}


-(void) showNoDataOkView:(BOOL)flag
{
    [super showNoDataOkView:NO];
    
}

#pragma mark 跳转个人中心
- (void)goPersonalCenter:(UITapGestureRecognizer *)sender
{
    NSInteger tag;
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)sender;
        tag = btn.tag;
    }else{
        tag = sender.view.tag;
    }
    NSInteger row = tag - kTagIdOffSet;
    MessageDailogCellFrame *cellFrame = _messageFrameList[row];
    LeaveMessage_DataModel *leaveMessage;
    if ([cellFrame isKindOfClass:[LeaveMessage_DataModel class]]) {
        leaveMessage = (LeaveMessage_DataModel *)cellFrame;
    }else{
        leaveMessage = cellFrame.leaveMessage;
    }
    
    NSString *userId = @"";
    if ([leaveMessage.isSend isEqualToString:@"1"]) {
        userId = [Manager getUserInfo].userId_;
    }else{
        userId = _inDataModel.userId;
    }
    ELPersonCenterCtl *personCenterCtl = [[ELPersonCenterCtl alloc] init];
    personCenterCtl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personCenterCtl animated:NO];
    [personCenterCtl beginLoad:userId exParam:nil];
}

- (void)backBarBtnResponse:(id)sender
{
    tableView_.contentOffset = CGPointMake(0, 0);
    [requestCon_ stopConnWhenBack];
    requestCon_.delegate_ = nil;
    requestCon_ = nil;
    [super backBarBtnResponse:sender];
}


#pragma mark - 分享列表点击事件
- (IBAction)shareAddBtnRespone:(UIButton *)sender
{
    switch (sender.tag) {
        case 341:
        case 340:
        {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = NO;
            if (sender.tag == 340)
            {
                BOOL accessStatus = [[Manager shareMgr] getTheCameraAccessWithCancel:^{}];
                if (!accessStatus) {
                    return;
                }
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            }
            else
            {
                imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                AlbumListCtl *albumListCtl = [[AlbumListCtl alloc]init];
                albumListCtl.maxCount = 1;
                albumListCtl.delegate = self;
                albumListCtl.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:albumListCtl animated:YES];
                [albumListCtl beginLoad:nil exParam:nil];
                return;
            }
            [self presentViewController:imagePickerController animated:NO completion:^{}];
        }
            break;
        case 342:
        {
            SameTradeListCtl *sameTradeCtl = [[SameTradeListCtl alloc]init];
            sameTradeCtl.delegate_ = self;
            sameTradeCtl.fromMessageList = YES;
            sameTradeCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sameTradeCtl animated:YES];
            [sameTradeCtl beginLoad:nil exParam:nil];
        }
            break;
        case 343:
        {
            MyJobSearchCtl *ctl = [[MyJobSearchCtl alloc] init];
            ctl.messageDelegate = self;
            ctl.fromMessageList = YES;
            ctl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ctl animated:YES];
            [ctl beginLoad:nil exParam:nil];
        }
            break;
        case 344:
        {
            __weak MessageDailogListCtl *ctl = self;
            OwnGroupListCtl *ownGroupList = [[OwnGroupListCtl alloc]init];
            ownGroupList.fromMessageDailog = YES;
            ownGroupList.block = ^(ELGroupListDetailModel *dataModal){
                [ctl groupMessageDailogSelect:dataModal];
            };
            [ownGroupList beginLoad:nil exParam:nil];
            [self.navigationController pushViewController:ownGroupList animated:YES];
        }
            break;
        case 345:
        {
            MyFavoriteCenterCtl *ctl = [[MyFavoriteCenterCtl alloc] init];
            ctl.fromMessageList = YES;
            ctl.favoriteDelegate = self;
            [self.navigationController pushViewController:ctl animated:YES];
            [ctl beginLoad:nil exParam:nil];
        }
            break;
        case 346:
        {
            UIActionSheet* myActionSheet = [[UIActionSheet alloc]
                                            initWithTitle:nil
                                            delegate:self
                                            cancelButtonTitle:@"取消"
                                            destructiveButtonTitle:nil
                                            otherButtonTitles:@"发送我的简历",@"查看我的简历", nil];
            [myActionSheet showInView:self.view];
        }
            break;
        default:
            break;
    }
}

-(void)loadResumeInfomation:(NSString *)userId
{
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@",userId];
    [ELRequest postbodyMsg:bodyMsg op:@"person_info_busi" func:@"getPersonInfo" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
     {
         NSDictionary *dic = result;
         resumeShareModal = [[ShareMessageModal alloc] init];
         resumeShareModal.personId = dic[@"person_id"];
         resumeShareModal.personName = dic[@"person_iname"];
         resumeShareModal.person_pic = dic[@"person_pic"];
         resumeShareModal.person_gznum = dic[@"person_gznum"];
         resumeShareModal.person_edu = dic[@"person_edu"];
         resumeShareModal.person_zw = dic[@"person_zw"];
         
     } failure:^(NSURLSessionDataTask *operation, NSError *error) {
         
     }];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    [self hideShareView:YES];
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^{
        switch (buttonIndex) {
            case 0://发送简历
            {
                shareModal = resumeShareModal;
                shareModal.shareType = @"25";
                shareModal.shareContent = @"职位";
                if (!shareCon) {
                    shareCon = [self getNewRequestCon:NO];
                }
                [shareCon getShareMessageWithSend_uid:[Manager getUserInfo].userId_ receiveId:_inDataModel.userId receiveName:_inDataModel.userIname content:shareModal.shareContent dataModal:shareModal];
            }
                break;
            case 1://查看简历
            {
                ResumePreviewController *resumePreview = [[ResumePreviewController alloc]init];
                resumePreview.showTranspontResumeBtn = NO;
                resumePreview.formMessage = YES;
                [self.navigationController pushViewController:resumePreview animated:YES];
                [resumePreview beginLoad:nil exParam:nil];
            }
                break;
            default:
                break;
        }
    });
    
}

-(void)favoriteMessageDelegateModal:(id)modal
{
    shareModal = modal;
    NSString *content = @"";
    if([shareModal.shareType isEqualToString:@"2"])
    {
        content = [NSString stringWithFormat:@"推荐“%@”到当前聊天?",shareModal.article_title];
    }
    else if([shareModal.shareType isEqualToString:@"11"])
    {
        content = [NSString stringWithFormat:@"推荐“%@”到当前聊天?",shareModal.article_title];
    }
    else if([shareModal.shareType isEqualToString:@"20"])
    {
        content = [NSString stringWithFormat:@"推荐“%@”到当前聊天?",shareModal.position_name];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:content delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
    alertType = 101;
    [alert show];
}

-(void)groupMessageDailogSelect:(ELGroupListDetailModel *)modal
{
    shareModal = [[ShareMessageModal alloc] init];
    NSString *groupName = modal.group_name;
    groupName = [groupName stringByReplacingOccurrencesOfString:@"<font color=red>" withString:@""];
    groupName = [groupName stringByReplacingOccurrencesOfString:@"</font>" withString:@""];
    shareModal.shareContent = [NSString stringWithFormat:@"推荐了社群“%@”",groupName];
    shareModal.groupId = modal.group_id;
    shareModal.groupName = groupName;
    shareModal.groupPersonCnt = [NSString stringWithFormat:@"%@",modal.group_person_cnt];;
    shareModal.groupArticleCnt = [NSString stringWithFormat:@"%@",modal.group_article_cnt];
    shareModal.groupPic = modal.group_pic;
    shareModal.shareType = @"10";
    if(shareModal.groupPic.length == 0)
    {
        shareModal.groupPic = @"";
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"推荐“%@”到当前聊天?",shareModal.groupName] delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
    alertType = 101;
    [alert show];
}

-(void)sameTradeMessageModal:(id)modal
{
    shareModal = modal;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"推荐“%@”到当前聊天?",shareModal.personName] delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
    alertType = 101;
    [alert show];
}

-(void)jobSearchMessageDelegateModal:(JobSearch_DataModal *)modal
{
    shareModal = [[ShareMessageModal alloc] init];
    shareModal.shareType = @"20";
    shareModal.shareContent = @"职位";
    
    shareModal.position_id = modal.zwID_;
    shareModal.position_name = modal.zwName_;
    shareModal.position_logo = modal.companyLogo_;
    shareModal.position_company = modal.companyName_;
    shareModal.position_company_id = modal.companyID_;
    
    if (!shareModal.position_name)
    {
        shareModal.position_name = modal.jtzw_;
        if (shareModal.position_name.length == 0)
        {
            shareModal.position_name = @"";
        }
    }
    if (!shareModal.position_logo) {
        shareModal.position_logo = @"";
    }
    if (!shareModal.position_company)
    {
        shareModal.position_company = @"";
    }
    if (!shareModal.position_company_id)
    {
        shareModal.position_company_id = @"";
    }
    
    if (modal.salary_.length > 0) {
        shareModal.position_salary = modal.salary_;
    }
    else
    {
        shareModal.position_salary = @"面议";
    }
    
    shareModal.position_name = [shareModal.position_name stringByReplacingOccurrencesOfString:@"<font color=red>" withString:@""];
    shareModal.position_name = [shareModal.position_name stringByReplacingOccurrencesOfString:@"</font>" withString:@""];
    shareModal.position_company = [shareModal.position_company stringByReplacingOccurrencesOfString:@"<font color=red>" withString:@""];
    shareModal.position_company = [shareModal.position_company stringByReplacingOccurrencesOfString:@"</font>" withString:@""];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"推荐“%@”到当前聊天?",shareModal.position_name] delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
    alertType = 101;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertType == 101)
    {
        if(buttonIndex == 0)
        {
            if (!shareCon) {
                shareCon = [self getNewRequestCon:NO];
            }
            [shareCon getShareMessageWithSend_uid:[Manager getUserInfo].userId_ receiveId:_inDataModel.userId receiveName:_inDataModel.userIname content:shareModal.shareContent dataModal:shareModal];
            
            [self timeInterval];
        }
    }
}

-(void)creatMessageData:(NSString *)msgId
{
    LeaveMessage_DataModel *dataModel = [[LeaveMessage_DataModel alloc]init];
    dataModel.isSend = @"1";
    dataModel.personIName = [Manager getUserInfo].name_;
    dataModel.personPic = [Manager getUserInfo].img_;
    dataModel.content = shareModal.shareContent;
//    dataModel.date = @"刚刚";
   
    dataModel.msgId = msgId;
    NSString *shareType = shareModal.shareType;
    if ([shareType isEqualToString:@"20"])
    {//职位分享
        dataModel.messageType = MessageTypeShareJob;
        JobSearch_DataModal *jobModel = [[JobSearch_DataModal alloc]init];
        jobModel.zwID_ = shareModal.position_id;
        jobModel.companyLogo_ = shareModal.position_logo;
        jobModel.zwName_ = shareModal.position_name;
        jobModel.salary_  = shareModal.position_salary;
        jobModel.companyName_ = shareModal.position_company;
        jobModel.companyID_ = shareModal.position_company_id;
        dataModel.otherModel = jobModel;
    }else if ([shareType isEqualToString:@"1"]) {//人才分享
        dataModel.messageType = MessageTypeShareUser;
        User_DataModal *userModel = [[User_DataModal alloc]init];
        userModel.img_ = shareModal.person_pic;
        userModel.uname_= shareModal.personName;
        userModel.userId_ = shareModal.personId;
        userModel.zym_ = shareModal.person_zw;
        dataModel.otherModel = userModel;
    }
    else if ([shareType isEqualToString:@"25"]) //简历分享
    {
        dataModel.messageType = MessageTypeShareReusme;
        ShareMessageModal *userModel = [[ShareMessageModal alloc] init];
        userModel.personId = shareModal.personId;
        userModel.personName = shareModal.personName;
        userModel.person_zw = shareModal.person_zw;
        userModel.person_pic = shareModal.person_pic;
        userModel.person_gznum = shareModal.person_gznum;
        userModel.person_edu = shareModal.person_edu;
        dataModel.otherModel = userModel;
    }
    else if([shareType isEqualToString:@"11"] || [shareType isEqualToString:@"2"])//社群文章分享
    {
        dataModel.messageType = MessageTypeGroupArticle;
        Article_DataModal *modal = [[Article_DataModal alloc] init];
        modal.id_ = shareModal.article_id;
        modal.title_ = shareModal.article_title;
        modal.thum_ = shareModal.article_thumb;
        modal.summary_ = shareModal.article_summary;
        dataModel.otherModel = modal;
    }
    else if([shareType isEqualToString:@"10"])//社群分享
    {
        dataModel.messageType = MessageTypeGroup;
        Groups_DataModal *modal = [[Groups_DataModal alloc] init];
        modal.id_ = shareModal.groupId;
        modal.name_ = shareModal.groupName;
        modal.pic_ = shareModal.groupPic;
        modal.personCnt_ = [shareModal.groupPersonCnt integerValue];
        modal.articleCnt_ = [shareModal.groupArticleCnt integerValue];
        dataModel.otherModel = modal;
    }
    [_messageFrameList addObject:dataModel];
    
    [tableView_ reloadData];
    [self scrollTableToFoot:YES];
}

-(void)uploadPhoto
{
    if(![MyCommon IsEnable3G] && ![MyCommon IsEnableWIFI])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无网络访问" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alert show];
        return;
    }
    @try
    {
        NSData *imgData = UIImageJPEGRepresentation(shareImage, 0.1);
        NSDate * now = [NSDate date];
        NSString * timeStr = [now stringWithFormat:@"yyyy-MM-dd_HHmmss" timeZone:[NSTimeZone systemTimeZone] behavior:NSDateFormatterBehaviorDefault];
        RequestCon *uploadCon = [self getNewRequestCon:NO];
        
        [uploadCon uploadPhotoData:imgData name:[NSString stringWithFormat:@"%@.jpg",timeStr]];
        
        [self timeInterval];
    }
    @catch (NSException *exception)
    {
    }
    @finally {
        
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    shareImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    shareImage = [shareImage fixOrientation];
    if (!shareImage) {
        return;
    }
    [self uploadPhoto];
}

- (void)didFinishSelectPhoto:(NSArray *)imageArr
{
    shareImage = imageArr[0];
    shareImage = [shareImage fixOrientation];
    if (!shareImage) {
        return;
    }
    [self uploadPhoto];
}


//语音播放
- (void)voicePlayLeftBtnClick:(UIButton *)btn
{
    LeaveMessage_DataModel *messageModel = _messageFrameList[btn.tag - 1000];
    voiceType = @"1";
    tempModel = messageModel;
    if (voicePlayLeftBtn) {
        [voicePlayLeftBtn setImage:[UIImage imageNamed:@"ReceiverVoiceNodePlaying.png"] forState:UIControlStateNormal];
    }
    if (voicePlayRightBtn) {
        [voicePlayRightBtn setImage:[UIImage imageNamed:@"SenderVoiceNodePlaying.png"] forState:UIControlStateNormal];
    }
    voicePlayLeftBtn = btn;
    [self loadVoice];
}

//语音播放
- (void)voicePlayRightBtnClick:(UIButton *)btn
{
    LeaveMessage_DataModel *messageModel = _messageFrameList[btn.tag - 1000];
    voiceType = @"2";
    tempModel = messageModel;
    if (voicePlayLeftBtn) {
        [voicePlayLeftBtn setImage:[UIImage imageNamed:@"ReceiverVoiceNodePlaying.png"] forState:UIControlStateNormal];
    }
    if (voicePlayRightBtn) {
        [voicePlayRightBtn setImage:[UIImage imageNamed:@"SenderVoiceNodePlaying.png"] forState:UIControlStateNormal];
    }
    voicePlayRightBtn = btn;
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

- (void)finishOver:(ASINetworkQueue*)queue1 {
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
        return;
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
    if ([voiceType isEqualToString:@"1"]) {
        if (isplay_ == NO) {
            [voicePlayLeftBtn setImage:[UIImage imageNamed:@"ReceiverVoiceNodePlaying.png"] forState:UIControlStateNormal];
            return;
        }
        [voicePlayLeftBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ReceiverVoiceNodePlaying00%ld.png",(long)index_]] forState:UIControlStateNormal];
    }else if ([voiceType isEqualToString:@"2"]){
        if (isplay_ == NO) {
            [voicePlayRightBtn setImage:[UIImage imageNamed:@"SenderVoiceNodePlaying.png"] forState:UIControlStateNormal];
            return;
        }
        [voicePlayRightBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"SenderVoiceNodePlaying00%ld.png",(long)index_]] forState:UIControlStateNormal];
    }
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
        if (voicePlayLeftBtn) {
            [voicePlayLeftBtn setImage:[UIImage imageNamed:@"ReceiverVoiceNodePlaying.png"] forState:UIControlStateNormal];
        }
        if (voicePlayRightBtn) {
            [voicePlayRightBtn setImage:[UIImage imageNamed:@"SenderVoiceNodePlaying.png"] forState:UIControlStateNormal];
        }
        [player stop];
        player = nil;
        isplay_ = NO;
    }
}

@end
