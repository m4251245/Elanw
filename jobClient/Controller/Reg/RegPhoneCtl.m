//
//  RegPhoneCtl.m
//  jobClient
//
//  Created by YL1001 on 14-9-1.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "RegPhoneCtl.h"
#import "RegCtl.h"
#import "RegInfoTwoCtl.h"
#import "RegSendSmsCodeCtl.h"
#import "RegInfoOneCtl.h"

@interface RegPhoneCtl ()
{
    BOOL showCodeTF_;
}

@end

@implementation RegPhoneCtl
@synthesize delegate_;

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
//     self.navigationItem.title = @"注册一览";
    [self setNavTitle:@"注册一览"];
    self.scrollView_.scrollEnabled = NO;
    [self setAttr];
    verifyCodeTF_.delegate = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)setAttr
{
    CALayer *layer = _phoneBgView.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 4.0;
    layer.borderWidth = 1.0;
    layer.borderColor = [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1.0].CGColor;    
    layer = _codeBgView.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 4.0;
    layer.borderWidth = 1.0;
    layer.borderColor = [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1.0].CGColor;
    layer = _pwdBgView.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 4.0;
    layer.borderWidth = 1.0;
    layer.borderColor = [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1.0].CGColor;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


-(IBAction)startTime:(id)sender
{
    
    if( [[phoneTF_.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] ] length] == 0){
        [BaseUIViewController showAlertView:nil msg:@"手机号不能为空" btnTitle:@"关闭"];
        [phoneTF_ becomeFirstResponder];
        return;
    }
    if (![MyCommon isMobile:phoneTF_.text]) {
        [BaseUIViewController showAlertView:nil msg:@"请输入正确的手机号" btnTitle:@"关闭"];
        [phoneTF_ becomeFirstResponder];
        return;
    }
    else{
        [phoneTF_ resignFirstResponder];
    }
    
    if (!phoneCon_) {
        phoneCon_ = [self getNewRequestCon:NO];
    }
    [phoneCon_ regestPhone:phoneTF_.text];
    
}

//注册手机
-(void) regestPhone
{
    if ([[phoneTF_.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] ] length] == 0) {
        [BaseUIViewController showAlertView:nil msg:@"手机号不能为空" btnTitle:@"关闭"];
        [phoneTF_ becomeFirstResponder];
        return;

    }
    if (![MyCommon isMobile:phoneTF_.text]) {
        [BaseUIViewController showAlertView:nil msg:@"请输入正确的手机号" btnTitle:@"关闭"];
        [phoneTF_ becomeFirstResponder];
        return;
    }
    if( [verifyCodeTF_.text length] == 0 ){
        [BaseUIViewController showAlertView:nil msg:@"短信验证码不能为空" btnTitle:@"关闭"];
        
        return;
    }
    
    if ([pwdTF_.text length] < 6 ||[pwdTF_.text length] >20 ||[MyCommon checkSpacialCharacter:@"\"`'#-& " inString:pwdTF_.text]) {
        [BaseUIViewController showAlertView:@"请输入6-20位字符（\"`' # - & 除外），区分大小写" msg:nil btnTitle:@"确定"];
        [pwdTF_ becomeFirstResponder];
        return;
    }
    else{
        [phoneTF_ resignFirstResponder];
        [verifyCodeTF_ resignFirstResponder];
        [pwdTF_ resignFirstResponder];
    }
    
    //test
//    User_DataModal * dataModal = [[User_DataModal alloc] init];
//    dataModal.uname_ = phoneTF_.text;
//    dataModal.pwd_ = pwdTF_.text;
//    dataModal.verifyCode_ = verifyCodeTF_.text;
//    [delegate_ registerPhoneOK:dataModal userName:phoneTF_.text pwd:pwdTF_.text];
//    RegInfoOneCtl *regInfoOneCtl = [[RegInfoOneCtl alloc]init];
//    [self.navigationController pushViewController:regInfoOneCtl animated:YES];
//    [regInfoOneCtl beginLoad:dataModal exParam:nil];
    
    if (!registerCon_) {
        registerCon_ = [self getNewRequestCon:NO];
    }
    [registerCon_ doRegister:phoneTF_.text pwd:pwdTF_.text regSource:MyClientName verifyCode:verifyCodeTF_.text];
}


-(void) finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch ( type ) {
        case Request_RegestPhone:
        {
            Status_DataModal *dataModal = [dataArr objectAtIndex:0];
            
            if( [dataModal.status_ isEqualToString:Success_Status] ){
                __block int timeout=60; //倒计时时间
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
                dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
                dispatch_source_set_event_handler(_timer, ^{
                    if(timeout<=0){ //倒计时结束，关闭
                        dispatch_source_cancel(_timer);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //设置界面的按钮显示 根据自己需求设置
                            [sendCodeBtn_ setTitle:@"发送验证码" forState:UIControlStateNormal];
                            sendCodeBtn_.userInteractionEnabled = YES;
                        });
                    }else{
                        //            int minutes = timeout / 60;
                        int seconds = timeout;
                        NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //设置界面的按钮显示 根据自己需求设置
                            [sendCodeBtn_ setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                            sendCodeBtn_.userInteractionEnabled = NO;
                            
                        });
                        timeout--;
                        
                    }
                });
                dispatch_resume(_timer);

            }else{
                NSString *str = dataModal.des_;
                if( !str || ![str isKindOfClass:[NSString class]] ){
                    str = @"请稍候再试";
                }
                
                [BaseUIViewController showAlertView:@"验证失败" msg:str btnTitle:@"确定"];
            }
        }
            break;
            
        case Request_Register:
        {
            User_DataModal *dataModal = [dataArr objectAtIndex:0];
            if( [dataModal.status_ isEqualToString:Success_Status] ){
                
                //记录友盟统计注册来源数量
                NSString * typeStr = [RegCtl getRegTypeStr:[Manager shareMgr].registeType_];
                NSDictionary *dict = @{@"Source" : typeStr};
                [MobClick event:@"registerSource" attributes:dict];
                
                //记录友盟统计注册总数
                NSDictionary *dict1 = @{@"Source" : @"注册总数"};
                [MobClick event:@"registerAmount" attributes:dict1];
                
                NSString *userName = phoneTF_.text;
                NSString *pwd = pwdTF_.text;
                [delegate_ registerPhoneOK:dataModal userName:userName pwd: pwd];
                RegInfoOneCtl *regOneCtl = [[RegInfoOneCtl alloc]init];
                [self.navigationController pushViewController:regOneCtl animated:YES];
                [regOneCtl beginLoad:dataModal exParam:nil];
            }else{
                NSString *str = dataModal.des_;
                if( !str || ![str isKindOfClass:[NSString class]] ){
                    str = @"请稍候再试";
                }
                
                [BaseUIViewController showAlertView:@"注册失败" msg:str btnTitle:@"确定"];
            }
        }
            break;
            
        default:
            break;
    }
}

-(void)btnResponse:(id)sender
{
    if (sender == nextBtn_) {
        [self regestPhone];
    }
    else if (sender == checkAgreement_){
        AgreementCtl* agreementCtl_ = [[AgreementCtl alloc] init];
        [self.navigationController pushViewController:agreementCtl_ animated:YES];
    }else if (sender == _noCodeBtn){
//        NSString *title = @"为什么总是收不到验证码？";
//        NSString *msg = @"1.网络信号差\t\t\t\n2.被短信拦截屏蔽哦\t\n3.手机欠费停机\t\t";
//        [BaseUIViewController showModalLoadingView:NO title:nil status:nil];
//        [self showChooseAlertView:11 title:title msg:msg okBtnTitle:@"主动验证" cancelBtnTitle:@"关闭"];
        RegInfoTwoCtl *ctl = [[RegInfoTwoCtl alloc]init];
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

-(void)alertViewChoosed:(UIAlertView *)alertView index:(int)index type:(int)type
{
    [super alertViewChoosed:alertView index:index type:type];
    switch (type) {
        case 11://跳转到主动验证页面
        {
            if (![MyCommon isMobile:phoneTF_.text]) {
                [BaseUIViewController showAlertView:nil msg:@"请输入正确的手机号" btnTitle:@"关闭"];
                return;
            }
            RegSendSmsCodeCtl *sendSmsCtl = [[RegSendSmsCodeCtl alloc]init];
            sendSmsCtl.phone = phoneTF_.text;
            [self.navigationController pushViewController:sendSmsCtl animated:YES];
            [sendSmsCtl beginLoad:nil exParam:nil];
        }
            break;
        default:
            break;
    }
}

-(void)alertViewCancel:(UIAlertView *)alertView index:(int)index type:(int)type
{
    switch (type) {
        case 11://关闭窗口
        {
            
        }
            break;
            
        default:
            break;
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == phoneTF_) {
        
    }
    else if (textField == verifyCodeTF_){

    }
    else if (textField == pwdTF_){
        [self regestPhone];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == verifyCodeTF_) {
        if (!showCodeTF_ && ![[verifyCodeTF_.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
            [UIView beginAnimations:nil context:nil];
            CGRect rect = pwdView_.frame;
            rect.origin.y = rect.origin.y + 60;
            pwdView_.frame = rect;
            [UIView commitAnimations];
            showCodeTF_ = YES;
        }
        if (showCodeTF_ && [[verifyCodeTF_.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]){
            [UIView animateWithDuration:0.3 animations:^{
                CGRect rect = pwdView_.frame;
                rect.origin.y = rect.origin.y - 60;
                pwdView_.frame = rect;
                showCodeTF_ = NO;
            }];
        }
    }
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == verifyCodeTF_) {
        if ([[verifyCodeTF_.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ] isEqualToString:@""]) {
            CGPoint point = CGPointMake(0, 30);
            [self.scrollView_ setContentOffset:point animated:YES];//输入验证码时，能够显示主动验证的提示按钮
        }
    }
}


@end
