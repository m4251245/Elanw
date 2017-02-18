//
//  RegWelcomeCtl.m
//  jobClient
//
//  Created by 一览ios on 15/1/5.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "RegWelcomeCtl.h"
#import "AgreementCtl.h"
#import "RegPhoneInputCtl.h"
#import "RegSendSmsCodeCtl.h"

@interface RegWelcomeCtl () <UITextFieldDelegate>
{
    __weak IBOutlet UITextField *phoneTF;
    __weak IBOutlet UITextField *securityCode;
    __weak IBOutlet UITextField *passwordTF;
    NSTimer *timer;
    __weak IBOutlet UIButton *timeButton;
    NSInteger timeCount;
    RequestCon *_smsCodeCon;
    RequestCon *_registerCon;
}
@end

@implementation RegWelcomeCtl

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavTitle:@"注册一览账号" withColor:[UIColor blackColor]];
    CALayer *layer = _startBtn.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 3.0;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg_white"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0xfafafa);
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    phoneTF.delegate = self;
    securityCode.delegate = self;
    passwordTF.delegate = self;
    
    [self refreshButtonStatus];
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = UIColorFromRGB(0xe0e0e0);
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:attrs];
    phoneTF.attributedPlaceholder = string;
    string = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:attrs];
    securityCode.attributedPlaceholder = string;
    string = [[NSAttributedString alloc] initWithString:@"请输入6-20位密码" attributes:attrs];
    passwordTF.attributedPlaceholder = string;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name: UITextFieldTextDidChangeNotification object:nil];
    
    if (_phone) {
        phoneTF.text = _phone;
    }
}


#pragma mark - 动态改变社群名称输入框的高度和位置
-(void)textChanged:(NSNotification *)textView{
    [self refreshButtonStatus];
}

-(void)setBackBarBtnAtt{
    [super setBackBarBtnAtt];
    [backBarBtn_ setImage:[UIImage imageNamed:@"back_grey_new_back"] forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLayoutSubviews
{
    [self.view layoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [phoneTF resignFirstResponder];
    [securityCode resignFirstResponder];
    [passwordTF resignFirstResponder];
}

-(IBAction)timerBtnClick:(id)sender{
    if (![MyCommon isMobile:phoneTF.text]) {
        [BaseUIViewController showAlertView:nil msg:@"请输入正确的手机号" btnTitle:@"关闭"];
        return;
    }
    if (!_smsCodeCon) {
        _smsCodeCon = [self getNewRequestCon:NO];
    }
    [_smsCodeCon regestPhone:phoneTF.text];
}

#pragma mark - 倒计时方法
-(void)timeHeadle{
    timeCount--;
    if (timeCount <= 0) {
        [timeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        timeButton.userInteractionEnabled = YES;
        [timer invalidate];
    }else{
        [timeButton setTitle:[NSString stringWithFormat:@"%ld秒后重试",(long)timeCount] forState:UIControlStateNormal];
        timeButton.userInteractionEnabled = NO;
    }
}

#pragma mark - 密码的明文密文状态
- (IBAction)passWordBtnRespone:(UIButton *)sender {
    if (!passwordTF.secureTextEntry) {
        [sender setImage:[UIImage imageNamed:@"code_nosee"] forState:UIControlStateNormal];
        passwordTF.secureTextEntry = YES;
    }
    else{
        [sender setImage:[UIImage imageNamed:@"code_cansee"] forState:UIControlStateNormal];
        passwordTF.secureTextEntry = NO;
    }
}

#pragma mark - 点击用户协议跳转
- (IBAction)protocalBtnClick:(id)sender {
    AgreementCtl* agreementCtl_ = [[AgreementCtl alloc] init];
    agreementCtl_.showBlackTitle = YES;
    [self.navigationController pushViewController:agreementCtl_ animated:YES];
}

#pragma mark - 点击发送验证码
- (IBAction)initiativeVerifyBtnRespone:(UIButton *)sender{
    if (![phoneTF.text isMobileNumValid]) {
        [BaseUIViewController showAlertView:nil msg:@"请输入正确的手机号" btnTitle:@"确定"];
        return;
    }
    RegSendSmsCodeCtl *sendSmsCtl = [[RegSendSmsCodeCtl alloc]init];
    sendSmsCtl.phone = phoneTF.text;
    [self.navigationController pushViewController:sendSmsCtl animated:YES];
    [sendSmsCtl beginLoad:nil exParam:nil];
}

#pragma mark - 点击注册按钮
- (IBAction)startBtnClick:(id)sender {
    if (![phoneTF.text isMobileNumValid]) {
        [BaseUIViewController showAlertView:nil msg:@"请输入正确的手机号" btnTitle:@"确定"];
        return;
    }
    if ([[securityCode.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        [BaseUIViewController showAlertView:nil msg:@"请输入验证码" btnTitle:@"确定"];
        return;
    }
    if ([[passwordTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        [BaseUIViewController showAlertView:@"请输入密码" msg:nil btnTitle:@"确定"];
        return;
    };
    if ([passwordTF.text length] < 6 ||[passwordTF.text length] >20 ||[MyCommon checkSpacialCharacter:@"\"`'#-& " inString:passwordTF.text]) {
        [BaseUIViewController showAlertView:@"请输入6-20位字符（\"`' # - & 除外），区分大小写" msg:nil btnTitle:@"确定"];
        [passwordTF becomeFirstResponder];
        return;
    }
    if (!_registerCon) {
        _registerCon = [self getNewRequestCon:NO];
    }
    [_registerCon doRegister:phoneTF.text pwd:passwordTF.text regSource:MyClientName verifyCode:securityCode.text];
    
    
//    NSString *bodyMsg = [NSString stringWithFormat:@"mobile=%@&code=%@",phoneTF.text,securityCode.text];
//    [ELRequest postbodyMsg:bodyMsg op:@"common_reg_auth" func:@"checkMobileCode" requestVersion:NO success:^(NSURLSessionDataTask *operation, id result)
//     {
//         [BaseUIViewController showModalLoadingView:NO title:@"" status:@""];
//         NSDictionary *dic = result;
//         NSString *status = dic[@"status"];
//         if ([status isEqualToString:@"OK"])
//         {
//                
//         }else{
//             [BaseUIViewController showAutoDismissFailView:@"" msg:dic[@"status_desc"] seconds:1.0];
//         }
//     } failure:^(NSURLSessionDataTask *operation, NSError *error) {}];
}


-(void) finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch ( type ) {
        case Request_RegestPhone:
        {
            Status_DataModal *dataModal = [dataArr objectAtIndex:0];
            if( [dataModal.status_ isEqualToString:Success_Status] ){
                //验证码发送成功之后的操作
                timeCount = 60;
                [timeButton setTitle:@"60秒后重试" forState:UIControlStateNormal];
                timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeHeadle) userInfo:nil repeats:YES];
            }else{
                if ([dataModal.status_ isEqualToString:Fail_Status]) {
                    [BaseUIViewController showAutoDismissFailView:nil msg:dataModal.des_];
                }
            }
            break;
        }
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
                [BaseUIViewController showAutoDismissSucessView:nil msg:@"注册成功"];
                [self performSelector:@selector(finishInfo) withObject:nil afterDelay:1.5];
                
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

#pragma mark - 注册成功登录操作
- (void)finishInfo
{
    if ([_successDelegate respondsToSelector:@selector(refreshDelegateWithPhone:passWord:)]) {
        [_successDelegate refreshDelegateWithPhone:phoneTF.text passWord:passwordTF.text];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == phoneTF) {
        [MyCommon dealTxtFiled:textField maxLength:11];
    }else if (textField == passwordTF){
        [MyCommon dealTxtFiled:textField maxLength:20];
    }
    return YES;
}

#pragma mark - 修改注册按钮状态
-(void)refreshButtonStatus{
    NSString *str1 = [phoneTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *str2 = [securityCode.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *str3 = [passwordTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!str1 || [str1 isEqualToString:@""] || !str2 || [str2 isEqualToString:@""] || !str3 || [str3 isEqualToString:@""]){
        _startBtn.userInteractionEnabled = NO;
        [_startBtn setTitleColor:UIColorFromRGB(0xFFBEBE) forState:UIControlStateNormal];
    }else{
        _startBtn.userInteractionEnabled = YES;
        [_startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

@end
