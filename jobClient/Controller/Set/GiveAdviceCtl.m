//
//  GiveAdviceCtl.m
//  MBA
//
//  Created by sysweal on 13-12-11.
//  Copyright (c) 2013年 job1001. All rights reserved.
//

#import "GiveAdviceCtl.h"
#import "Status_DataModal.h"

@implementation GiveAdviceCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = @"意见反馈";
    [self setNavTitle:@"意见反馈"];
    contentView_.layer.borderWidth = 1;
    contentView_.layer.borderColor = [[UIColor colorWithRed:191.0/255.0 green:191.0/255.0 blue:191.0/255.0 alpha:1.0] CGColor];
    sumbitBtn_.layer.cornerRadius = 4.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
}

-(void)getDataFunction:(RequestCon *)con
{
    
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
}

-(void)textViewDidChange:(UITextView *)textView
{
    if ([MyCommon removeSpaceAtSides:textView.text].length == 0) {
        [placeholderLb_ setHidden:NO];
    }else{
        [placeholderLb_ setHidden:YES];
    }
}

//提交意见
-(void) sumbitAdvice
{
    NSString * msg = [MyCommon removeSpaceAtSides:msgTextView_.text];
    if( [msg length] == 0 )
    {
        [BaseUIViewController showAlertView:nil msg:@"请输入您想发表的意见" btnTitle:@"我知道了"];
        msgTextView_.text = @"";
        return;
    }
    
    if( [msg length] > GiveAdviceMsg_MaxLength || [msg length] < GiveAdviceMsg_MinLength )
    {
        NSString *alertMsg = [[NSString alloc] initWithFormat:@"您最少得输入:%d个字符 最多能输入:%d个字符",GiveAdviceMsg_MinLength,GiveAdviceMsg_MaxLength];
        [BaseUIViewController showAlertView:nil msg:alertMsg btnTitle:@"我知道了"];
        return;
    }
    
    if (emailTextField_.text.length > 0) {
        if (![MyCommon isValidateEmail:emailTextField_.text]) {
            [BaseUIViewController showAlertView:nil msg:@"请输入正确的邮箱" btnTitle:@"我知道了"];
            return;
        }
    }
    
    if (phoneNumTextField_.text.length > 0) {
        if (![MyCommon isMobile:phoneNumTextField_.text]) {
            [BaseUIViewController showAlertView:nil msg:@"请输入正确的手机号码" btnTitle:@"我知道了"];
            return;
        }
    }
    
    
    NSString * contentStr = [MyCommon convertContent:msgTextView_.text];
    NSString * contact = [[NSString alloc]init];
    if ([MyCommon isMobile:phoneNumTextField_.text]) {
        contact = phoneNumTextField_.text;
    }else{
        contact = emailTextField_.text;
    }

    if (!adviceCon_) {
        adviceCon_ = [self getNewRequestCon:NO];
    }
    [adviceCon_ giveAdvice:contentStr contact:contact];
}


-(void) finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch ( type ) {
        case Request_FeedBack:
        {
            Status_DataModal *dataModal = [dataArr objectAtIndex:0];
        
            if( [dataModal.status_ isEqualToString:@"OK"] ){
                [BaseUIViewController showAutoDismissAlertView:@"提交成功" msg:nil seconds:2.0];
                msgTextView_.text = @"";
                [msgTextView_ resignFirstResponder];
                [phoneNumTextField_ resignFirstResponder];
                [emailTextField_ resignFirstResponder];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [BaseUIViewController showAlertView:@"提交失败" msg:@"请稍候再试" btnTitle:@"确定"];
            }
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //进入下一项
    if( textField == emailTextField_ )
    {
        [phoneNumTextField_ becomeFirstResponder];
    }
    
    return YES;
}

-(void)backBarBtnResponse:(id)sender
{
    [super backBarBtnResponse:sender];
    [msgTextView_ resignFirstResponder];
    [phoneNumTextField_ resignFirstResponder];
    [emailTextField_ resignFirstResponder];
}

-(void) btnResponse:(id)sender
{
    if( sender == sumbitBtn_ )
    {
        [self sumbitAdvice];
        
    }
}

@end
