//
//  RegPwdInputCtl.m
//  jobClient
//
//  Created by 一览ios on 15/1/5.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "RegPwdInputCtl.h"
#import "RegInfoOneCtl.h"

@interface RegPwdInputCtl ()
{
    RequestCon *_registerCon;
}
@end

@implementation RegPwdInputCtl

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"注册";
    [self setNavTitle:@"注册"];
    [self initAttr];
}

- (void)initAttr
{
    [_titleLb setFont:SEVENTEENFONT_FRISTTITLE];
    CALayer *layer = _registBtn.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 4.0;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_pwdTF becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    User_DataModal *dataModal = [dataArr objectAtIndex:0];
    if( [dataModal.status_ isEqualToString:Success_Status] ){
        
        //记录友盟统计注册来源数量
        NSString * typeStr = [RegCtl getRegTypeStr:[Manager shareMgr].registeType_];
        NSDictionary *dict = @{@"Source" : typeStr};
        [MobClick event:@"registerSource" attributes:dict];
        
        //记录友盟统计注册总数
        NSDictionary *dict1 = @{@"Source" : @"注册总数"};
        [MobClick event:@"registerAmount" attributes:dict1];
        dataModal.pwd_ = _pwdTF.text;
        _inDataModal = dataModal;
        [BaseUIViewController showAutoDismissSucessView:nil msg:@"注册成功，请完善信息"];
        [self performSelector:@selector(finishInfo) withObject:nil afterDelay:1.5];
        
    }else{
        NSString *str = dataModal.des_;
        if( !str || ![str isKindOfClass:[NSString class]] ){
            str = @"请稍候再试";
        }
        [BaseUIViewController showAlertView:@"注册失败" msg:str btnTitle:@"确定"];
    }
}

- (void)finishInfo
{
    RegInfoOneCtl *regOneCtl = [[RegInfoOneCtl alloc]init];
    [self.navigationController pushViewController:regOneCtl animated:YES];
    [regOneCtl beginLoad:_inDataModal exParam:nil];

}

- (void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
}


- (void)btnResponse:(id)sender
{
    if (sender == _registBtn) {
        
        if ([[_pwdTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
            [BaseUIViewController showAlertView:@"请输入密码" msg:nil btnTitle:@"确定"];
            return;
        };
        if ([_pwdTF.text length] < 6 ||[_pwdTF.text length] >20 ||[MyCommon checkSpacialCharacter:@"\"`'#-& " inString:_pwdTF.text]) {
            [BaseUIViewController showAlertView:@"请输入6-20位字符（\"`' # - & 除外），区分大小写" msg:nil btnTitle:@"确定"];
            [_pwdTF becomeFirstResponder];
            return;
        }else{
            [_pwdTF resignFirstResponder];
        }
        
        if (!_registerCon) {
            _registerCon = [self getNewRequestCon:NO];
        }
        _inDataModal.pwd_ = _pwdTF.text;
        [_registerCon doRegister:_inDataModal.mobile_ pwd:_pwdTF.text regSource:MyClientName verifyCode:_inDataModal.verifyCode_];
        
//        [self finishInfo];
    }
}

- (IBAction)endOnExit:(id)sender {
    [sender resignFirstResponder];
    [_registBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)hasAccBtnClick:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
