//
//  RegSmsCodeInputCtl.m
//  jobClient
//
//  Created by 一览ios on 15/1/5.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "RegSmsCodeInputCtl.h"
#import "RegSendSmsCodeCtl.h"
#import "RegPwdInputCtl.h"
#import "RegInfoOneCtl.h"
#import "RootTabBarViewController.h"
#import "AssociationAppDelegate.h"

@interface RegSmsCodeInputCtl ()<UITextFieldDelegate>
{
    RequestCon *_smsCodeCon;
}
@end

@implementation RegSmsCodeInputCtl

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"短信验证码";
    [self setNavTitle:@"短信验证码"];
    _smsCodeTF.delegate = self;
    _smsCodeBtn.userInteractionEnabled = NO;
    [self startTimer];
    [self initAttr];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_smsCodeTF becomeFirstResponder];
}

- (void)initAttr
{
    [_titleLb setFont:SEVENTEENFONT_FRISTTITLE];
    CALayer *layer;
    layer = _nextBtn.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 4.0;
    layer = _smsCodeBtn.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 17.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)btnResponse:(id)sender
{
    if (sender == _smsCodeBtn) {
        [self startTimer];
        if (!_smsCodeCon) {
            _smsCodeCon = [self getNewRequestCon:NO];
        }
        [_smsCodeCon regestPhone:_inDataModal.mobile_];
    }else if(sender == _noCodeBtn) {
        NSString *title = @"为什么总是收不到验证码？";
        NSString *msg = @"1.网络信号差\t\t\t\n2.被短信拦截屏蔽哦\t\n3.手机欠费停机\t\t";
        [BaseUIViewController showModalLoadingView:NO title:nil status:nil];
        [self showChooseAlertView:11 title:title msg:msg okBtnTitle:@"主动验证" cancelBtnTitle:@"关闭"];
    }else if(sender == _nextBtn) {
        
        if ([[_smsCodeTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
            [BaseUIViewController showAlertView:nil msg:@"请输入验证码" btnTitle:@"确定"];
            return;
        }
        
        [BaseUIViewController showModalLoadingView:YES title:@"" status:@""];
        NSString *bodyMsg = [NSString stringWithFormat:@"mobile=%@&code=%@",_inDataModal.mobile_,_smsCodeTF.text];
        [ELRequest postbodyMsg:bodyMsg op:@"common_reg_auth" func:@"checkMobileCode" requestVersion:NO success:^(NSURLSessionDataTask *operation, id result)
         {
             [BaseUIViewController showModalLoadingView:NO title:@"" status:@""];
             NSDictionary *dic = result;
             NSString *status = dic[@"status"];
//             NSNumber *showTips = getUserDefaults(@"showTip");
//             BOOL showTips = [[NSUserDefaults standardUserDefaults] boolForKey:@"showTip"];
             if ([status isEqualToString:@"OK"])
             {
                 if(!_isThirdBanderPhoneNum){
                     RegPwdInputCtl *pwdCtl = [[RegPwdInputCtl alloc]init];
                     _inDataModal.verifyCode_ = _smsCodeTF.text;
                     pwdCtl.inDataModal = _inDataModal;
                     [self.navigationController pushViewController:pwdCtl animated:YES];
                 }
                 
//                 else if(_isThirdBanderPhoneNum && showTips){
//                     RegInfoOneCtl *regOneCtl = [[RegInfoOneCtl alloc]init];
//                     regOneCtl.type = ThirdLogin;
//                     [self.navigationController pushViewController:regOneCtl animated:YES];
//                     [regOneCtl beginLoad:_inDataModal exParam:nil];
//                 }
                 else{
                     AssociationAppDelegate *delegate = (AssociationAppDelegate *)[[UIApplication sharedApplication] delegate];
                     if ([Manager shareMgr].isNeedRefresh || [Manager shareMgr].isFirstLoading) {
                         [Manager shareMgr].tabVC = [[RootTabBarViewController alloc]init];
                         [Manager shareMgr].isNeedRefresh = NO;
                     }
                     if (![Manager shareMgr].tabVC) {
                         [Manager shareMgr].tabVC = [[RootTabBarViewController alloc] init];
                     }
                     delegate.window.rootViewController = [Manager shareMgr].tabVC;
                     for (id vc in [Manager shareMgr].tabVC.viewControllers) {
                         if ([vc childViewControllers].count > 1) {
                             [Manager shareMgr].tabVC.tabBar.hidden = YES;
                         }
                     }

                 }
             }
             else
             {
                 [BaseUIViewController showAutoDismissFailView:@"" msg:dic[@"status_desc"] seconds:1.0];
             }
             
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            
        }];
        
        
    }
}

-(void)alertViewChoosed:(UIAlertView *)alertView index:(int)index type:(int)type
{
    [super alertViewChoosed:alertView index:index type:type];
    switch (type) {
        case 11://跳转到主动验证页面
        {
            RegSendSmsCodeCtl *sendSmsCtl = [[RegSendSmsCodeCtl alloc]init];
            sendSmsCtl.phone = _inDataModal.mobile_;
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


- (void)startTimer
{
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_smsCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                _smsCodeBtn.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_smsCodeBtn setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                _smsCodeBtn.userInteractionEnabled = NO;
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self btnResponse:_nextBtn];
    return YES;
    /*
    if ([[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        [BaseUIViewController showAlertView:nil msg:@"请输入验证码" btnTitle:@"确定"];
        return false;
    }
    RegPwdInputCtl *pwdCtl = [[RegPwdInputCtl alloc]init];
    _inDataModal.verifyCode_ = _smsCodeTF.text;
    pwdCtl.inDataModal = _inDataModal;
    [self.navigationController pushViewController:pwdCtl animated:YES];
  */
}

- (IBAction)hasAccBtnClick:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
