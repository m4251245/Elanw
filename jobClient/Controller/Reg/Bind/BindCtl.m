//
//  BindCtl.m
//  jobClient
//
//  Created by 一览ios on 15/12/21.
//  Copyright © 2015年 YL1001. All rights reserved.
//

#import "BindCtl.h"
#import "CodeInputCtl.h"

@interface BindCtl ()

@end

@implementation BindCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_varifyType == VarifyTypeBindEmail) {
        _summaryLb.text = @"绑定邮箱后，你可以使用邮箱直接登录一览，你也可以用邮箱找回密码";
//        self.navigationItem.title = @"绑定邮箱";
        [self setNavTitle:@"绑定邮箱"];
        self.emailOrPhoneTF.placeholder = @"输入邮箱";
        _emailOrPhoneTF.keyboardType = UIKeyboardTypeEmailAddress;
    }else if (_varifyType == VarifyTypeUpdateEmail) {
        _summaryLb.text = @"修改邮箱后，你可以使用邮箱直接登录一览，你也可以用邮箱找回密码";
//        self.navigationItem.title = @"修改邮箱";
        [self setNavTitle:@"修改邮箱"];
        self.emailOrPhoneTF.placeholder = @"输入新邮箱";
        _emailOrPhoneTF.keyboardType = UIKeyboardTypeEmailAddress;
    }else if (_varifyType == VarifyTypeBindPhone) {
        _summaryLb.text = @"绑定手机后，你可以使用手机直接登录一览，你也可以用手机找回密码";
//        self.navigationItem.title = @"绑定手机号";
        [self setNavTitle:@"绑定手机号"];
        self.emailOrPhoneTF.placeholder = @"输入手机号";
    }else if (_varifyType == VarifyTypeUpdatePhone) {
        _summaryLb.text = @"修改手机后，你可以使用手机直接登录一览，你也可以用手机找回密码";
//        self.navigationItem.title = @"修改手机号";
        [self setNavTitle:@"修改手机号"];
        self.emailOrPhoneTF.placeholder = @"输入新手机号";
    }else if (_varifyType == VarifyTypeThirdLogin) {
        _summaryLb.text = @"绑定手机后，你可以使用手机直接登录一览，你也可以用手机找回密码";
//        self.navigationItem.title = @"绑定手机号";
        [self setNavTitle:@"绑定手机号"];
        self.emailOrPhoneTF.placeholder = @"输入手机号";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)btnResponse:(UIButton *)sender
{
    if (sender == _sendCodeBtn) {
        
        sender.enabled = NO;
        NSMutableString *bodyMsg = [NSMutableString stringWithFormat:@"person_id=%@", [Manager getUserInfo].userId_];
        
        if (_varifyType == VarifyTypeBindEmail || _varifyType == VarifyTypeUpdateEmail) {
           BOOL result = [MyCommon isValidateEmail:_emailOrPhoneTF.text];
            if (!result) {
                [BaseUIViewController showAutoDismissFailView:nil msg:@"请输入正确的邮箱" seconds:3.f];
                sender.enabled = YES;
                return;
            }
            [bodyMsg appendFormat:@"&type=email&content=%@&", _emailOrPhoneTF.text];
        }else if (_varifyType == VarifyTypeBindPhone || _varifyType == VarifyTypeUpdatePhone || _varifyType == VarifyTypeThirdLogin) {
            if (![MyCommon isMobile:_emailOrPhoneTF.text]) {
                [BaseUIViewController showAutoDismissFailView:nil msg:@"请输入正确的手机号" seconds:3.f];
                sender.enabled = YES;
                return;
            }
            [bodyMsg appendFormat:@"&type=mobile&content=%@&", _emailOrPhoneTF.text];
        }
        
        [ELRequest postbodyMsg:bodyMsg op:@"job1001user_person_bind_busi" func:@"sendBindCode" requestVersion:YES progressFlag:YES progressMsg:@"正在加载..."  success:^(NSURLSessionDataTask *operation, id result) {
            NSString *status = result[@"status"];
            if ([status isEqualToString:Success_Status]) {
                CodeInputCtl *codeCtl = [[CodeInputCtl alloc]init];
                codeCtl.varifyType = _varifyType;
                codeCtl.phone = _emailOrPhoneTF.text;
                codeCtl.email = _emailOrPhoneTF.text;
                codeCtl.inDataModal = _inDataModal;
                [self.navigationController pushViewController:codeCtl animated:YES];
                sender.enabled = YES;
            }else{
                [BaseUIViewController showAutoDismissFailView:nil msg:result[@"status_desc"]];
                 sender.enabled = YES;
            }
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            
        }];
        
    }
}

- (void)backBarBtnResponse:(id)sender
{
    if (_varifyType == VarifyTypeThirdLogin) {
        [self showChooseAlertView:30 title:nil msg:@"绑定手机号后，你可以使用手机直接登录一览，你也可以使用手机找回密码" okBtnTitle:@"以后再说" cancelBtnTitle:@"立即绑定"];
        return;
    }
    if (_varifyType == VarifyTypeBindPhone) {
          [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    [super backBarBtnResponse:sender];
}

- (void)alertViewChoosed:(UIAlertView *)alertView index:(int)index type:(int)type
{
    switch (type) {
        case 30:
        {
//            [self.navigationController.viewControllers.lastObject dismissViewControllerAnimated:YES completion:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
}

@end
