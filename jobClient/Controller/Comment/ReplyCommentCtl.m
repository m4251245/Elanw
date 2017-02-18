//
//  ReplyCommentCtl.m
//  MBA
//
//  Created by sysweal on 13-11-21.
//  Copyright (c) 2013年 job1001. All rights reserved.
//

#import "ReplyCommentCtl.h"
#import "FaceScrollView.h"
#import "NoLoginPromptCtl.h"
#import "ELGroupCommentModel.h"
#import "ELWebSocketManager.h"
#import "ELGroupDetailModal.h"

@interface ReplyCommentCtl ()<UITextViewDelegate,NoLoginDelegate,ELWebSocketManagerDelegate>
{
    FaceScrollView *_faceScrollView;
//    ELWebSocketManager *websocket;
}
//@property (nonatomic, strong) ELWebSocketManager *websocket;
@end

@implementation ReplyCommentCtl

@synthesize nameLb_,contentTv_,promptLb_,objId_,typeStr_,delegate_,proId_;

-(id) init
{
    self = [super init];
    
    rightNavBarStr_ = @"提交";
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self hideFaceView];
    [self.contentTv_ resignFirstResponder];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"回复"];
    
	// Do any additional setup after loading the view.
    
    contentTv_.delegate = self;
    
    //设置圆角
    CALayer *layer=[contentTv_ layer];
    [layer setMasksToBounds:YES];
    [layer setBorderWidth:1.0];
    [layer setCornerRadius:4.0];
    [layer setBorderColor:[[UIColor colorWithRed:215.0/255 green:215.0/255 blue:215.0/255 alpha:1] CGColor]];
    [_faceBtn setImage:[UIImage imageNamed:@"icon_keyboard.png"] forState:UIControlStateSelected];
    promptLb_.text = [NSString stringWithFormat:@"您还可以输入%d个字符",Max_Comment_Length];
}

- (void)viewDidAppear:(BOOL)animated
{
    [ELWebSocketManager defaultManager].delegate = self;
    NSLog(@"websocket.delegate : %@", [ELWebSocketManager defaultManager].delegate);
}

-(void) updateCom:(RequestCon *)con
{
    [super updateCom:con];
    if ([typeStr_ isEqualToString:@"灌薪水"]) {
        nameLb_.text = @"匿名";
    }
    else
    {
        if (!inDataModal_.person_nickname || [inDataModal_.person_nickname isEqualToString:@""]) {
            inDataModal_.person_nickname = inDataModal_.person_iname;
        }
        nameLb_.text = inDataModal_.person_iname;
    }
    
}

-(void) beginLoad:(id)dataModal exParam:(id)exParam
{
    if ([dataModal isKindOfClass:[Comment_DataModal class]]) {
        Comment_DataModal *model = (Comment_DataModal *)dataModal;
        inDataModal_ = [[ELGroupCommentModel alloc] init];
        inDataModal_.person_nickname = model.author.nickname_;
        inDataModal_.person_iname = model.author.iname_;
        inDataModal_.id_ = model.id_;
    }else{
        inDataModal_ = dataModal;
    }
    contentTv_.text = @"";
    promptLb_.text = [NSString stringWithFormat:@"您还可以输入%d个字符",Max_Comment_Length];
    
    [self updateCom:nil];
}

//添加回复
-(void) addReply
{
    if ([[contentTv_.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0 ) {
        [BaseUIViewController showAutoDismissFailView:@"评论内容不能为空" msg:nil];
        return;
    }
    if( contentTv_.text.length < Min_Comment_Length ){
        [BaseUIViewController showAlertView:nil msg:[NSString stringWithFormat:@"评论内容长度不能少于%d个字符",Min_Comment_Length] btnTitle:@"确定"];
        return;
    }
    
    [contentTv_ resignFirstResponder];
    [super beginLoad:nil exParam:nil];
}

-(void) getDataFunction:(RequestCon *)con
{
    //parentId 评论的Id
    contentTv_.text = [MyCommon convertContent:contentTv_.text];
    if (_isCompanyGroup){
        if (_isNiMingComment) {
            [con addComment:objId_ parentId:inDataModal_.id_ userId:_niMingPersonId content:contentTv_.text proID:proId_ insider:[Manager getUserInfo].userId_];
        }else{
            [con addComment:objId_ parentId:inDataModal_.id_ userId:[Manager getUserInfo].userId_ content:contentTv_.text proID:proId_ insider:@""];
        }
    }
    else{
        if (_groupModel != nil) {
            //webSocket
            if ([_qiId isEqualToString:@"2"]) {
                [[ELWebSocketManager defaultManager] sendMessage:contentTv_.text GroupModel:_groupModel TopicId:objId_ TagId:nil QiId:_qiId ParentId:inDataModal_.id_ CommentType:@"3" ContentType:@"11" share:nil];
            }
            else {
                [[ELWebSocketManager defaultManager] sendMessage:contentTv_.text GroupModel:_groupModel TopicId:objId_ TagId:nil QiId:_qiId ParentId:inDataModal_.id_ CommentType:@"1" ContentType:@"1" share:nil];
            }
        }
        else {
            [con addComment:objId_ parentId:inDataModal_.id_ userId:[Manager getUserInfo].userId_ content:contentTv_.text proID:proId_];
        }
    }
}

-(void) finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch ( type ) {
        case Request_AddComment:
        {
            Status_DataModal *dataModal = [dataArr objectAtIndex:0];
            
            if( [dataModal.status_ isEqualToString:Success_Status] ){
                [BaseUIViewController showAutoDismissAlertView:nil msg:@"回复成功" seconds:2.0];
                [delegate_ addReplyCommentOK:self dataModal:nil];
                [self.navigationController popViewControllerAnimated:YES];
                NSString * typeStr = [RegCtl getRegTypeStr:[Manager shareMgr].registeType_];
                NSDictionary *dict = @{@"Source" : typeStr};
                [MobClick event:@"commentCount" attributes:dict];
            }else{
                [BaseUIViewController showAutoDismissFailView:nil msg:dataModal.des_ seconds:1.0];
            }
        }
            break;
        default:
            break;
    }
}

#pragma UITextViewDelegate
-(void) textViewDidChange:(UITextView *)textView
{
    promptLb_.text = [NSString stringWithFormat:@"您还可以输入%ld个字符",(long)Max_Comment_Length-textView.text.length];

    if( Max_Comment_Length-textView.text.length <= 0 ){
        [textView resignFirstResponder];
    }
}

-(void) rightBarBtnResponse:(id)sender
{
    if (![Manager shareMgr].haveLogin) {
        
        [contentTv_ resignFirstResponder];
        [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
        //[self showChooseAlertView:1 title:@"您尚未登录" msg:@"请先登录" okBtnTitle:@"登录" cancelBtnTitle:@"取消"];
    }
    else
    {
        [super rightBarBtnResponse:sender];
        [self addReply];
    }
}

-(void)loginDelegateCtl
{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}

-(void) alertViewChoosed:(UIAlertView *)alertView index:(int)index type:(int)type
{
    switch ( type ) {
        case 1:
        {
            [[Manager shareMgr] loginOut];
            [Manager shareMgr].haveLogin = NO;
        }
            break;
            
        default:
            break;
    }
}


-(void)backBarBtnResponse:(id)sender
{
    [super backBarBtnResponse:sender];
    [contentTv_ resignFirstResponder];
}

- (void)btnResponse:(id)sender
{
    if (sender == _faceBtn) {//显示表情
        if (!_faceBtn.selected) {
            [contentTv_ resignFirstResponder];
            [self showFaceView];
        }else{
            [contentTv_ becomeFirstResponder];
            [self hideFaceView];
        }
        _faceBtn.selected = !_faceBtn.selected;
    }
}

//显示表情
- (void)showFaceView {
    [self.contentTv_ resignFirstResponder];
    if (_faceScrollView == nil) {
        __weak ReplyCommentCtl *this = self;
        _faceScrollView = [[FaceScrollView alloc] initWithBlock:^(NSString *faceName) {
            if ([faceName isEqualToString:@"delete"]) {
                NSString *text = this.contentTv_.text;
                if (!text || [text isEqualToString:@""]) {
                    return ;
                }
                NSString *result = [MyCommon substringExceptLastEmoji:text];
                if (![text isEqualToString:result]) {
                    this.contentTv_.text = result;
                }else{
                    this.contentTv_.text = [text substringToIndex:text.length-1];
                }
                return;
            }
            NSString *temp = this.contentTv_.text;
            this.contentTv_.text = [temp stringByAppendingFormat:@"%@", faceName];
        }];
        _faceScrollView.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0];
        _faceScrollView->faceView.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0];
        _faceScrollView.frame = CGRectMake(0, self.view.bounds.size.height, 0, 0);
        [self.view addSubview:_faceScrollView];
    }
    
    
    if (!_faceScrollView.isShow) {
        _faceScrollView.frame = CGRectMake(0, self.view.bounds.size.height, 0, 0);
        _faceScrollView.isShow = YES;
        [UIView animateWithDuration:0.3 animations:^{
//            _faceScrollView.transform = CGAffineTransformTranslate(_faceScrollView.transform, 0, self.view.bounds.size.height - _faceScrollView.height);
            CGRect frame = _faceScrollView.frame;
            frame.origin.y -= _faceScrollView.height;
            _faceScrollView.frame = frame;
        }];
    }else{
        [self hideFaceView];
    }
    
}

- (void)hideFaceView
{
    _faceScrollView.isShow = NO;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _faceScrollView.frame;
        frame.origin.y = self.view.bounds.size.height;
        _faceScrollView.frame = frame;
        //_faceScrollView.transform = CGAffineTransformIdentity;
    }];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (_faceScrollView.isShow) {
        [self hideFaceView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *content = textView.text;
    if(range.length == 1 && [text isEqualToString:@""]) {
        NSString *result = [MyCommon substringExceptLastEmoji:content];
        if (![content isEqualToString:result]) {
            textView.text = result;
            return NO;
        }
    }
    return YES;
}

#pragma mark - ELWebSocketDelegate
- (void)chatManager:(ELWebSocketManager *)manager didSendMessage:(NSDictionary *)messageDic
{
    [BaseUIViewController showAutoDismissAlertView:nil msg:@"回复成功" seconds:2.0];
    [delegate_ addReplyCommentOK:self dataModal:nil];
    [self.navigationController popViewControllerAnimated:YES];
    NSString * typeStr = [RegCtl getRegTypeStr:[Manager shareMgr].registeType_];
    NSDictionary *dict = @{@"Source" : typeStr};
    [MobClick event:@"commentCount" attributes:dict];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
