//
//  ELMyAccountCtl.m
//  jobClient
//
//  Created by YL1001 on 15/8/31.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELMyAccountCtl.h"
#import "ELRewardTraddeRecordCtl.h"

#import "ELRealNameAuthenticationCtl.h"
#import "ELRealNameAuthenticationPrivilegeCtl.h"

@interface ELMyAccountCtl ()
{
    UIView *maskView_;
    BOOL _isKeyboardShow;
    RequestCon *_myAccountCon;//我的账户
    RequestCon *_cashApplyCon;//提现申请
    
    ELRequest *mobileRequest;
    NSString *realNameStatusCode;
    
    NSMutableDictionary *payInfoDic;
    
    NSString *filePath;
}
@property (weak, nonatomic) IBOutlet UIView *headerBgView;

@end

@implementation ELMyAccountCtl

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _headerBgView.backgroundColor = UIColorFromRGB(0xe13e3e);
//    self.navigationItem.title = @"我的账户";
    [self setNavTitle:@"我的账户"];
    _isKeyboardShow = YES;
    self.scrollView_.scrollEnabled = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    withdrawBtn_.layer.borderWidth = 0.5;
    withdrawBtn_.layer.borderColor = [UIColor whiteColor].CGColor;
    withdrawBtn_.layer.cornerRadius = 4;
    
    withdrawBgView_.layer.cornerRadius = 8;
    
    userNameTF_.layer.borderWidth = 1;
    userNameTF_.layer.borderColor = UIColorFromRGB(0xEDEDED).CGColor;
    
    
    aliPayTF_.layer.borderWidth = 1;
    aliPayTF_.layer.borderColor = UIColorFromRGB(0xEDEDED).CGColor;
    
    phoneNumTF_.layer.borderWidth = 1;
    phoneNumTF_.layer.borderColor = UIColorFromRGB(0xEDEDED).CGColor;
    phoneNumTF_.keyboardType = UIKeyboardTypeNumberPad;
    
    //监听textfield内容长度变化
    [aliPayTF_ addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [userNameTF_ addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [phoneNumTF_ addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    sureBtn_.layer.cornerRadius = 6;
    sureBtn_.backgroundColor = PINGLUNHUI;
    sureBtn_.enabled = NO;
    
    authCodeBtn.layer.cornerRadius = 4;
    
    NSArray *paths  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *docDir = [paths objectAtIndex:0];
    if(!docDir) {
        NSLog(@"Documents 目录未找到");
    }
    filePath = [docDir stringByAppendingPathComponent:@"testFile.txt"];
    
    UITapGestureRecognizer *withdrawViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(withdrawBgViewTap)];
    [withdrawBgView_ addGestureRecognizer:withdrawViewTap];
}

-(void)viewDidLayoutSubviews
{
    [self.view layoutSubviews];
}

- (void)withdrawBgViewTap
{
    [aliPayTF_ resignFirstResponder];
    [userNameTF_ resignFirstResponder];
    [phoneNumTF_ resignFirstResponder];
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    if (!_myAccountCon) {
        _myAccountCon = [self getNewRequestCon:NO];
    }
    [self getDataFunction:_myAccountCon];
}

- (void)getDataFunction:(RequestCon *)con
{
    NSString *userId = [Manager getUserInfo].userId_;
    if (!userId) {
        return;
    }
    [_myAccountCon getMyAccount:userId];
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GetMyAccount://我的账户
        {
            NSDictionary *result = dataArr[0];
            NSString *balance = result[@"person_balance"];
            if (balance == nil) {
                balance = @"0.00";
            }
            
            if ([balance floatValue] < 0) {
                balance = @"0.00";
            }
            
            _balance = balance;
            balanceMoneyLb_.text = balance;
        }
            break;
        case Request_ApplyCash://提现申请
        {
            Status_DataModal * datamodal = [dataArr objectAtIndex:0];
            if ([datamodal.status_ isEqualToString:Success_Status]) {
                [BaseUIViewController showAlertView:@"" msg:@"提现成功，提现金额会在7个工作日内到达你的账户" btnTitle:@"确定"];
                balanceMoneyLb_.text = @"0.00";
            }
            else{
                [BaseUIViewController showAutoDismissFailView:@"" msg:datamodal.des_];
            }
        }
            break;
        default:
            break;
    }
}

- (void)btnResponse:(id)sender
{
    if (sender == leftBtn_) {
        [self backBarBtnResponse:sender];
    }
    else if (sender == withdrawBtn_)
    {//提现按钮
        [self realNameState];
    }
    else if (sender == tradRecordBtn_)
    {//流水记录
        ELRewardTraddeRecordCtl *ctl = [[ELRewardTraddeRecordCtl alloc] init];
        [ctl beginLoad:nil exParam:nil];
        [self.navigationController pushViewController:ctl animated:YES];
    }
    else if (sender == sureBtn_) {//提现申请
        [self isVerifyCashCode];
        
    }
    else if (sender == cancelBtn_) { // 取消提现
        //移除缓存
        NSFileManager * fileManager = [[NSFileManager alloc]init];
        [fileManager removeItemAtPath:filePath error:nil];
        
        aliPayTF_.text = @"";
        userNameTF_.text = @"";
        phoneNumTF_.text = @"";
        
        [self maskClicked];
    }
    else if (sender == authCodeBtn)
    {//获取验证码
        NSString *userId = [Manager getUserInfo].userId_;
        
        NSString * function = @"sendCashCode";
        NSString * op = @"yl_bill_record_busi";
        
        NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@",userId];
        
        if (!mobileRequest) {
            mobileRequest = [[ELRequest alloc] init];
        }
        
        Status_DataModal *statusModal = [[Status_DataModal alloc] init];
        
        [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
            
            NSDictionary *dic = result;
            statusModal.status_ = [dic objectForKey:@"status_desc"];
            statusModal.code_ = [dic objectForKey:@"code"];
            
            if ([statusModal.code_ isEqualToString:@"200"]) {
                authCodeBtn.backgroundColor = PINGLUNHUI;
                [self startTimer];
            }
            else{
                [BaseUIViewController showAlertView:@"" msg:@"未验证手机" btnTitle:@"确定"];
            }
            
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            [BaseUIViewController showAlertView:@"" msg:@"请打开网络" btnTitle:@"确定"];
        }];
        
    }
}

#pragma mark - 实名验证
-(void)realNameState
{
    if (![Manager shareMgr].haveLogin)
    {
        return;
    }
    
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@",[Manager getUserInfo].userId_];
    [ELRequest postbodyMsg:bodyMsg op:@"person_info_busi" func:@"get_shiming_info" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
     {
         NSDictionary *dic = result;
         realNameStatusCode = dic[@"code"];
         if ([realNameStatusCode isEqualToString:@"200"])//已认证
         {
             [self isVerifyMobile];
         }
         else
         {
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"提现需要实名认证哦！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
             [alertView show];
         }
     } failure:^(NSURLSessionDataTask *operation, NSError *error) {
         
     }];
}

#pragma mark - 验证码倒计时
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
                [authCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                authCodeBtn.userInteractionEnabled = YES;
                authCodeBtn.backgroundColor = PINGLUNHONG;

            });
        }else{
            int seconds = timeout;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [authCodeBtn setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
                authCodeBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
        {
            ELRealNameAuthenticationPrivilegeCtl *ctl = [[ELRealNameAuthenticationPrivilegeCtl alloc] init];
            [self.navigationController pushViewController:ctl animated:YES];
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - UITextFiledDelegate
- (void)textFieldDidChange:(id)sender
{
    if (aliPayTF_.text.length > 0 && userNameTF_.text.length > 0 && phoneNumTF_.text.length > 0) {
        sureBtn_.backgroundColor = PINGLUNHONG;
        sureBtn_.enabled = YES;
    }
    else
    {
        sureBtn_.backgroundColor = PINGLUNHUI;
        sureBtn_.enabled = NO;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == phoneNumTF_) {
        NSUInteger lengthOfString = string.length;
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {//只允许数字输入
            unichar character = [string characterAtIndex:loopIndex];
            if (character < 48) return NO; // 48 unichar for 0
            if (character > 57) return NO; // 57 unichar for 9
        }
        // Check for total length
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if (proposedNewLength > 6) return NO;//限制长度
    }
    
    return YES;
}


#pragma mark - 是否验证过手机
- (void)isVerifyMobile
{
    NSString *userId = [Manager getUserInfo].userId_;
    if (!userId) {
        return;
    }
    
    NSString * function = @"isVerifyMobile";
    NSString * op = @"yl_bill_record_busi";
    
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@",userId];
    
    if (!mobileRequest) {
        mobileRequest = [[ELRequest alloc] init];
    }
    
    Status_DataModal *statusModal = [[Status_DataModal alloc] init];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        NSDictionary *dic = result;
        statusModal.status_ = [dic objectForKey:@"status_desc"];
        statusModal.code_ = [dic objectForKey:@"code"];
        
        if ([statusModal.code_ isEqualToString:@"200"]) {
            if ([balanceMoneyLb_.text floatValue] <= 0) {
                [BaseUIViewController showAlertView:@"" msg:@"您的余额不足!" btnTitle:@"确定"];
            }
            else
            {
                NSArray *array = [[NSArray alloc] initWithContentsOfFile:filePath];
                if (array != nil) {
                    for (NSDictionary *dic in array) {
                        aliPayTF_.text = [dic objectForKey:@"aliPayText"];
                        userNameTF_.text = [dic objectForKey:@"userNameText"];
                        phoneNumTF_.text = [dic objectForKey:@"phoneNumText"];
                    }
                    sureBtn_.enabled = YES;
                    sureBtn_.backgroundColor = PINGLUNHONG;
                    
                    authCodeBtn.enabled = YES;
                    authCodeBtn.backgroundColor = PINGLUNHONG;
                }
                else
                {
                    aliPayTF_.text = @"";
                    userNameTF_.text = @"";
                    phoneNumTF_.text = @"";
                }
                [self showWithdrawBgView];
            }
        }
        else{
            [BaseUIViewController showAlertView:@"手机未认证" msg:@"请去官网(www.yl1001.com）个人中心，进行手机认证" btnTitle:@"确定"];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self showWithdrawBgView];
    }];
}

#pragma mark - 验证 验证码是否正确
- (void)isVerifyCashCode
{
    NSString *userId = [Manager getUserInfo].userId_;
    if (!userId) {
        return;
    }

    NSString * function = @"verifyCashCode";
    NSString * op = @"yl_bill_record_busi";
    
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&code=%@",userId,phoneNumTF_.text];
    
    Status_DataModal *statusModal = [[Status_DataModal alloc] init];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        NSDictionary *dic = result;
        statusModal.status_ = [dic objectForKey:@"status_desc"];
        statusModal.code_ = [dic objectForKey:@"code"];
        
        if ([statusModal.code_ isEqualToString:@"200"]) {
            //成功提交提现申请
            if (!_cashApplyCon) {
                _cashApplyCon = [self getNewRequestCon:NO];
            }
            NSString *money = balanceMoneyLb_.text;//金额需要填写
            NSString *account = aliPayTF_.text;
            NSString *accName = userNameTF_.text;
            
            if (!payInfoDic) {
                payInfoDic = [[NSMutableDictionary alloc] init];
            }
            [payInfoDic setValue:aliPayTF_.text forKey:@"aliPayText"];
            [payInfoDic setValue:userNameTF_.text forKey:@"userNameText"];
            
            NSArray *array = [[NSArray alloc] initWithObjects:payInfoDic,nil];
            [array writeToFile:filePath atomically:YES];
            
            [self maskClicked];
            [_cashApplyCon cashApply:userId money:money summary:@"提现申请" account:account accName:accName];
        }
        else{
            [BaseUIViewController showAlertView:@"" msg:@"验证码错误" btnTitle:@"确定"];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [BaseUIViewController showAlertView:@"" msg:@"请打开网络" btnTitle:@"确定"];
    }];
}

-(void)backBarBtnResponse:(id)sender
{
    [super backBarBtnResponse:sender];
}

#pragma mark 显示WithdrawBgView
- (void)showWithdrawBgView
{
    if (!maskView_) {
        maskView_ = [[UIView alloc]initWithFrame:self.view.bounds];
        maskView_.backgroundColor = [UIColor blackColor];
        maskView_.alpha = 0.0;
        [MyCommon addTapGesture:maskView_ target:self numberOfTap:1 sel:@selector(maskClicked)];
    }
    
    CGRect frame = CGRectMake((ScreenWidth - withdrawBgView_.frame.size.width)/2, 700, 270, 220);
    withdrawBgView_.frame = frame;
    maskView_.frame = self.view.bounds;
    
    [self.view addSubview:maskView_];
    [self.view addSubview:withdrawBgView_];
    
    [UIView animateWithDuration:0.3 animations:^{
        maskView_.alpha = 0.7;
        withdrawBgView_.frame = CGRectMake((ScreenWidth - withdrawBgView_.frame.size.width)/2, (ScreenHeight - withdrawBgView_.frame.size.height)/2, 270, 220);
    }];
}

#pragma mark 隐藏WithdrawBgView
- (void)maskClicked
{
    [aliPayTF_ resignFirstResponder];
    [userNameTF_ resignFirstResponder];
    [phoneNumTF_ resignFirstResponder];
    
    [UIView animateWithDuration:0.3 animations:^{
        maskView_.alpha = 0.0;
        withdrawBgView_.frame = CGRectMake((ScreenWidth - withdrawBgView_.frame.size.width)/2, 700, 270, 220);
        
    } completion:^(BOOL finished) {
        [maskView_ removeFromSuperview];
        [withdrawBgView_ removeFromSuperview];
    }];
}


#pragma mark - Responding to keyboard events
- (void)keyboardShow:(NSNotification *)notification {
    
    CGRect frame = withdrawBgView_.frame;
    if (_isKeyboardShow) {
        frame.origin.y = withdrawBgView_.frame.origin.y - 100;
        withdrawBgView_.frame = frame;
        _isKeyboardShow = NO;
    }
}

- (void)keyboardHide:(NSNotification *)notification {
    
    CGRect frame = withdrawBgView_.frame;
    if (!_isKeyboardShow) {
        frame.origin.y = withdrawBgView_.frame.origin.y + 100;
        withdrawBgView_.frame = frame;
        _isKeyboardShow = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
