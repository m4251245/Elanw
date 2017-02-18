//
//  SafeVarifyCtl.m
//  jobClient
//
//  Created by 一览ios on 15/12/21.
//  Copyright © 2015年 YL1001. All rights reserved.
//

#import "SafeVarifyCtl.h"
#import "BindCtl.h"
#import "CodeInputCtl.h"

@interface SafeVarifyCtl ()

@end

@implementation SafeVarifyCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.navigationItem.title) {
//        self.navigationItem.title = @"安全验证";
        [self setNavTitle:@"安全验证"];
    }
    
    if (_varifyType == VarifyTypeUpdateEmail || _varifyType == VarifyTypeUpdatePwdVarifyEmail) {
        NSRange range = [_email rangeOfString:@"@"];
        _oldEmailOrPhoneLb.text = [NSString stringWithFormat:@"%@****%@", [_email substringToIndex:3], [_email substringFromIndex:range.location]];
        _oldEmailOrPhoneTF.placeholder = @"输入原邮箱";
        _oldEmailOrPhoneTF.keyboardType = UIKeyboardTypeEmailAddress;
    }else if (_varifyType == VarifyTypeUpdatePhone || _varifyType == VarifyTypeUpdatePwdVarifyPhone) {
        _oldEmailOrPhoneLb.text = [NSString stringWithFormat:@"%@****%@", [_phone substringToIndex:3], [_phone substringFromIndex:7]];
        _oldEmailOrPhoneTF.placeholder = @"输入原手机号";
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)btnResponse:(UIButton *)sender
{
//    CodeInputCtl *codeCtl = [[CodeInputCtl alloc]init];
//    codeCtl.varifyType = _varifyType;
//    codeCtl.email = _email;
//    codeCtl.phone = _phone;
//    [self.navigationController pushViewController:codeCtl animated:YES];
//    return;
    
    if (sender == _nextStepBtn) {
        sender.enabled = NO;
        //验证原的号是否正确
        if ( _varifyType == VarifyTypeUpdateEmail) {//修改绑定邮箱
            BOOL result = [MyCommon isValidateEmail:_oldEmailOrPhoneTF.text];
            if (!result) {
                [BaseUIViewController showAutoDismissFailView:nil msg:@"请输入正确的邮箱" seconds:3.f];
                sender.enabled = YES;
                return;
            }
            if (![_oldEmailOrPhoneTF.text isEqualToString:_email]) {
                [BaseUIViewController showAutoDismissFailView:nil msg:@"输入的邮箱与原邮箱不符" seconds:3.f];
                sender.enabled = YES;
                return;
            }
           
        }else if (_varifyType == VarifyTypeUpdatePhone) {//修改绑定手机
            if (![MyCommon isMobile:_oldEmailOrPhoneTF.text]) {
                [BaseUIViewController showAutoDismissFailView:nil msg:@"请输入正确的手机号" seconds:3.f];
                sender.enabled = YES;
                return;
            }
            if (![_oldEmailOrPhoneTF.text isEqualToString:_phone]) {
                [BaseUIViewController showAutoDismissFailView:nil msg:@"输入的手机号与原手机号不符" seconds:3.f];
                sender.enabled = YES;
                return;
            }
            
        }
        
        
        if (_varifyType == VarifyTypeUpdatePwdVarifyPhone || _varifyType == VarifyTypeUpdatePwdVarifyEmail) {//修改账户密码
            //发送验证码
            
            NSMutableString *bodyMsg = [NSMutableString stringWithFormat:@"person_id=%@", [Manager getUserInfo].userId_];
            
            if (_varifyType == VarifyTypeUpdatePwdVarifyEmail) {
                [bodyMsg appendFormat:@"&type=updatepwd&content=%@&", _email];
            }else if (_varifyType == VarifyTypeUpdatePwdVarifyPhone) {
                [bodyMsg appendFormat:@"&type=updatepwd&content=%@&", _phone];
            }
            
            [ELRequest postbodyMsg:bodyMsg op:@"job1001user_person_bind_busi" func:@"sendBindCode" requestVersion:YES progressFlag:NO progressMsg:@"正在加载..."  success:^(NSURLSessionDataTask *operation, id result) {
                NSString *status = result[@"status"];
                if ([status isEqualToString:Success_Status]) {
                    
                }else{
                    [BaseUIViewController showAutoDismissFailView:nil msg:result[@"status_desc"]];
                }
            } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                
            }];
            
            CodeInputCtl *codeCtl = [[CodeInputCtl alloc]init];
            codeCtl.varifyType = _varifyType;
            codeCtl.email = _email;
            codeCtl.phone = _phone;
            [self.navigationController pushViewController:codeCtl animated:YES];
        }else{//走绑定流程
            BindCtl *bindCtl = [[BindCtl alloc]init];
            bindCtl.varifyType = _varifyType;
            bindCtl.phone = _phone;
            bindCtl.email = _email;
            [self.navigationController pushViewController:bindCtl animated:YES];
        }
        sender.enabled = YES;
        
    }
}

@end
