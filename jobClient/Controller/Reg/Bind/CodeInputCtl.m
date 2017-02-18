//
//  BindCtl.m
//  jobClient
//
//  Created by 一览ios on 15/12/21.
//  Copyright © 2015年 YL1001. All rights reserved.
//

#import "CodeInputCtl.h"
#import "SysTemSetCtl.h"
#import "AccountPasswordCtl.h"
#import "MyResumeController.h"
//#import "ModifyResumeViewController.h"
#import "PersonInfo_ResumeCtl.h"
#import "RegInfoOneCtl.h"
@interface CodeInputCtl ()

@end

@implementation CodeInputCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_varifyType == VarifyTypeBindEmail) {
        _summaryLb.text = [NSString stringWithFormat:@"邮箱验证码已发送至%@，请注意查收", self.email];
//        self.navigationItem.title = @"邮箱验证码";
        [self setNavTitle:@"邮箱验证码"];
        self.codeTF.placeholder = @"输入邮箱验证码";
    }else if (_varifyType == VarifyTypeUpdateEmail) {
        _summaryLb.text = [NSString stringWithFormat:@"邮箱验证码已发送至%@，请注意查收", self.email];
//        self.navigationItem.title = @"邮箱验证码";
        [self setNavTitle:@"邮箱验证码"];
        self.codeTF.placeholder = @"输入邮箱验证码";
    }else if (_varifyType == VarifyTypeBindPhone) {
        _summaryLb.text = [NSString stringWithFormat:@"短信验证码已发送至%@，请注意查收", self.phone];
//        self.navigationItem.title = @"短信验证码";
        [self setNavTitle:@"短信验证码"];
        self.codeTF.placeholder = @"输入短信验证码";
    }else if (_varifyType == VarifyTypeUpdatePhone) {
        _summaryLb.text = [NSString stringWithFormat:@"短信验证码已发送至%@，请注意查收", self.phone];
//        self.navigationItem.title = @"短信验证码";
         [self setNavTitle:@"短信验证码"];
        self.codeTF.placeholder = @"输入短信验证码";
    }else if (_varifyType == VarifyTypeUpdatePwdVarifyEmail){
        _summaryLb.text = [NSString stringWithFormat:@"邮箱验证码已发送至%@，请注意查收", self.email];
//        self.navigationItem.title = @"邮箱验证码";
         [self setNavTitle:@"短信验证码"];
        self.codeTF.placeholder = @"输入邮箱验证码";
        [_finishBtn setTitle:@"确定" forState:UIControlStateNormal];
    }else if (_varifyType == VarifyTypeUpdatePwdVarifyPhone){
        _summaryLb.text = [NSString stringWithFormat:@"短信验证码已发送至%@，请注意查收", self.phone];
//        self.navigationItem.title = @"短信验证码";
         [self setNavTitle:@"短信验证码"];
        self.codeTF.placeholder = @"输入短信验证码";
        [_finishBtn setTitle:@"确定" forState:UIControlStateNormal];
    }else if (_varifyType == VarifyTypeThirdLogin){
        _summaryLb.text = [NSString stringWithFormat:@"短信验证码已发送至%@，请注意查收", self.phone];
//        self.navigationItem.title = @"短信验证码";
        [self setNavTitle:@"短信验证码"];
        self.codeTF.placeholder = @"输入短信验证码";
        [_finishBtn setTitle:@"绑定" forState:UIControlStateNormal];
    }
    CALayer *layer = _smsCodeBtn.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 17.f;
    [self startTimer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)btnResponse:(UIButton *)sender
{    
    if (sender == _finishBtn) {
        
        if (!_codeTF.text || [[_codeTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
            [BaseUIViewController showAutoDismissFailView:nil msg:@"请输入验证码"];
            return;
        }
        //获取验证码
        sender.enabled = NO;
        NSMutableString *bodyMsg = [NSMutableString stringWithFormat:@"person_id=%@", [Manager getUserInfo].userId_];
        
        if (_varifyType == VarifyTypeBindEmail || _varifyType == VarifyTypeUpdateEmail ) {
            
            [bodyMsg appendFormat:@"&type=email&authCode=%@&", _codeTF.text];
        }else if (_varifyType == VarifyTypeBindPhone || _varifyType == VarifyTypeUpdatePhone || _varifyType == VarifyTypeThirdLogin) {
            [bodyMsg appendFormat:@"&type=mobile&authCode=%@&", _codeTF.text];
        }else if (_varifyType == VarifyTypeUpdatePwdVarifyPhone || _varifyType == VarifyTypeUpdatePwdVarifyEmail) {
            [bodyMsg appendFormat:@"&type=updatepwd&authCode=%@&", _codeTF.text];
        }else{
            sender.enabled = YES;
            return;
        }
        
        [ELRequest postbodyMsg:bodyMsg op:@"job1001user_person_bind_busi" func:@"checkCode" requestVersion:YES progressFlag:NO progressMsg:@"正在加载..."  success:^(NSURLSessionDataTask *operation, id result) {
            NSString *status = result[@"status"];
            BOOL showTips = [[NSUserDefaults standardUserDefaults] boolForKey:@"showTip"];
            if ([status isEqualToString:Success_Status]) {
                if (_varifyType == VarifyTypeUpdatePwdVarifyPhone || _varifyType == VarifyTypeUpdatePwdVarifyEmail) {//修改账户密码
                    AccSetPwdCtl *accSetCtl = [[AccSetPwdCtl alloc]init];
                    accSetCtl.varifyType = _varifyType;
                    accSetCtl.phone = _phone;
                    accSetCtl.email = _email;
                    [self.navigationController pushViewController:accSetCtl animated:YES];
                    sender.enabled = YES;
                    return ;
                }
                
                if (showTips){
                    if (_varifyType == VarifyTypeBindPhone) {
                        RegInfoOneCtl *regOneCtl = [[RegInfoOneCtl alloc]init];
                        regOneCtl.type = ThirdLogin;
                        [self.navigationController pushViewController:regOneCtl animated:YES];
                        [regOneCtl beginLoad:_inDataModal exParam:nil];
                        return;
                    }
                }
                
                [Manager getUserInfo].uname_ = self.phone?self.phone:self.email;
                [BaseUIViewController showAutoDismissSucessView:nil msg:@"操作成功"];
                NSInteger count = self.navigationController.childViewControllers.count;
                for (NSInteger i = count-2; i>0; i--) {
                    id ctl = self.navigationController.childViewControllers[i];
                    if ([ctl isKindOfClass:[AccountPasswordCtl class]] || [ctl isKindOfClass:[MyResumeController class]]) {
                        [self.navigationController popToViewController:ctl animated:YES];
                        [ctl beginLoad:nil exParam:nil];
                    }else if ([ctl isKindOfClass:[PersonInfo_ResumeCtl class]] ) {
                        [self.navigationController popToViewController:ctl animated:YES];
//                        [ctl refreshLoad];
                        if (_varifyType == VarifyTypeBindPhone || _varifyType == VarifyTypeUpdatePhone) {
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"sendPhoneNumber" object:@(1) userInfo:@{@"phone":_phone}];
                        }
                        else if(_varifyType == VarifyTypeBindEmail || _varifyType == VarifyTypeUpdateEmail){
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"sendPhoneNumber" object:@(2) userInfo:@{@"email":_email}];
                        }
                        break;
                    }
                }
            }else{
                [BaseUIViewController showAutoDismissFailView:nil msg:result[@"status_desc"]];
                sender.enabled = YES;
            }
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            
        }];
        
        sender.enabled = YES;
    }else if (sender == _smsCodeBtn){//发送验证码
        [self startTimer];
        //获取验证码
        sender.enabled = NO;
        NSMutableString *bodyMsg = [NSMutableString stringWithFormat:@"person_id=%@", [Manager getUserInfo].userId_];
        
        if (_varifyType == VarifyTypeBindEmail || _varifyType == VarifyTypeUpdateEmail) {
            
            [bodyMsg appendFormat:@"&type=email&content=%@&", _email];
        }else if (_varifyType == VarifyTypeBindPhone || _varifyType == VarifyTypeUpdatePhone || _varifyType == VarifyTypeThirdLogin) {
            [bodyMsg appendFormat:@"&type=mobile&content=%@&", _phone];
        }
        
        [ELRequest postbodyMsg:bodyMsg op:@"job1001user_person_bind_busi" func:@"sendBindCode" requestVersion:YES progressFlag:NO progressMsg:@"正在加载..."  success:^(NSURLSessionDataTask *operation, id result) {
            NSString *status = result[@"status"];
            if ([status isEqualToString:Success_Status]) {
                [BaseUIViewController showAutoDismissFailView:nil msg:@"发送成功"];
            }else{
                [BaseUIViewController showAutoDismissFailView:nil msg:result[@"status_desc"]];
            }
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            
        }];
        
        sender.enabled = YES;

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
                [_smsCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                _smsCodeBtn.userInteractionEnabled = YES;
            });
        }else{
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


@end
