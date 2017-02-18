//
//  MessageDailogListCtl.m
//  jobClient
//
//  Created by 一览ios on 14/12/9.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//他人给自己私信对话

#import "ELGroupIMListCtl.h"
#import "ExRequetCon.h"
#import "LeaveMessage_DataModel.h"
#import "MessageContact_DataModel.h"
#import "MessageDailogList_Cell.h"
#import "MessageDailogList_Cell2.h"
#import "FaceScrollView.h"
#import "MLEmojiLabel.h"
#import "MessageDelTipsCtl.h"
#import "MessageVoiceLeftCell.h"
#import "MessageVoiceRightCell.h"
#import "PhotoSelectCtl.h"
#import "RecodeVoiceCtl.h"
#import "NSString+URLEncoding.h"
#import "ELMessageImage_Cell.h"
#import "Upload_DataModal.h"
#import "AlbumListCtl.h"
#import "ELPersonCenterCtl.h"
#import "ASIHTTPRequest.h"

#import "ELGroupDetailModal.h"
#import "ELGroupCommentModel.h"
#import "ELWebSocketManager.h"
#import "ELGroupChatCellFrame.h"
#import "ResumeCommentTag_DataModal.h"
#import "ELNewLeaveMsgDAO.h"

#define IOS7 [[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0
static int kTagIdOffSet = 1001;

@interface ELGroupIMListCtl ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,RecodeVoiceCtlDelegate,ImageCellDelegate,PhotoSelectCtlDelegate,UIScrollViewDelegate,ASIHTTPRequestDelegate,ELWebSocketManagerDelegate>
{
    BOOL _isKeyboardShow;
    CGFloat _keyboardHeight;
    UITapGestureRecognizer *_singleTapRecognizer;
    LeaveMessage_DataModel *_sendLeaveMessage;//发送的私信
    FaceScrollView *_faceScrollView;//表情面板
    CGFloat _move;//tableview的滚动距离
    UITapGestureRecognizer *copyTap;
    __weak IBOutlet UIButton *shareAddBtn;
    IBOutlet UIView *shareAddView;
    RecodeVoiceCtl  *recodeVoiceCtl;
    RequestCon *shareCon;
    
    BOOL isShareViewShow;
    UIImage *shareImage;
    
    CGPoint  pointBegin;
    IBOutlet UIButton *sendBtn;
    LeaveMessage_DataModel *tempModel;
    UIButton  *voicePlayLeftBtn;
    UIButton  *voicePlayRightBtn;
    NSString  *voiceType;  //1左
    
    __weak IBOutlet UIView *msgBackView;
    
    CGFloat textViewHeight;
    
    BOOL isScrollBottom;
    NSMutableArray *_tagArray;
    BOOL isAddNewMessage;
    NSMutableArray *newMessageArr;
    BOOL canAddNewMessage;
    __weak IBOutlet NSLayoutConstraint *_msgContentViewHeight;
    __weak IBOutlet NSLayoutConstraint *_msgCVTrailing;
    __weak IBOutlet NSLayoutConstraint *_msgBackViewHeight;
    __weak IBOutlet NSLayoutConstraint *_msgContentTVTop;
    
    CGSize oldContentSize;
    //自定义评论Id 用于数据库查找
    NSInteger msgId;
    
    ELNewLeaveMsgDAO *_msgDao;
    //缓存数据
    NSMutableArray *_cacheMsgArr;
    BOOL isAddCacheMsg;
    
    //存放本地接受或发送的数据，避免下拉加载时新的数据消失
    NSMutableArray *_sendAndreceiceMsg;
}

@property (nonatomic, strong) ELWebSocketManager *socketManager;
@end

@implementation ELGroupIMListCtl
#pragma mark - LifeCycle
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"startScroll" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"receiveSocketMsg" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_interactivePopDisabled = YES;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    CGRect rect = tableView_.frame;
    rect.size.width = self.view.frame.size.width;
    rect.size.height = ScreenHeight-rect.origin.y-104-44;
    tableView_.frame = rect;
    [tableView_ setSeparatorStyle:UITableViewCellSeparatorStyleNone];
   
    [_faceBtn setImage:[UIImage imageNamed:@"ToolViewKeyboard.png"] forState:UIControlStateSelected];
    [shareAddBtn setImage:[UIImage imageNamed:@"ToolViewKeyboard.png"] forState:UIControlStateSelected];
    
    msgBackView.layer.borderWidth = 0.3;
    msgBackView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    msgBackView.layer.cornerRadius = 4.0;
    
    _msgContentTV.delegate = self;
    _messageFrameList = [NSMutableArray array];
    [_delCopyImgv addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(copyDelImgvClick:)]];
    
    _voicelb.layer.borderWidth = 0.3;
    _voicelb.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _voicelb.layer.cornerRadius = 4.0;
    UILongPressGestureRecognizer *longPre = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGesture:)];
    longPre.minimumPressDuration = 0.1;
    [_voicelb addGestureRecognizer:longPre];
    _voicelb.userInteractionEnabled = YES;
    
    CGRect frame = shareAddView.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height - 20;
    frame.size.width = ScreenWidth;
    shareAddView.frame = frame;
    [self.view addSubview:shareAddView];
    
    if ([self respondsToSelector:@selector(setAllowsNonContiguousLayout:)]) {
        _msgContentTV.layoutManager.allowsNonContiguousLayout = NO;
    }
    
    isScrollBottom = YES;
    isAddNewMessage = NO;
    newMessageArr = [[NSMutableArray alloc] init];
    self.socketManager.delegate = self;
    [self requestResumeTag];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveSocketMsg:) name:@"receiveSocketMsg" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mykeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mykeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideBottomView:) name:@"startScroll" object:nil];
    
    canAddNewMessage = NO;
    _msgDao = [ELNewLeaveMsgDAO new];
    
    msgId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"msgId"] integerValue];
    if (msgId == 0) {
        msgId = 10000;
    }
    
    isAddCacheMsg = YES;
    _cacheMsgArr = [[NSMutableArray alloc] init];
    _sendAndreceiceMsg = [[NSMutableArray alloc] init];
    [self AFNReachabilityMonitoring];
}

//-----------键盘处理－－－－－－－－－－
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    CGRect rect = tableView_.frame;
    double height ;//= _isKeyboardShow?(ScreenHeight-_keyboardHeight-104):(ScreenHeight-104);
    if (_isKeyboardShow) {
        height = (ScreenHeight-_keyboardHeight-104-44);
    }else if (_faceScrollView.isShow){
        height = ScreenHeight-104-_faceScrollView.frame.size.height-44;
    }else if (isShareViewShow){
        height = ScreenHeight-104-shareAddView.frame.size.height-44;
    }else{
        height = ScreenHeight-104-44;
    }
    rect.size.height = height-rect.origin.y;
    tableView_.frame = rect;
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self stopVoice];
}

-(void)changeTextViewFrame
{
    CGRect textFrame=[[_msgContentTV layoutManager]usedRectForTextContainer:[_msgContentTV textContainer]];
    CGFloat height = textFrame.size.height+2;
    if (fabs(height - textViewHeight) < 10) {
        return;
    }
    textViewHeight = height;
    _msgContentTV.textContainerInset = UIEdgeInsetsMake(0,0,0,0);

    if (height > 90) {
        _msgBackViewHeight.constant = 84;
        _msgContentViewHeight.constant = 96;
    }else{
        _msgBackViewHeight.constant = height > 30 ? height:30;
        _msgContentViewHeight.constant = height > 30 ? height+10 : 40;
    }
    
    if (height < 20 || _msgContentTV.text.length <= 0) {
        _msgContentTVTop.constant = 5;
    }else{
        _msgContentTVTop.constant = 0;
    }
    
    CGFloat heightOne = 0;
    if (_isKeyboardShow) {
        heightOne = _keyboardHeight;
    }
    else if (_faceScrollView.isShow)
    {
        heightOne = _faceScrollView.frame.size.height;
    }
    
    _msgCVTrailing.constant = heightOne;
    
    if(msgBackView.frame.size.height >= 84){
        [_msgContentTV scrollRangeToVisible:_msgContentTV.selectedRange]; 
    }
}

#pragma mark - 长按手势 开始录音
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
    if (_faceScrollView.isShow) {
        [self hideFaceView:YES];
    }
    
    NSMutableDictionary *shareDic = [[NSMutableDictionary alloc] init];
    [shareDic setObject:@"5" forKey:@"type"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSString stringWithFormat:@"%@#%@",model.servicePathUrl,model.duration] forKey:@"path"];
    [shareDic setObject:dic forKey:@"slave"];
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *shareStr = [jsonWriter stringWithObject:shareDic];
    
    [_socketManager sendMessage:@"[语音]" GroupModel:_inDataModel TopicId:_inDataModel.auto_article_id TagId:nil QiId:@"1" ParentId:nil CommentType:@"3" ContentType:@"5" share:shareStr];
    
    _sendLeaveMessage = [[LeaveMessage_DataModel alloc] init];
    _sendLeaveMessage.imageUrl_ = model.servicePathUrl;
    _sendLeaveMessage.content = @"[语音]";
    _sendLeaveMessage.voiceTime = model.duration;
    _sendLeaveMessage.isSend = @"1";
    _sendLeaveMessage.messageType = MessageTypeVoice;
    _sendLeaveMessage.personPic = [Manager getUserInfo].img_;
    _sendLeaveMessage.personId = [Manager getUserInfo].userId_;
    _sendLeaveMessage.groupId = _inDataModel.group_id;
    _sendLeaveMessage.msgUploadStatus = MsgUploadStatusInit;
    [self timeIntervalue];
    
    [_messageFrameList addObject:_sendLeaveMessage];
    [_sendAndreceiceMsg addObject:_sendLeaveMessage];
    [self saveMsgToDB:_sendLeaveMessage];
    
    [_msgContentTV resignFirstResponder];
    _msgContentTV.text = @"";
    [self changeTextViewFrame];
    
    isScrollBottom = YES;
}

#pragma mark - 复制消息
- (void)copyDelImgvClick:(UIGestureRecognizer *)tap
{
    UIView *sender = tap.view;
    ELGroupChatCellFrame *cellFrame = _messageFrameList[sender.tag];
    LeaveMessage_DataModel *leaveMessage = cellFrame.leaveMessage;
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = leaveMessage.content;
    
    [_delCopyImgv removeFromSuperview];
}

//-----------数据请求与刷新－－－－－－－－－－
#pragma mark - 数据请求与刷新
-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    _inDataModel = dataModal;
    [super beginLoad:dataModal exParam:exParam];
}

-(void)getDataFunction:(RequestCon *)con
{
    if(con == requestCon_){
        NSString *myId = [Manager getUserInfo].userId_;
        if (!myId) {
            [BaseUIViewController showAutoDismissFailView:@"登录后才能查看" msg:nil seconds:2.0];
            return;
        }
        oldContentSize = tableView_.contentSize;
        [requestCon_ getGroupChatList:requestCon_.pageInfo_.currentPage_ pageSize:20 article:_inDataModel.auto_article_id parentId:@"" userId:[Manager getUserInfo].userId_];
    }
}

-(void)updateCom:(RequestCon *)con
{    
    if(con != _deleteMsgCon && isScrollBottom)
    {
        [self performSelector:@selector(scrollToTableBottom) withObject:nil afterDelay:0.3];
        isScrollBottom = NO;
    }
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GroupChatList:
        {
            if (requestCon_.dataArr_.count > 0) {
                [_messageFrameList removeAllObjects];
                for (NSInteger i = requestCon_.dataArr_.count-1; i >= 0; i--) {
                    ELGroupCommentModel *model = [requestCon_.dataArr_ objectAtIndex:i];
                    LeaveMessage_DataModel *messageModel = [[LeaveMessage_DataModel alloc] init];
                    
                    if ([model.content isEqualToString:@""]) {
                        continue;
                    }
                    
                    messageModel.msgId = model.id_;
                    if ([model.personId isEqualToString:[Manager getUserInfo].userId_]) {
                        messageModel.isSend = @"1";
                        messageModel.personIName = @"";
                    }
                    else
                    {
                        messageModel.isSend = @"0";
                        messageModel.personIName = model.person_iname;
                    }
                    
                    messageModel.personPic = model.person_pic;
                    messageModel.toUserId = model.personId;
                    messageModel.qi_id_isdefault = model.qi_id_isdefault;
                    
                    NSDate *date = [MyCommon getDate:model.ctime];
                    messageModel.date = [MyCommon getWhoLikeMeListCurrentTime:date currentTimeString:model.ctime];
                    if ([messageModel.date isEqualToString:@"0秒前"]) {
                        messageModel.date = @"刚刚";
                    }
                    
                    if ([model.comment_type isEqualToString:@"1"]
                        || [model.comment_content_type isEqualToString:@"11"])
                    {//纯文本  来自寄简历话题
                        if ([model.qi_id_isdefault isEqualToString:@"2"]) {
                            //简历评论需获取文章Id
                            messageModel.article_id = [[model.share objectForKey:@"slave"] objectForKey:@"article_id"];
                            model.content = [self componentsMsgContentString:model.content];
                        }
                        NSString *tagStr;
                        if (model.tagsList.count > 0) {
                            ResumeCommentTag_DataModal *tagModel = [model.tagsList objectAtIndex:0];
                            tagStr = [NSString stringWithFormat:@"%@ #%@#", model.content, tagModel.tagName_];
                            messageModel.tagName = tagModel.tagName_;
                        }

                        NSString *contentStr;
                        if (tagStr != nil) {
                            contentStr = tagStr;
                        }
                        else {
                            contentStr = model.content;
                        }
                        
                        if (model._parent_comment) {
                            NSString *patentName = [NSString stringWithFormat:@"@%@", model._parent_person_detail.person_iname];
                            messageModel.content = [NSString stringWithFormat:@"%@ %@", patentName, contentStr];
                        }
                        else{
                            messageModel.content = contentStr;
                        }
                        
                        messageModel.attString = [self changeAttString:messageModel.content tagLenght:messageModel.tagName.length];
                        
                        messageModel.messageType = MessageTypeText;
                        
                        ELGroupChatCellFrame *cellFrame = [[ELGroupChatCellFrame alloc]init];
                        cellFrame.leaveMessage = messageModel;
                        [_messageFrameList addObject:cellFrame];
                    }
                    else if ([model.comment_content_type isEqualToString:@"4"])
                    {//图片
                        messageModel.imageUrl_ = [model.share objectForKey:@"slave"];
                        messageModel.messageType = MessageTypeImage;
                        [_messageFrameList addObject:messageModel];
                    }
                    else if ([model.comment_content_type isEqualToString:@"5"])
                    {//语音
                        NSString *tempStr = [model.share objectForKey:@"slave"];
                        messageModel.imageUrl_ = tempStr;
                        NSArray *voiceArr = [tempStr componentsSeparatedByString:@"#"];
                        messageModel.voiceTime = [voiceArr lastObject];
                        if ([voiceArr count] >=2) {
                            messageModel.voiceTime = [voiceArr lastObject];
                        }
                        
                        messageModel.content = [voiceArr firstObject];
                        messageModel.messageType = MessageTypeVoice;
                        [_messageFrameList addObject:messageModel];
                    }
                }
            }
            canAddNewMessage = YES;
            isAddNewMessage = NO;
            if (_sendAndreceiceMsg.count > 0 && requestCon_.pageInfo_.totalCnt_ > 1) {
                [_messageFrameList addObjectsFromArray:_sendAndreceiceMsg];
            }
            
            if (isAddCacheMsg) {
                [self addCacheMsgInfo];
            }
            
            [tableView_ reloadData];
        
            if (oldContentSize.height > 0) {
                CGFloat setOff = tableView_.contentSize.height-oldContentSize.height;
                if (setOff > 20) {
                    tableView_.contentOffset = CGPointMake(0,setOff-60);
                }
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
            NSString *shareImageUrl = [NSString stringWithFormat:@"%@#%@",modal.path_,str];
            if(shareImageUrl.length < 10)
            {
                [BaseUIViewController showAlertViewContent:@"图片发送失败，请稍后再试" toView:nil second:1.0 animated:YES];
                return;
            }
            
            NSMutableDictionary *shareDic = [[NSMutableDictionary alloc] init];
            [shareDic setObject:@"4" forKey:@"type"];
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:shareImageUrl forKey:@"path"];
            [shareDic setObject:dic forKey:@"slave"];
            NSString *content = @"分享了一张图片";
            
            SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
            NSString * shareStr = [jsonWriter stringWithObject:shareDic];
            
            [_socketManager sendMessage:content GroupModel:_inDataModel TopicId:_inDataModel.auto_article_id TagId:nil QiId:@"1" ParentId:nil CommentType:@"3" ContentType:@"4" share:shareStr];
            
            _sendLeaveMessage = [[LeaveMessage_DataModel alloc]init];
            _sendLeaveMessage.personPic = [Manager getUserInfo].img_;
            _sendLeaveMessage.messageType = MessageTypeImage;
            _sendLeaveMessage.imageUrl_ = shareImageUrl;
            _sendLeaveMessage.image = shareImage;
            _sendLeaveMessage.content = @"分享了一张图片";
            _sendLeaveMessage.isSend = @"1";
            _sendLeaveMessage.personId = [Manager getUserInfo].userId_;
            _sendLeaveMessage.groupId = _inDataModel.group_id;
            _sendLeaveMessage.msgUploadStatus = MsgUploadStatusInit;
            [self timeIntervalue];
            
            [_messageFrameList addObject:_sendLeaveMessage];
            [_sendAndreceiceMsg addObject:_sendLeaveMessage];
            
            [self saveMsgToDB:_sendLeaveMessage];
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
//            [self uploadPhoto];
            [BaseUIViewController showAutoDismissAlertView:@"发送失败" msg:nil seconds:2.0];
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
    if (_messageFrameList.count > 0) {
        return _messageFrameList.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_messageFrameList.count > 0) {
        ELGroupChatCellFrame *cellFrame = _messageFrameList[indexPath.row];
        
        if ([cellFrame isKindOfClass:[LeaveMessage_DataModel class]]) {//留言模型
            LeaveMessage_DataModel *messageModel = (LeaveMessage_DataModel *)cellFrame;
            
            if (messageModel.messageType == MessageTypeVoice)
            {
                if (messageModel.personIName) {
                    return 90;
                }
                else {
                    return 80;
                }
            }
            else if(messageModel.messageType == MessageTypeImage)
            {
                if (messageModel.personIName) {
                    return 135.0;
                }
                else {
                    return 120;
                }
            }
        }
        
        return cellFrame.height+6;
    }
    return 0.00000001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > _messageFrameList.count - 1) {
        return [UITableViewCell new];
    }
    
    ELGroupChatCellFrame *cellFrame = _messageFrameList[indexPath.row];
    
    if ([cellFrame isKindOfClass:[LeaveMessage_DataModel class]])
    {
        LeaveMessage_DataModel *messageModel = (LeaveMessage_DataModel *)cellFrame;
        if (messageModel.messageType == MessageTypeVoice)
        {
            if ([messageModel.isSend isEqualToString:@"1"])
            {
                static NSString *CellIdentifier = @"MessageVoiceRightCell";
                MessageVoiceRightCell *voiceRightCell = (MessageVoiceRightCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (voiceRightCell == nil) {
                    voiceRightCell = [[[NSBundle mainBundle] loadNibNamed:@"MessageVoiceRightCell" owner:self options:nil] lastObject];
                    [voiceRightCell setAttr];
                    voiceRightCell.backgroundColor = UIColorFromRGB(0xf0f0f0);
                    voiceRightCell.isShowNameLb = YES;
                }
                [voiceRightCell setLeaveMessage:messageModel];
                [voiceRightCell.voicePlayBtn addTarget:self action:@selector(voicePlayRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                voiceRightCell.voicePlayBtn.tag = indexPath.row + 1000;
                
                voiceRightCell.fromUserImgv.userInteractionEnabled = YES;
                voiceRightCell.fromUserImgv.tag = kTagIdOffSet + indexPath.row;
                [voiceRightCell.fromUserImgv addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goPersonalCenter:)]];
                
                [voiceRightCell.retryBtn addTarget:self action:@selector(retryMsgClick:) forControlEvents:UIControlEventTouchUpInside];
                voiceRightCell.retryBtn.tag = 99999 + indexPath.row;
                
                [voiceRightCell.retryBtn setHidden:YES];
                switch (messageModel.msgUploadStatus) {
                    case MsgUploadStatusFailed:
                    {
                        [voiceRightCell.retryBtn setHidden:NO];
                    }
                        break;
                    default:
                        break;
                }
                
                return voiceRightCell;
            }
            else{
                static NSString *CellIdentifier = @"MessageVoiceLeftCell";
                MessageVoiceLeftCell *voiceLeftCell = (MessageVoiceLeftCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (voiceLeftCell == nil) {
                    voiceLeftCell = [[[NSBundle mainBundle] loadNibNamed:@"MessageVoiceLeftCell" owner:self options:nil] lastObject];
                    [voiceLeftCell setAttr];
                    voiceLeftCell.backgroundColor = UIColorFromRGB(0xf0f0f0);
                    voiceLeftCell.isShowNameLb = YES;
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
                cellImage.backgroundColor = UIColorFromRGB(0xf0f0f0);
                cellImage.isShowNameLb = YES;
            }
            
            cellImage.cellDelegate = self;
            [cellImage giveDataModal:messageModel];
            cellImage.titleImage.userInteractionEnabled = YES;
            cellImage.titleImage.tag = kTagIdOffSet + indexPath.row;
            [cellImage.titleImage addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goPersonalCenter:)]];
            
            if ([messageModel.isSend isEqualToString:@"1"]) {
                [cellImage.retryBtn addTarget:self action:@selector(retryMsgClick:) forControlEvents:UIControlEventTouchUpInside];
                cellImage.retryBtn.tag = 99999 + indexPath.row;
                
                [cellImage.retryBtn setHidden:YES];
                switch (messageModel.msgUploadStatus) {
                    case MsgUploadStatusFailed:
                    {
                        [cellImage.retryBtn setHidden:NO];
                    }
                        break;
                    default:
                        break;
                }
            }
            return cellImage;
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
    
    if ([leaveMessage.isSend isEqualToString:@"1"])
    {
        //自己
        myCell = [tableView dequeueReusableCellWithIdentifier:MyCellIdentify];
        if (myCell == nil) {
            myCell = [[[NSBundle mainBundle] loadNibNamed:@"MessageDailogList_Cell2" owner:self options:nil] lastObject];
            [myCell setAttr];
            myCell.backgroundColor = UIColorFromRGB(0xf0f0f0);
        }
        [myCell setLeaveMessage:cellFrame];
        [myCell.retryBtn addTarget:self action:@selector(retryMsgClick:) forControlEvents:UIControlEventTouchUpInside];
        myCell.retryBtn.tag = 99999 + indexPath.row;
        
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
            [fromCell setAttr];
            fromCell.backgroundColor = UIColorFromRGB(0xf0f0f0);
        }
        
        [fromCell setLeaveMessage:cellFrame];
        fromCell.contentBtn.tag = indexPath.row;
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
        longPress.minimumPressDuration = 0.5; //定义按的时间
        [fromCell.contentBtn addGestureRecognizer:longPress];
        fromCell.resumeBtn.hidden = YES;
        return fromCell;
    }
}

- (void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
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

-(void)removeCopyBtn:(UITapGestureRecognizer *)sender
{
    [_delCopyImgv removeFromSuperview];
    [_editorBtn removeFromSuperview];
    copyTap = nil;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_delCopyImgv removeFromSuperview];
    [_editorBtn removeFromSuperview];
    [super scrollViewDidScroll:scrollView];
}

//自己视图的单击事件
-(void) viewSingleTap:(id)sender
{
    [self hideFaceView:YES];
    [_msgContentTV resignFirstResponder];
    [self hideShareView:YES];
}

-(void)hideShareView:(BOOL)toolBar
{
    isShareViewShow = NO;
    CGRect frameOne = shareAddView.frame;
    frameOne.origin.y = [UIScreen mainScreen].bounds.size.height - 64;
    shareAddView.frame = frameOne;
    
    if (!_faceScrollView.isShow && !_isKeyboardShow && toolBar)
    {
        [UIView animateWithDuration:0.26 animations:^{
            CGRect rect = tableView_.frame;
            rect.size.height = ScreenHeight-rect.origin.y-104-44;
            tableView_.frame = rect;
            
            _msgCVTrailing.constant = 0;
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
//    dispatch_async(dispatch_get_main_queue(), ^{
        _faceScrollView.isShow = NO;
        isShareViewShow = NO;
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
        
        //添加点击事件
        if (!_singleTapRecognizer) {
            _singleTapRecognizer = [MyCommon addTapGesture:tableView_ target:self numberOfTap:1 sel:@selector(viewSingleTap:)];
        }

        
        CGRect newFrame = self.view.frame;
        [UIView animateWithDuration:animationDuration animations:^{
            self.view.frame = newFrame;
        }];
    
        [UIView animateWithDuration:0.3 animations:^{
            _msgCVTrailing.constant = keyboardRect.size.height;
            [self.view layoutIfNeeded];
        }];
    
        //滚动内容
        if (_messageFrameList.count > 0) {
            CGRect rect = tableView_.frame;
            rect.size.height = ScreenHeight-104-rect.origin.y-keyboardRect.size.height-44;
            tableView_.frame = rect;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(_messageFrameList.count - 1) inSection:0];
            [tableView_ scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
       
        shareAddBtn.selected = NO;
        [self changeTextViewFrame];
//    });
}

-(void)mykeyboardWillHide:(NSNotification *)notification
{
    [MyCommon removeTapGesture:tableView_ ges:_singleTapRecognizer];
    _isKeyboardShow = NO;
    
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    CGRect rect = tableView_.frame;
    if (!isShareViewShow && !_faceScrollView.isShow)
    {
        if (rect.size.height != ScreenHeight - rect.origin.y - 104-44) {
            rect.size.height += _keyboardHeight;
            tableView_.frame = rect;
        }
        [UIView animateWithDuration:0.3 animations:^{
            _msgCVTrailing.constant = 0;
            [self.view layoutIfNeeded];
        }];
        
        [self viewSingleTap:nil];
        
        if (_messageFrameList.count > 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(_messageFrameList.count - 1) inSection:0];
            [tableView_ scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
    
    [UIView commitAnimations];
}

//显示表情
- (void)showFaceView {
    //添加点击事件
    if( !_singleTapRecognizer )
        _singleTapRecognizer = [MyCommon addTapGesture:tableView_ target:self numberOfTap:1 sel:@selector(viewSingleTap:)];
    if (_faceScrollView == nil) {
        [self initFaceView];
    }
    
    _faceScrollView.isShow = YES;
    _faceBtn.selected = YES;
    CGFloat faceBoardH = CGRectGetHeight(_faceScrollView.frame) ;
    //滚动内容
    if (_messageFrameList.count > 0) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = tableView_.frame;
            rect.size.height = ScreenHeight-104-rect.origin.y-faceBoardH-44;
            tableView_.frame = rect;
            
            if (_messageFrameList.count > 1) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(_messageFrameList.count - 1) inSection:0];
                [tableView_ scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
           
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
        
        _msgCVTrailing.constant = faceBoardH;
        
        shareAddView.frame = frameOne;
    } completion:^(BOOL finished) {
        
    }];
    isShareViewShow = NO;
    
    [self changeTextViewFrame];
}

- (void)initFaceView
{
    if (_faceScrollView == nil) {
        __weak ELGroupIMListCtl *this = self;
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
        frame.origin.y = y + 100;
        _faceScrollView.frame = frame;
        
        //工具栏
        if (hideToolBar ) {
            _msgCVTrailing.constant = 0;
            CGRect  rect = tableView_.frame;
            if (rect.size.height != ScreenHeight - rect.origin.y - 104-44) {
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
    
    [self changeTextViewFrame];
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

- (void)scrollTableToFoot:(BOOL)animated {
    NSInteger s = [tableView_ numberOfSections];
    if (s<1) return;
    NSInteger r = [tableView_ numberOfRowsInSection:s-1];
    if (r<1) return;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];
    [tableView_ scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

#pragma mark - 留言
- (IBAction)sendMsgBtnClick:(id)sender
{
    if(![MyCommon IsEnable3G] && ![MyCommon IsEnableWIFI])
    {
        [BaseUIViewController showAutoDismissAlertView:@"当前无网络,请检查网络" msg:nil seconds:2.0];
        [_msgContentTV resignFirstResponder];
        return;
    }
    if ([[_msgContentTV.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        return;
    }
    
    if ([MyCommon stringContainsEmoji:_msgContentTV.text])
    {
        [BaseUIViewController showAutoDismissFailView:@"提示" msg:@"当前不支持输入法自带表情" seconds:2.0];
        return;
    }

    User_DataModal *user = [Manager getUserInfo];
    NSString *fromUserId = user.userId_;
    if (!fromUserId) {
        [BaseUIViewController showAutoDismissFailView:@"登录后才能发信息" msg:nil seconds:2.0];
        return;
    }

    [_socketManager sendMessage:_msgContentTV.text GroupModel:_inDataModel TopicId:_inDataModel.auto_article_id TagId:nil QiId:@"1" ParentId:nil CommentType:@"1" ContentType:@"1" share:nil];
    
    _sendLeaveMessage = [[LeaveMessage_DataModel alloc]init];
    _sendLeaveMessage.attString = [self changeAttString:_msgContentTV.text tagLenght:0];
    _sendLeaveMessage.content = _msgContentTV.text;
    _sendLeaveMessage.isSend = @"1";
    _sendLeaveMessage.personPic = user.img_;
    _sendLeaveMessage.messageType = MessageTypeText;
    _sendLeaveMessage.personId = [Manager getUserInfo].userId_;
    _sendLeaveMessage.groupId = _inDataModel.group_id;
    _sendLeaveMessage.msgUploadStatus = MsgUploadStatusInit;
    [self timeIntervalue];
    
    ELGroupChatCellFrame *cellFrame = [[ELGroupChatCellFrame alloc]init];
    cellFrame.leaveMessage = _sendLeaveMessage;
    [_messageFrameList addObject:cellFrame];
    [_sendAndreceiceMsg addObject:cellFrame];
    
    [self saveMsgToDB:_sendLeaveMessage];
    NSLog(@"send");
    
    _msgContentTV.text = @"";
    [self changeTextViewFrame];
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
            
            textViewHeight = 0;
        }
        else{//隐藏
            if ([_msgContentTV isFirstResponder]) {
                [_msgContentTV resignFirstResponder];
            }
            
            _msgContentViewHeight.constant = 40;
            
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
            _faceScrollView.isShow = NO;
            [self hideFaceView:NO];
            [MyCommon removeTapGesture:tableView_ ges:_singleTapRecognizer];
            _singleTapRecognizer = nil;
            [_msgContentTV becomeFirstResponder];
        }
        else
        {//只显示faceview
            _faceScrollView.isShow = YES;
            
            if ([_msgContentTV isFirstResponder])
            {
                [_msgContentTV resignFirstResponder];
            }
            [self showFaceView];
        }
        [_msgContentTV setHidden:NO];
        [_voicelb setHidden:YES];
        _voiceMessageBtn.selected = NO;
        
    }
    else if(sender == shareAddBtn)
    {
        [self hideFaceView:NO];
        CGRect frame = shareAddView.frame;
        if (!shareAddBtn.selected)
        {
            isShareViewShow = YES;
            [_msgContentTV resignFirstResponder];
            frame.origin.y = [UIScreen mainScreen].bounds.size.height - 169 - 44;
            shareAddBtn.selected = YES;
            
            [UIView animateWithDuration:0.3 animations:^{
                shareAddView.frame = frame;
                _msgCVTrailing.constant = 105;
                
                CGRect rect = tableView_.frame;
                rect.size.height = ScreenHeight - rect.origin.y - 104-shareAddView.frame.size.height-44;
                tableView_.frame = rect;
                
                if (_messageFrameList.count > 1)
                {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(_messageFrameList.count - 1) inSection:0];
                    [tableView_ scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                }
            }];
        }
        else
        {
            isShareViewShow = NO;
            [_msgContentTV becomeFirstResponder];
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

-(void)showNoDataOkView:(BOOL)flag
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
    ELGroupChatCellFrame *cellFrame = _messageFrameList[row];
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
        userId = leaveMessage.toUserId;
    }
    ELPersonCenterCtl *personCenterCtl = [[ELPersonCenterCtl alloc] init];
    personCenterCtl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personCenterCtl animated:NO];
    [personCenterCtl beginLoad:userId exParam:nil];
}

//简历评论跳转
- (void)goArticledetail:(UIButton *)sender
{
    ELGroupChatCellFrame *cellFrame ;
    if (_messageFrameList.count > sender.tag) {
        cellFrame = [_messageFrameList objectAtIndex:sender.tag];
    }
    LeaveMessage_DataModel *leaveMessage = cellFrame.leaveMessage;
    
    if (leaveMessage.article_id.length > 2) {
        ArticleDetailCtl *articleDetailCtl_ = [[ArticleDetailCtl alloc] init];
        articleDetailCtl_.isFromGroup_ = YES;
        articleDetailCtl_.isEnablePop = YES;
        articleDetailCtl_.isFromCompanyGroup = YES;
        [self.navigationController pushViewController:articleDetailCtl_ animated:YES];
        [articleDetailCtl_ beginLoad:leaveMessage.article_id exParam:nil];
        
    }
}

//消息重发
- (void)retryMsgClick:(UIButton *)sender
{
    ELGroupChatCellFrame *cellFrame = [_messageFrameList objectAtIndex:sender.tag - 99999];
    if ([cellFrame isKindOfClass:[LeaveMessage_DataModel class]]) {
        LeaveMessage_DataModel *dataModel = (LeaveMessage_DataModel *)cellFrame;
        dataModel.msgUploadStatus = MsgUploadStatusInit;
        
        NSMutableDictionary *shareDic = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        
        NSString *contentType;
        if (dataModel.messageType == MessageTypeVoice) {
            contentType = @"5";
            [dic setObject:[NSString stringWithFormat:@"%@#%@", dataModel.imageUrl_, dataModel.voiceTime] forKey:@"path"];
        }
        else if(dataModel.messageType == MessageTypeImage) {
            contentType = @"4";
            [dic setObject:[NSString stringWithFormat:@"%@", dataModel.imageUrl_] forKey:@"path"];
        }
        
        [shareDic setObject:contentType forKey:@"type"];
        [shareDic setObject:dic forKey:@"slave"];
        
        SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
        NSString *shareStr = [jsonWriter stringWithObject:shareDic];
        
        [_socketManager sendMessage:dataModel.content GroupModel:_inDataModel TopicId:_inDataModel.auto_article_id TagId:nil QiId:@"1" ParentId:nil CommentType:@"3" ContentType:contentType share:shareStr];
    }
    else {
        LeaveMessage_DataModel *leaveMessage = cellFrame.leaveMessage;
        leaveMessage.msgUploadStatus = MsgUploadStatusInit;
        
        [_socketManager sendMessage:leaveMessage.content GroupModel:_inDataModel TopicId:_inDataModel.auto_article_id TagId:nil QiId:@"1" ParentId:nil CommentType:@"1" ContentType:@"1" share:nil];
    }
 
    [tableView_ reloadData];
    
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
        default:
            break;
    }
}

#pragma mark - 上传图片
-(void)uploadPhoto
{
    if(![MyCommon IsEnable3G] && ![MyCommon IsEnableWIFI])
    {
        [BaseUIViewController showAutoDismissAlertView:@"当前无网络,请检查网络" msg:nil seconds:2.0];
        return;
    }
    @try
    {
        NSData *imgData = UIImageJPEGRepresentation(shareImage, 0.1);
        NSDate * now = [NSDate date];
        NSString * timeStr = [now stringWithFormat:@"yyyy-MM-dd_HHmmss" timeZone:[NSTimeZone systemTimeZone] behavior:NSDateFormatterBehaviorDefault];
        RequestCon *uploadCon = [self getNewRequestCon:NO];
        
        [uploadCon uploadPhotoData:imgData name:[NSString stringWithFormat:@"%@.jpg",timeStr]];
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

#pragma mark - 语音播放
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
    NSString *fileName = [[tempModel.imageUrl_ componentsSeparatedByString:@"/"]lastObject];
    NSString *fileNameNoAmr = [[fileName componentsSeparatedByString:@"."]objectAtIndex:0];
    NSString *filePath = [VoiceRecorderBaseVC getPathByFileName:fileNameNoAmr ofType:@"aac"];
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    if (![fileManager fileExistsAtPath:filePath]) {
        //文件不存在
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:tempModel.imageUrl_]];
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

#pragma mark 开始播放
-(void)voicePlay
{
    player = [[AVAudioPlayer alloc]init];
    isplay_ = NO;
    [self handleNotification:NO];
    /*
    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
                            sizeof(sessionCategory),
                            &sessionCategory);
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                             sizeof (audioRouteOverride),
                             &audioRouteOverride);
    */
    
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


#pragma mark 播放结束
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

#pragma mark - 重写下拉刷新（改为下拉加载）
- (void)reloadTableViewDataSource:(EGORefreshTableView *)egoView
{
    if( egoView == refreshHeaderView_ ){
        [MyLog Log:@"header refresh" obj:self];
        
        //load more
        if (requestCon_.dataArr_.count > 0) {
            [self loadMoreData:requestCon_];
        }
        else {
            [self refreshLoad:requestCon_];
        }
    
    }else if( egoView == refreshFooterView_ ){
        [MyLog Log:@"foot load" obj:self];
        
        
    }else{
        [MyLog Log:@"null refresh" obj:self];
    }
}

- (void)updateLoadingCom:(RequestCon *)con
{
    [super updateLoadingCom:con];
    //防止中断请求后没有加载更多的刷新
    if( [requestCon_.dataArr_ count] > 0 ){
        if( requestCon_.pageInfo_.currentPage_ > requestCon_.pageInfo_.pageCnt_ ){
            [self showHeaderView:NO];
        }
        //还有更多数据
        else{
            [self showHeaderView:YES];
        }
    }
}

-(void) loadDataComplete:(RequestCon *)con code:(ErrorCode)code dataArr:(NSArray *)dataArr requestType:(int)type
{
    [super loadDataComplete:con code:code dataArr:dataArr requestType:type];
    
    if( con != nil ){
        [self doneLoadingTableViewData:refreshHeaderView_];
    }
}

#pragma mark - ELWebSocketManagerDelegate
- (ELWebSocketManager *)socketManager
{
    _socketManager = [ELWebSocketManager defaultManager];
    _socketManager.delegate = self;
    return _socketManager;
}

- (void)chatManager:(ELWebSocketManager *)manager didReceiceWSStatuChange:(ELWebSocketStatus)status
{
    switch (status) {
        case ELWebSocketStatusClose:
        case ELWebSocketStatusLogOffByServer:
        {
            [self updateMsgUploadStatus];
        }
            break;
        default:
            break;
    }
}

- (void)receiveSocketMsg:(NSNotification *)notifi
{
    NSLog(@"---------------------------%@----------------%@",[NSThread currentThread],[NSThread mainThread]);
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"---------------------------%@",[NSThread currentThread]);
        NSDictionary *messageDic= [notifi.userInfo objectForKey:@"data"];
        
        NSString *groupId = [messageDic objectForKey:@"id"];
        NSString *qiId = [messageDic objectForKey:@"qi_id_isdefault"];//1.默认话题 2.简历话题 0
        NSString *articleId = [messageDic objectForKey:@"topic_id"];
        // 1 纯文本  4图片  5语音
        NSString *contentType = [NSString stringWithFormat:@"%@", [messageDic objectForKey:@"comment_content_type"]];
        
        NSString *personId = [messageDic objectForKey:@"from_id"];
        NSString *personName = [messageDic objectForKey:@"username"];
        NSString *personPic = [messageDic objectForKey:@"avatar"];
        NSDictionary *sharedic = [messageDic objectForKey:@"share"];
    
        if (![personId isEqualToString:[Manager getUserInfo].userId_] || ([personId isEqualToString:[Manager getUserInfo].userId_] && [qiId isEqualToString:@"2"]))
        {
                if (([groupId isEqualToString:_inDataModel.group_id] && [qiId isEqualToString:@"2"])
                    || [articleId isEqualToString:_inDataModel.auto_article_id])
                {
                    LeaveMessage_DataModel *messageModel = [[LeaveMessage_DataModel alloc] init];
                    if ([personId isEqualToString:[Manager getUserInfo].userId_]) {
                        messageModel.isSend = @"1";
                        messageModel.personIName = @"";
                    }
                    else {
                        messageModel.isSend = @"0";
                        messageModel.personIName = personName;
                    }
                    
                    messageModel.personPic = personPic;
                    messageModel.toUserId = personId;
                    messageModel.qi_id_isdefault = qiId;
                    
                    NSString *timeStr = [MyCommon getDateWithMsecTime:[messageDic objectForKey:@"timestamp"]];
                    NSDate *date = [MyCommon getDate:timeStr];
                    messageModel.date = [MyCommon getWhoLikeMeListCurrentTime:date currentTimeString:timeStr];
                    if ([messageModel.date isEqualToString:@"0秒前"]) {
                        messageModel.date = @"刚刚";
                    }
                    
                    NSString *content = [messageDic objectForKey:@"content"];
                    if ([content isEqualToString:@""]) {
                        return;
                    }
                    
                    NSString *tagId = [messageDic objectForKey:@"contentTag"];
                    for (ResumeCommentTag_DataModal *tagModel in _tagArray) {
                        if ([tagId isEqualToString:tagModel.tagId_]) {
                            content = [NSString stringWithFormat:@"%@ #%@#", content, tagModel.tagName_];
                            messageModel.tagName = tagModel.tagName_;
                            break;
                        }
                    }
                    
                    if (!isAddNewMessage) {
                        [newMessageArr removeAllObjects];
                    }
                    
                    if ([contentType isEqualToString:@"1"] || [contentType isEqualToString:@"11"])
                    {//纯文本   来自简历话题
                        if ([qiId isEqualToString:@"2"] && ![sharedic isKindOfClass:[NSNull class]]) {
                            messageModel.article_id = [[sharedic objectForKey:@"slave"] objectForKey:@"article_id"];
                            content = [self componentsMsgContentString:content];
                        }
                        
                        messageModel.attString = [self changeAttString:content tagLenght:messageModel.tagName.length];
                        messageModel.messageType = MessageTypeText;
                        
                        ELGroupChatCellFrame *cellFrame = [[ELGroupChatCellFrame alloc]init];
                        cellFrame.leaveMessage = messageModel;
                        [newMessageArr addObject:cellFrame];
                        
                        [_sendAndreceiceMsg addObject:cellFrame];
                    }
                    else if ([contentType isEqualToString:@"4"])
                    {//图片
                        if (![sharedic isKindOfClass:[NSNull class]]) {
                            messageModel.imageUrl_ = [[sharedic objectForKey:@"slave"] objectForKey:@"path"];
                            messageModel.messageType = MessageTypeImage;
                            [newMessageArr addObject:messageModel];
                            [_sendAndreceiceMsg addObject:messageModel];
                        }
                    }
                    else if ([contentType isEqualToString:@"5"])
                    {//语音
                        if (![sharedic isKindOfClass:[NSNull class]]) {
                            NSString *tempStr = [[sharedic objectForKey:@"slave"] objectForKey:@"path"];
                            messageModel.imageUrl_ = tempStr;
                            NSArray *voiceArr = [tempStr componentsSeparatedByString:@"#"];
                            messageModel.voiceTime = [voiceArr lastObject];
                            if ([voiceArr count] >=2) {
                                messageModel.voiceTime = [voiceArr lastObject];
                            }
                            
                            messageModel.content = [voiceArr firstObject];
                            messageModel.messageType = MessageTypeVoice;
                            [newMessageArr addObject:messageModel];
                            [_sendAndreceiceMsg addObject:messageModel];
                        }
                    }
                    
                   
                    if (!isAddNewMessage) {
                        isAddNewMessage = YES;
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self addNewMessage];
                        });
                    }
                    
                }
           
        }
        else if([personId isEqualToString:[Manager getUserInfo].userId_]) {
            //接收到自己发送的消息时不插入数据
            NSString *contentStr;
            if ([contentType isEqualToString:@"4"] || [contentType isEqualToString:@"5"]) {
                contentStr = [[sharedic objectForKey:@"slave"] objectForKey:@"path"];
                if ([contentType isEqualToString:@"5"]) {
                    contentStr = [[contentStr componentsSeparatedByString:@"#"] firstObject];
                }
            }
            else {
                contentStr = [messageDic objectForKey:@"content"];
            }
            
            [self deleteDataBaseMsg:contentStr contentType:contentType];
        }
//     });
}

- (void)addNewMessage
{
    if (canAddNewMessage) {
        isAddNewMessage = NO;
        [_messageFrameList addObjectsFromArray:newMessageArr];

        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"123456676---------------------------%@",[NSThread currentThread]);
            [tableView_ reloadData];
            [self scrollTableToFoot:YES];
        });
    }
}

- (void)hideBottomView:(NSNotification *)notifi
{
    [_msgContentTV resignFirstResponder];
    
    [self hideFaceView:YES];
    [self hideShareView:YES];
    
    [self stopVoice];
}

//简历话题评论标签
- (void)requestResumeTag
{
    if (!_tagArray) {
        _tagArray = [[NSMutableArray alloc] init];
    }
    
    NSString *op = @"yl_tag_busi";
    NSString *func = @"getZpgroupResumeCommentTag";
    
    NSString *source = @"zp_group_all";
    NSString *bodyMsg = [NSString stringWithFormat:@"source=%@", source];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:func requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        NSDictionary *dict = result;
        NSArray *tagArr = [dict objectForKey:@"info"];
        if (![tagArr isKindOfClass:[NSNull class]]) {
            for (NSDictionary *tagDic in tagArr) {
                ResumeCommentTag_DataModal *model = [[ResumeCommentTag_DataModal alloc] init];
                model.tagId_ = [tagDic objectForKey:@"labelId"];
                model.tagName_ = [tagDic objectForKey:@"labelName"];
                [_tagArray addObject:model];
            }
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

//发送消息时间戳
- (void)timeIntervalue
{
    NSDictionary *dic = [NSDictionary dictionary];
    NSMutableDictionary *saveDic = [NSMutableDictionary dictionary];
    dic = [[NSUserDefaults standardUserDefaults] objectForKey:_inDataModel.group_id];
    
    if (![dic isKindOfClass:[NSDictionary class]]) {
        _sendLeaveMessage.date = @"刚刚";
        
        [saveDic setObject:[NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]] forKey:@"sendLeaveMessageTime"];
        [saveDic setObject:[NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]] forKey:@"indirectTimeInterval"];
        
        NSDictionary *tempDic = [NSDictionary dictionaryWithDictionary:saveDic];
        [[NSUserDefaults standardUserDefaults] setObject:tempDic forKey:_inDataModel.group_id];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return;
    }
    
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
    [[NSUserDefaults standardUserDefaults] setObject:tempDic forKey:_inDataModel.group_id];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 数据缓存
- (void)saveMsgToDB:(LeaveMessage_DataModel *)dataModel
{
    NSIndexPath *index = [NSIndexPath indexPathForRow:_messageFrameList.count-1 inSection:0];
    [tableView_ insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationBottom];
    
    if (tableView_.contentOffset.y + ScreenHeight > tableView_.contentSize.height) {
        [self scrollTableToFoot:YES];
    }
    
    msgId += 1;
    dataModel.msgId = [NSString stringWithFormat:@"%ld", (long)msgId];
    [_msgDao save:dataModel];
    [_cacheMsgArr addObject:dataModel];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", (long)msgId] forKey:@"msgId"];
}

//添加缓存数据到列表
- (void)addCacheMsgInfo
{
    isAddCacheMsg = NO;
    NSArray *msgArr = [_msgDao showAll:[Manager getUserInfo].userId_ groupId:_inDataModel.group_id];
    [_cacheMsgArr addObjectsFromArray:msgArr];
    if (msgArr.count > 0) {
        for (LeaveMessage_DataModel *model in msgArr) {
            if ([model.groupId isEqualToString:_inDataModel.group_id]
                || [model.personId isEqualToString:[Manager getUserInfo].userId_])
            {
                model.msgUploadStatus = MsgUploadStatusFailed;
                model.attString = [self changeAttString:model.content tagLenght:model.tagName.length];
                
                if (model.messageType == MessageTypeText) {
                    ELGroupChatCellFrame *cellFrame = [[ELGroupChatCellFrame alloc]init];
                    cellFrame.leaveMessage = model;
                    [_messageFrameList addObject:cellFrame];
                }
                else {
                    [_messageFrameList addObject:model];
                }
            }
        }
    }
}

//消息发送成功后删除缓存数据库里的对应数据
- (void)deleteDataBaseMsg:(NSString *)content contentType:(NSString *)contentType
{
    LeaveMessage_DataModel *deleteModel;
    for (LeaveMessage_DataModel *model in _cacheMsgArr) {
        if ([contentType isEqualToString:@"4"] || [contentType isEqualToString:@"5"]) {
            if ([content isEqualToString:model.imageUrl_]) {
                deleteModel = model;
            }
        }
        else {
            NSString *modelString=[model.attString string];
            if ([content isEqualToString:modelString] || [content isEqualToString:model.content]) {
                deleteModel = model;
            }
        }
    }
    
    if (deleteModel != nil) {
        deleteModel.msgUploadStatus = MsgUploadStatusOk;
        [_cacheMsgArr removeObject:deleteModel];
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableView_ reloadData];
            [_msgDao deleteData:deleteModel.msgId info:_inDataModel.group_id personId:[Manager getUserInfo].userId_];
        });
    }
}

//当网络、webSocket断开时刷新正在发送的消息的状态（发送失败）
- (void)AFNReachabilityMonitoring
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
            {
                NSLog(@"无网络");
                [self updateMsgUploadStatus];
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                NSLog(@"无线网络");
                NSLog(@"WiFi网络");
                break;
            }
            default:
                break;
        }
    }];
}

- (void)updateMsgUploadStatus
{
    if (_messageFrameList.count > 0)
    {
        for (NSInteger i = 0; i < _messageFrameList.count; i++)
        {
            ELGroupChatCellFrame *cellFrame = [_messageFrameList objectAtIndex:i];
            if ([cellFrame isKindOfClass:[LeaveMessage_DataModel class]])
            {
                LeaveMessage_DataModel *messageModel = (LeaveMessage_DataModel *)cellFrame;
                if ([messageModel.isSend isEqualToString:@"1"]
                    && (messageModel.msgUploadStatus == MsgUploadStatusInit
                        || messageModel.msgUploadStatus == MsgUploadStatusUpLoading))
                {
                    messageModel.msgUploadStatus = MsgUploadStatusFailed;
                    [_msgDao updateOneData:messageModel];
                }
                
            }
            else {
                if ([cellFrame.leaveMessage.isSend isEqualToString:@"1"]
                    && (cellFrame.leaveMessage.msgUploadStatus == MsgUploadStatusInit
                        || cellFrame.leaveMessage.msgUploadStatus == MsgUploadStatusUpLoading))
                {
                    cellFrame.leaveMessage.msgUploadStatus = MsgUploadStatusFailed;
                    [_msgDao updateOneData:cellFrame.leaveMessage];
                }
            }
        }
        
        [tableView_ reloadData];
    }
}

//干掉<a>标签下划线
- (NSString *)componentsMsgContentString:(NSString *)content
{
    NSString *text = content;
    if ([text containsString:@"href=\""]) {
        NSRange range = [text rangeOfString:@"href=\""];
        NSInteger length = 0;
        for (NSInteger i = range.location+range.length;i<text.length;i++) {
            NSString *str = [text substringWithRange:NSMakeRange(i,1)];
            if ([str isEqualToString:@"\""]) {
                break;
            }
            length ++;
        }
        content = [text stringByReplacingCharactersInRange:NSMakeRange(range.location+range.length,length) withString:@"#"];
    }
    return content;
}

- (NSMutableAttributedString *)changeAttString:(NSString *)content tagLenght:(NSUInteger)tagLenght
{
    NSMutableAttributedString *attributedString;
    if ([content containsString:@"<a"]) {
        attributedString = [[NSMutableAttributedString alloc] initWithData:[content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        attributedString = [[Manager shareMgr] getEmojiStringWithAttString:attributedString withImageSize:CGSizeMake(18, 18)];
        
        if (tagLenght > 0) {
            [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x0200FF) range:NSMakeRange(attributedString.length-tagLenght-2, tagLenght+2)];
        }
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, attributedString.length)];
    }
    else {
        attributedString = [[Manager shareMgr] getEmojiStringWithString:content withImageSize:CGSizeMake(18, 18)];
    }
    
    return attributedString;
}


@end
