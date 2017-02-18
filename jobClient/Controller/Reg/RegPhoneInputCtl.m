//
//  RegPhoneInputCtl.m
//  jobClient
//
//  Created by 一览ios on 15/1/5.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "RegPhoneInputCtl.h"
#import "RegSmsCodeInputCtl.h"
#import "User_DataModal.h"

@interface RegPhoneInputCtl ()
{
    RequestCon *_smsCodeCon;
}
@end

@implementation RegPhoneInputCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_isThirdBanderPhoneNum) {
        _phone = nil;
//        self.navigationItem.title = @"绑定手机";
        [self setNavTitle:@"绑定手机"];
    }
    else{
//        self.navigationItem.title = @"注册";
        [self setNavTitle:@"注册"];
    }
    _phoneTF.text = _phone;
    [self initAttr];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setFd_prefersNavigationBarHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self setFd_prefersNavigationBarHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_phoneTF becomeFirstResponder];
}

- (void)initAttr
{
    [_titleLb setFont:SEVENTEENFONT_FRISTTITLE];
    [_tipLb setFont:TWEELVEFONT_COMMENT];
    CALayer *layer = _smsCodeBtn.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 4.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch ( type ) {
        case Request_RegestPhone:
        {
            Status_DataModal *dataModal = [dataArr objectAtIndex:0];
            if( [dataModal.status_ isEqualToString:Success_Status] ){
                [self next];
            }else{
                if ([dataModal.status_ isEqualToString:Fail_Status]) {
                    [BaseUIViewController showAutoDismissFailView:nil msg:dataModal.des_];
                }
            }
            break;
        }
        default:
            break;
    }
}



- (void)btnResponse:(id)sender
{
    if (sender == _smsCodeBtn) {
        
        if (![MyCommon isMobile:_phoneTF.text]) {
            [BaseUIViewController showAlertView:nil msg:@"请输入正确的手机号" btnTitle:@"关闭"];
            return;
        }
        
        if (!_smsCodeCon) {
            _smsCodeCon = [self getNewRequestCon:NO];
        }
        [_smsCodeCon regestPhone:_phoneTF.text];
    }
}

- (void)next
{
    User_DataModal *inDataModal = [[User_DataModal alloc]init];
    inDataModal.mobile_ = _phoneTF.text;
    inDataModal.uname_ = _phoneTF.text;
    RegSmsCodeInputCtl *codeCtl = [[RegSmsCodeInputCtl alloc]init];
    codeCtl.inDataModal = inDataModal;
    codeCtl.isThirdBanderPhoneNum = _isThirdBanderPhoneNum;
    [self.navigationController pushViewController:codeCtl animated:YES];
}

- (void)backBarBtnResponse:(id)sender{
#if 0
//信息未完善时使用
    NSString *thirdlogin = [NSString stringWithFormat:@"%@_isNeedShow",[CommonConfig getDBValueByKey:Config_Key_UserID]];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:thirdlogin];
    [[NSUserDefaults standardUserDefaults] synchronize];
#endif
    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= 11)
        return NO;
    return YES;
}

- (IBAction)hasAccBtnClick:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
