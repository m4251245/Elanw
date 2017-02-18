//
//  ConsultantLoginCtl.m
//  jobClient
//
//  Created by 一览ios on 15/6/2.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ConsultantLoginCtl.h"
#import "ConsultantCenterCtl.h"
#import "ExRequetCon.h"
#import "ConsultantHRDataModel.h"

@interface ConsultantLoginCtl ()
{
    RequestCon      *loginCon;
    __weak IBOutlet NSLayoutConstraint *tipLbTopSpace;
}
@end

@implementation ConsultantLoginCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setFd_interactivePopDisabled:YES];
    [self setNavTitle:@"我的招聘"];
    self.scrollView_.scrollEnabled = NO;
    bgImagev1.layer.cornerRadius = 4.0;
    bgImagev1.layer.borderWidth = 0.5;
    bgImagev1.layer.borderColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0].CGColor;
    bgImagev2.layer.cornerRadius = 4.0;
    bgImagev2.layer.borderWidth = 0.5;
    bgImagev2.layer.borderColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0].CGColor;
    loginBtn.layer.cornerRadius = 4.0;
    
    tipLbTopSpace.constant = ScreenHeight - 40;
    // Do any additional setup after loading the view from its nib.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == userNameTF) {
        [passwdTf becomeFirstResponder];
    }
    if (textField == passwdTf) {
        [passwdTf resignFirstResponder];
        [self btnResponse:loginBtn];
    }
    return YES;
}

-(BOOL)fd_prefersNavigationBarHidden{
    return YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self setFd_prefersNavigationBarHidden:NO];
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setFd_prefersNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

- (void)btnResponse:(id)sender
{
    if (sender == changLoginModelBtn || sender == backBtn) {
//        [self backBarBtnResponse:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (sender == loginBtn) {
        if ([[MyCommon removeSpaceAtSides:userNameTF.text] isEqualToString:@""]) {
            [BaseUIViewController showAutoDismissSucessView:@"请填写用户名" msg:@"" seconds:1.0];
            return;
        }
        if ([[MyCommon removeSpaceAtSides:passwdTf.text] isEqualToString:@""]) {
            [BaseUIViewController showAutoDismissSucessView:@"请填写密码" msg:@"" seconds:1.0];
            return;
        }
        if (!loginCon) {
            loginCon = [self getNewRequestCon:NO];
        }
        [loginCon gunwenLoginWith:userNameTF.text pswd:passwdTf.text userId:[Manager getUserInfo].userId_];
    }
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case gunwenLoginWith:
        {
            if ([dataArr count] != 0) {
                if ([dataArr[0] isKindOfClass:[Status_DataModal class]]) {
                    Status_DataModal *model = dataArr[0];
                    [BaseUIViewController showAutoDismissFailView:@"" msg:model.des_ seconds:1.0];
                }else if ([dataArr[0] isKindOfClass:[ConsultantHRDataModel class]]){
                    ConsultantHRDataModel *model = [dataArr objectAtIndex:0];
                    ConsultantCenterCtl *consultantCenterCtl = [[ConsultantCenterCtl alloc] init];
                    [consultantCenterCtl beginLoad:model exParam:nil];
                    [Manager setHrInfo:model];
                    consultantCenterCtl.islogin = YES;
                    [BaseUIViewController showAutoDismissSucessView:@"" msg:@"登录成功" seconds:1.0];
                    [self.navigationController pushViewController:consultantCenterCtl animated:YES];
                    [passwdTf setText:@""];
                    [[Manager shareMgr].messageRefreshCtl requestCount];
                }
            }
        }
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
