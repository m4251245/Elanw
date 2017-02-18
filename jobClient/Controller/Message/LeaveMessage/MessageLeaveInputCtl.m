//
//  MessageLeaveInputCtl.m
//  jobClient
//
//  Created by 一览ios on 14/12/10.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "MessageLeaveInputCtl.h"
#import "LeaveMessage_DataModel.h"
#import "NoLoginPromptCtl.h"

@interface MessageLeaveInputCtl () <NoLoginDelegate>
{
    LeaveMessage_DataModel *_inDataModel;
}
@end

@implementation MessageLeaveInputCtl

-(id) init
{
    self = [super init];
    rightNavBarStr_ = @"提交";
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = @"留言";
    [self setNavTitle:@"留言"];
    
    // Do any additional setup after loading the view.
    
    _contentTv.delegate = self;
    
    //设置圆角
    CALayer *layer=[_contentTv layer];
    [layer setMasksToBounds:YES];
    [layer setBorderWidth:1.0];
    [layer setCornerRadius:4.0];
    [layer setBorderColor:[[UIColor colorWithRed:215.0/255 green:215.0/255 blue:215.0/255 alpha:1] CGColor]];
    
    _promptLb.text = [NSString stringWithFormat:@"您还可以输入%d个字符",Max_Comment_Length];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) updateCom:(RequestCon *)con
{
    [super updateCom:con];
    _nameLb.text = _inDataModel.toUserName;
}

-(void) beginLoad:(id)dataModal exParam:(id)exParam
{
    _inDataModel = dataModal;
    _contentTv.text = @"";
    _promptLb.text = [NSString stringWithFormat:@"您还可以输入%d个字符",Max_Comment_Length];
    [self updateCom:nil];
}

//留言
-(void) addLeaveMessage
{
    if( _contentTv.text.length < Min_Comment_Length ){
        [BaseUIViewController showAlertView:nil msg:[NSString stringWithFormat:@"留言内容长度不能少于%d个字符",Min_Comment_Length] btnTitle:@"确定"];
        return;
    }
    [_contentTv resignFirstResponder];
    [super beginLoad:nil exParam:nil];
}

-(void) getDataFunction:(RequestCon *)con
{
    _contentTv.text = [MyCommon convertContent:_contentTv.text];
    NSString *fromUserId = [Manager getUserInfo].userId_;
    if (!fromUserId) {
        [BaseUIViewController showAutoDismissFailView:@"登录后才能留言" msg:nil seconds:2.0];
    }
    NSString *fromUserId2 = @"15698343";
    NSString *toUserId = @"15345108";
    [requestCon_ leaveMsgContent:_contentTv.text from:fromUserId2 to:toUserId hrFlag:NO shareType:@"" productType:@"" recordId:@""];
}

-(void) finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch ( type ) {
        case Request_LeaveMessage:
        {
            Status_DataModal *dataModal = [dataArr objectAtIndex:0];
            if( [dataModal.status_ isEqualToString:Success_Status] ){
                [BaseUIViewController showAutoDismissAlertView:nil msg:@"留言成功" seconds:2.0];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else if( [dataModal.status_ isEqualToString:Fail_Status] ){
                
                
                [BaseUIViewController showAutoDismissAlertView:nil msg:@"" seconds:2.0];
                [self.navigationController popViewControllerAnimated:YES];
            } else{
                [BaseUIViewController showAlertView:nil msg:@"留言失败,请稍后再试" btnTitle:@"确定"];
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
    _promptLb.text = [NSString stringWithFormat:@"您还可以输入%ld个字符",(long)(Max_Comment_Length-textView.text.length)];
    
    if( Max_Comment_Length-textView.text.length <= 0 ){
        [textView resignFirstResponder];
    }
}

-(void) rightBarBtnResponse:(id)sender
{
    if (![Manager shareMgr].haveLogin) {
        
        [_contentTv resignFirstResponder];
       [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
        // [self showChooseAlertView:1 title:@"您尚未登录" msg:@"请先登录" okBtnTitle:@"登录" cancelBtnTitle:@"取消"];
    }
    else
    {
        [super rightBarBtnResponse:sender];
        [self addLeaveMessage];
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
    [_contentTv resignFirstResponder];
}


@end
