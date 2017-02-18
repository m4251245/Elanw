//
//  RegPhoneInputCtl.m
//  jobClient
//
//  Created by 一览ios on 15/1/5.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "AccSetPwdCtl.h"
#import "User_DataModal.h"
#import "AccountPasswordCtl.h"
#import "AssociationAppDelegate.h"
#import "RootTabBarViewController.h"

@interface AccSetPwdCtl ()
{
    RequestCon *_smsCodeCon;
}
@end

@implementation AccSetPwdCtl

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"设置密码";
    [self setNavTitle:@"设置密码"];
    [self initAttr];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)initAttr
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnResponse:(UIButton *)sender
{
    
    if (sender == _saveBtn) {
        sender.enabled = NO;
        if( [_pwdTF.text length] == 0 ){
            [BaseUIViewController showAlertView:@"请输入新密码" msg:nil btnTitle:@"确定"];
            [_pwdTF becomeFirstResponder];
            return;
        }
        if ([_pwdTF.text length] < 6 ||[_pwdTF.text length] >20 ||[MyCommon checkSpacialCharacter:@"\"`'#-& " inString:_pwdTF.text]) {
            [BaseUIViewController showAlertView:@"请输入6-20位字符（\"`' # - & 除外），区分大小写" msg:nil btnTitle:@"确定"];
            [_pwdTF becomeFirstResponder];
            return;
        }
        
        if( [_confirmPwdTF.text length] == 0 ){
            [BaseUIViewController showAlertView:@"请输入确认密码" msg:nil btnTitle:@"确定"];
            [_confirmPwdTF becomeFirstResponder];
            return;
        }
        
        if( ![_pwdTF.text isEqualToString:_confirmPwdTF.text] ){
            [BaseUIViewController showAlertView:@"确认密码不正确" msg:nil btnTitle:@"确定"];
            return;
        }
        
        //第三分登录修改密码
        NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&password_new=%@&", [Manager getUserInfo].userId_, _pwdTF.text];
        [ELRequest postbodyMsg:bodyMsg op:@"person_info_busi" func:@"resetpassword" requestVersion:YES progressFlag:NO progressMsg:@"正在加载..."  success:^(NSURLSessionDataTask *operation, id result) {
            NSString *status = result[@"status"];
            if ([status isEqualToString:Success_Status]) {
                [BaseUIViewController showAutoDismissSucessView:nil msg:@"修改成功"];
                NSInteger count = self.navigationController.childViewControllers.count;
                for (NSInteger i = count-2; i>0; i--) {
                    BaseUIViewController *ctl = self.navigationController.childViewControllers[i];
                    if ([ctl isKindOfClass:[AccountPasswordCtl class]]) {
                        [Manager shareMgr].isNeedRefresh = YES;
                        
                        User_DataModal *userModal = [User_DataModal new];
                        userModal.uname_ = self.phone;
                        userModal.pwd_ = _pwdTF.text;
                        
                        AssociationAppDelegate *delegate = (AssociationAppDelegate *)[[UIApplication sharedApplication] delegate];
                        if (![Manager shareMgr].loginCtl_) {
                            [Manager shareMgr].loginCtl_ = [[LoginCtl alloc] init];
                        }
                        delegate.window.rootViewController = [Manager shareMgr].loginCtl_;
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"RegistSuccess" object:nil userInfo:@{@"key":userModal}];
                        
                        [[Manager shareMgr].loginCtl_ login:0];
                        break;
                    }
                }
                
                
//                [[Manager shareMgr] loginOut];
//                [Manager shareMgr].haveLogin = NO;
            }else{
                [BaseUIViewController showAutoDismissFailView:nil msg:result[@"status_desc"]];
                sender.enabled = YES;
            }
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            
        }];
        sender.enabled = YES;
        //
    }
}






@end
