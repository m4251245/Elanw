//
//  ReplyCommentCtl.m
//  MBA
//
//  Created by sysweal on 13-11-21.
//  Copyright (c) 2013年 job1001. All rights reserved.
//

#import "ReplyAnswerCommentCtl.h"
#import "FaceScrollView.h"

@interface ReplyAnswerCommentCtl ()
{
    FaceScrollView *_faceScrollView;
}
@end

@implementation ReplyAnswerCommentCtl

@synthesize nameLb_,contentTv_,promptLb_,objId_,typeStr_,delegate_,proId_,answerModel_;

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
    [super viewWillDisappear:animated];
    [self.contentTv_ resignFirstResponder];
    [self hideFaceView];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = @"回复";
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) updateCom:(RequestCon *)con
{
    [super updateCom:con];
    if (!inDataModal_.author.nickname_ || [inDataModal_.author.nickname_ isEqualToString:@""]) {
        inDataModal_.author.nickname_ = inDataModal_.author.iname_;
    }
    nameLb_.text = inDataModal_.author.nickname_;
}

-(void) beginLoad:(id)dataModal exParam:(id)exParam
{
    inDataModal_ = dataModal;
    contentTv_.text = @"";
    promptLb_.text = [NSString stringWithFormat:@"您还可以输入%d个字符",Max_Comment_Length];
    
    [self updateCom:nil];
}

//添加回复
-(void) addReply
{
    if( contentTv_.text.length < Min_Comment_Length ){
        [BaseUIViewController showAlertView:nil msg:[NSString stringWithFormat:@"评论内容长度不能少于%d个字符",Min_Comment_Length] btnTitle:@"确定"];
        return;
    }
    
    [contentTv_ resignFirstResponder];
    [super beginLoad:nil exParam:nil];
}

-(void) getDataFunction:(RequestCon *)con
{
    contentTv_.text = [MyCommon convertContent:contentTv_.text];
    [con submitAnwserComment:[Manager getUserInfo].userId_ answerId:answerModel_.answerId_ content:contentTv_.text parentid:inDataModal_.id_ reUserId:inDataModal_.userId_];
}

-(void) finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch ( type ) {
        case Request_SubmitAnswerComment:
        {
            Status_DataModal *dataModal = [dataArr objectAtIndex:0];
            
            if( [dataModal.code_ isEqualToString:@"200"] ){
                [BaseUIViewController showAutoDismissAlertView:nil msg:@"回复成功" seconds:2.0];
                [self.navigationController popViewControllerAnimated:YES];
                
                
                [delegate_ addReplyAnswerCommentOK:self dataModal:nil];
            }else{
                [BaseUIViewController showAlertView:nil msg:@"回复失败,请稍后再试" btnTitle:@"确定"];
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
    promptLb_.text = [NSString stringWithFormat:@"您还可以输入%ld字符",(long)(Max_Comment_Length-textView.text.length)];

    if( Max_Comment_Length-textView.text.length <= 0 ){
        [textView resignFirstResponder];
    }
}

- (void)btnResponse:(id)sender
{
    if (sender == _faceBtn) {//显示表情
        if (!_faceBtn.selected) {
            _faceBtn.selected = YES;
            [contentTv_ resignFirstResponder];
            [self showFaceView];
        }else{
            _faceBtn.selected = NO;
            [contentTv_ becomeFirstResponder];
            [self hideFaceView];
        }
    }
}

//显示表情
- (void)showFaceView {
    [self.contentTv_ resignFirstResponder];
    if (_faceScrollView == nil) {
        __weak ReplyAnswerCommentCtl *this = self;
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
        //            _faceScrollView.transform = CGAffineTransformIdentity;
    }];
}

-(void) rightBarBtnResponse:(id)sender
{
    [super rightBarBtnResponse:sender];

    [self addReply];
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

@end
