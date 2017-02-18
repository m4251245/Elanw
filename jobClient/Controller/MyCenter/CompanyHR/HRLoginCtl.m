//
//  HRLoginCtl.m
//  jobClient
//
//  Created by YL1001 on 14-9-4.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "HRLoginCtl.h"
#import "MD5.h"
#import "ConsultantLoginCtl.h"
#import "CHRIndexCtl.h"
#import "AD_dataModal.h"

@interface HRLoginCtl ()<UITextFieldDelegate>
{
    UIButton *backBtn;//返回按钮
    UIImageView *logoImage;//logo
    
    UITextField *accountTF;//账号
    UITextField *passwordTF;//密码
    UITextField *securityTF;//安全码
    
    UIButton *selectAccount;//选择账号
    
    UIButton *companyHRLoginBtn;//企业HR登录按钮
    UIButton *changeLoginTypeBtn;//顾问登录
    
    UIButton *regCompanyBtn;//企业注册
    
    NSString *FirstAccount;
    UIView *accountListView;
    
//    UITableView *tableView_;
    UIView *middleView;
}


@end

@implementation HRLoginCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setFd_interactivePopDisabled:YES];
    [self setNavTitle:@"企业登录"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
      // Do any additional setup after loading the view from its nib.
    
}

- (void)configUI
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,ScreenHeight)];
    scrollView.bounces = NO;
    [self.view addSubview:scrollView];
    self.scrollView_ = scrollView;
    
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 15, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"login_close.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    logoImage = [[UIImageView alloc] init];
    logoImage.center = CGPointMake(ScreenWidth/2, 100);
    logoImage.bounds = CGRectMake(0, 0, 80, 48);
    NSDictionary *dic = [self getSaveCount][0];
    [logoImage sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"companyLogo"]] placeholderImage:[UIImage imageNamed:@"yl1001logo"]];
    [scrollView addSubview:logoImage];
    
    accountTF = [[UITextField alloc] initWithFrame:CGRectMake(20, logoImage.bottom+34, ScreenWidth-40, 44)];
    accountTF.placeholder = @"请输入账号";
    accountTF.delegate= self;
    accountTF.font = [UIFont systemFontOfSize:14];
    [scrollView addSubview:accountTF];
    
    UIView *accountLine = [[UIView alloc] initWithFrame:CGRectMake(accountTF.left, accountTF.bottom, accountTF.width, 1)];
    accountLine.backgroundColor = UIColorFromRGB(0xE9E9E9);
    [scrollView addSubview:accountLine];
    
    
    selectAccount = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAccount.frame = CGRectMake(accountTF.right-22, accountTF.top+11, 22, 22);
    [selectAccount setImage:[UIImage imageNamed:@"login_arrow_down"] forState:UIControlStateNormal];
    [selectAccount setImage:[UIImage imageNamed:@"login_arrow_up"] forState:UIControlStateSelected];
    [selectAccount addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:selectAccount];
    if ([self getSaveCount].count > 1) {
        selectAccount.hidden = NO;
    }else{
        selectAccount.hidden = YES;
    }
    
    middleView = [[UIView alloc] initWithFrame:CGRectMake(accountTF.left, accountTF.bottom, accountTF.width, 200)];
    [scrollView addSubview:middleView];
    
    passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, middleView.width, accountTF.height)];
    passwordTF.placeholder = @"请输入密码";
    passwordTF.delegate = self;
    passwordTF.secureTextEntry = YES;
    passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordTF.font = [UIFont systemFontOfSize:14];
    [middleView addSubview:passwordTF];
    
    UIView *passwordLine = [[UIView alloc] initWithFrame:CGRectMake(passwordTF.left, passwordTF.bottom, middleView.width, 1)];
    passwordLine.backgroundColor = UIColorFromRGB(0xE9E9E9);
    [middleView addSubview:passwordLine];
    
    securityTF = [[UITextField alloc] initWithFrame:CGRectMake(passwordTF.left, passwordTF.bottom, passwordTF.width, passwordTF.height)];
    securityTF.placeholder = @"请输入安全码";
    securityTF.delegate = self;
    securityTF.secureTextEntry = YES;
    securityTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    securityTF.font = [UIFont systemFontOfSize:14];
    [middleView addSubview:securityTF];
    
    UIView *securityLine = [[UIView alloc] initWithFrame:CGRectMake(securityTF.left, securityTF.bottom, securityTF.width, 1)];
    securityLine.backgroundColor = UIColorFromRGB(0xE9E9E9);
    [middleView addSubview:securityLine];
    
    companyHRLoginBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(securityTF.left, securityTF.bottom+20, securityTF.width, 40);
        btn.backgroundColor = UIColorFromRGB(0xE23E3F);
        [btn setTitle:@"企业HR登录" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 4;
        btn;
    });
    [middleView addSubview:companyHRLoginBtn];
    
    changeLoginTypeBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(companyHRLoginBtn.right-90, companyHRLoginBtn.bottom+10, 90, 25);
        [btn setTitleColor:UIColorFromRGB(0xF85656) forState:UIControlStateNormal];
        [btn setTitle:@"职业顾问登录" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn;
    });
    [middleView addSubview:changeLoginTypeBtn];
    
    UIView *bottomView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-57, ScreenWidth, 57)];
        
        UILabel *label = [[UILabel alloc] init];
        label.center = CGPointMake(ScreenWidth/2-50, 10);
        label.bounds = CGRectMake(0, 0, 140, 21);
        label.text = @"如果您是企业HR，可点击";
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = UIColorFromRGB(0xbdbdbd);
        //        [label sizeToFit];
        [view addSubview:label];
        
        regCompanyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        regCompanyBtn.frame = CGRectMake(label.right, label.top, 75, 21);
        [regCompanyBtn setTitle:@"注册企业账号" forState:UIControlStateNormal];
        [regCompanyBtn setTitleColor:UIColorFromRGB(0xf85656) forState:UIControlStateNormal];
        regCompanyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [regCompanyBtn addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:regCompanyBtn];
        
        UILabel *label1 = [[UILabel alloc] init];
        label1.center = CGPointMake(ScreenWidth/2, label.bottom+10);
        label1.bounds = CGRectMake(0, 0, 200, 21);
        label1.text = @"或拨打服务热线 400-884-1001";
        label1.textColor = UIColorFromRGB(0xbdbdbd);
        label1.font = [UIFont systemFontOfSize:12];
        [view addSubview:label1];
        view;
    });
    [scrollView addSubview:bottomView];
    
    scrollView.contentSize = CGSizeMake(ScreenWidth,CGRectGetMaxY(bottomView.frame));
}

- (void)viewDidLayoutSubviews
{
    [self.view layoutSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)fd_prefersNavigationBarHidden{
    return YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self setFd_prefersNavigationBarHidden:NO];
    [super viewWillDisappear:animated];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setFd_prefersNavigationBarHidden:YES];
}


-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [self configUI];
    NSDictionary *dic = [self getSaveCount][0];
    accountTF.text = [dic objectForKey:@"Account"];
    passwordTF.text = @"";
    securityTF.text = @"";
    [accountTF resignFirstResponder];
    [passwordTF resignFirstResponder];
    [securityTF resignFirstResponder];
}

-(void)login
{
    NSString * username = [accountTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString * pwd = [passwordTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString * safeCode = [securityTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (username.length == 0) {
        [BaseUIViewController showAutoDismissAlertView:@"请填写用户名" msg:nil seconds:1.5];
        [accountTF becomeFirstResponder];
        return;
        
    }
    if (pwd.length == 0) {
        [BaseUIViewController showAutoDismissAlertView:@"请填写密码" msg:nil seconds:1.5];
        [passwordTF becomeFirstResponder];
        return;
    }
    if (safeCode.length == 0) {
        [BaseUIViewController showAutoDismissAlertView:@"请填写安全码" msg:nil seconds:1.5];
        [securityTF becomeFirstResponder];
        return;
    }
    if (!loginCon_) {
        loginCon_ = [self getNewRequestCon:NO];
    }
    pwd = [MD5 getMD5:pwd];
    [loginCon_ companyLogin:username pwd:pwd safeCode:safeCode];
}


-(void)bindingCompany:(NSString*)companyId userID:(NSString*)userId synergyId:(NSString *)synergyId
{
    if (!bindcon_) {
        bindcon_ = [self getNewRequestCon:NO];
    }
    [bindcon_ bindingCompany:companyId personId:userId synergyId:synergyId];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_CompanyLogin:
        {
            CompanyLogin_DataModal * dataModal = [dataArr objectAtIndex:0];
            if ([dataModal.status_ isEqualToString:Success_Status]) {
                
                [BaseUIViewController showAutoDismissSucessView:@"登录成功" msg:nil seconds:2];
                [CommonConfig setDBValueByKey:@"companyID" value:dataModal.companyId_];
                if (dataModal.synergy_id) {
                     [CommonConfig setDBValueByKey:@"synergy_id" value:dataModal.synergy_id];
                }else{
                     [CommonConfig setDBValueByKey:@"synergy_id" value:@""];
                }
               
                //登录成功跳转到hr的首页
                CHRIndexCtl * chrIndexCtl = [[CHRIndexCtl alloc] init];
                chrIndexCtl.islogin = YES;
                chrIndexCtl.companyId =  dataModal.companyId_;
                [self.navigationController pushViewController:chrIndexCtl animated:YES];
                [chrIndexCtl beginLoad:dataModal.companyId_ exParam:nil];
                
                [self bindingCompany:dataModal.companyId_ userID:[Manager getUserInfo].userId_ synergyId:dataModal.synergy_id];
                
                [self saveCompanyAccountWithId:dataModal.companyId_];
                
                [[Manager shareMgr].messageRefreshCtl requestCount];
            }
            else
            {
                [BaseUIViewController showAutoDismissFailView:@"" msg:@"用户名或密码错误" seconds:2];
            }
        }
            break;
        case Request_BindingCompany:
        {
            Status_DataModal * dataModal = [dataArr objectAtIndex:0];
            if ([dataModal.status_ isEqualToString:Success_Status]) {
            
            }
            else
            {
                [self bindingCompany:[CommonConfig getDBValueByKey:@"companyID"] userID:[Manager getUserInfo].userId_ synergyId:[CommonConfig getDBValueByKey:@"synergy_id"]];
            }

        }
            
            break;
        default:
            break;
    }
}

-(void)btnResponse:(id)sender
{
    if (sender == backBtn) {
        [super backBarBtnResponse:nil];
    }else if (sender == changeLoginTypeBtn){
        ConsultantLoginCtl *consultantLoginCtl = [[ConsultantLoginCtl alloc] init];
        [self.navigationController pushViewController:consultantLoginCtl animated:YES];
    }else if (sender == companyHRLoginBtn){
        [self login];
    }else if (sender == regCompanyBtn){
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.job1001.com/companyServe/reg.php"]];
    }else if (sender == selectAccount){
        selectAccount.selected = !selectAccount.selected;
        [self updateUI];
        
        
    }
}

#pragma mark - 保存账号和企业id
- (void)saveCompanyAccountWithId:(NSString *)companyId
{
    //记录多个企业账号
//    NSArray *accountArr = [self getSaveCount];
//    if (accountArr) {
        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:[self getSaveCount]];
        [tempArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = tempArr[idx];
            if ([[dic objectForKey:@"Account"] isEqualToString:accountTF.text]) {
                
                [tempArr removeObjectAtIndex:idx];

            }
            
        }];
        
        if (tempArr.count >= 3) {//超出3个 移除最后一个
            [tempArr removeLastObject];
        }
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:accountTF.text,@"Account",companyId,@"companyId", nil];
        
        [tempArr insertObject:dic atIndex:0];
        NSArray *array = tempArr;
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"companyAccount"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (NSArray *)getSaveCount
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"companyAccount"];
}

- (void)updateUI
{
    if (selectAccount.selected) {
        if (!accountListView) {
            accountListView = [[UIView alloc] init];
            NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"companyAccount"];
            for (int i = 1 ; i<array.count; i++) {
                accountListView.frame = CGRectMake(accountTF.left, accountTF.bottom, accountTF.width, 44*i);
                UIView *view = [self saveAccountView:i];
                CGRect frame = view.frame;
                frame.origin.y = 44*(i-1);
                view.frame = frame;
                [accountListView addSubview:view];
            }
            [self.view addSubview:accountListView];
            CGRect frame = middleView.frame;
            frame.origin.y = accountListView.bottom;
            middleView.frame = frame;
        }
    }else{
    
        [accountListView removeFromSuperview];
        accountListView = nil;
        CGRect frame = middleView.frame;
        frame.origin.y = accountTF.bottom;
        middleView.frame = frame;
    }

}
#pragma mark - 保存账号的视图
- (UIView *)saveAccountView:(NSInteger)idx
{
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"companyAccount"];
    NSDictionary *dic = array[idx];
    
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-40, 44)];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 14, 40, 24)];
    [imgView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"companyLogo"]] placeholderImage:[UIImage imageNamed:@"yl1001logo"]];
    [bgview addSubview:imgView];
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake(imgView.right+10, imgView.top, bgview.width-imgView.width-40, imgView.height);
    NSString *title = [dic objectForKey:@"Account"];
    [selectBtn setTitle:title forState:UIControlStateNormal];
    [selectBtn setTitleColor:UIColorFromRGB(0x212121) forState:UIControlStateNormal];
    selectBtn.tag = 100+idx;
    [selectBtn addTarget:self action:@selector(selectAccount:) forControlEvents:UIControlEventTouchUpInside];
    selectBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [bgview addSubview:selectBtn];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(selectBtn.right+10, selectBtn.top, 22, 22);
    [deleteBtn setImage:[UIImage imageNamed:@"input_del"] forState:UIControlStateNormal];
    deleteBtn.tag = 200+idx;
    [deleteBtn addTarget:self action:@selector(deleteAccount:) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:deleteBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, selectBtn.bottom+6, bgview.width, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xE9E9E9);
    [bgview addSubview:lineView];
    
    return bgview;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == accountTF) {
        [accountTF resignFirstResponder];
        [passwordTF becomeFirstResponder];
    }
    if (textField == passwordTF) {
        [passwordTF resignFirstResponder];
        [securityTF becomeFirstResponder];
    }
    if (textField == securityTF) {
        [self login];
        [securityTF resignFirstResponder];
    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self removeAcountView];
    return YES;
}

- (void)selectAccount:(UIButton *)sender
{
    NSInteger tag = sender.tag - 100;
    NSArray *accountArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"companyAccount"];
    accountTF.text = [accountArr[tag] objectForKey:@"Account"];
    [logoImage sd_setImageWithURL:[NSURL URLWithString:[accountArr[tag] objectForKey:@"companyLogo"]] placeholderImage:[UIImage imageNamed:@"yl1001logo"]];
}

- (void)deleteAccount:(UIButton *)sender
{
    NSInteger tag = sender.tag - 200;
//    NSArray *accountArr = [self getSaveCount];
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:[self getSaveCount]];
    [tempArr removeObjectAtIndex:tag];
    NSArray *array = tempArr;
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"companyAccount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    if (array.count <= 1) {
      
        [self removeAcountView];
        selectAccount.hidden = YES;
        return;
    }
    
    [accountListView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [accountListView removeFromSuperview];
    accountListView = nil;
    accountListView = [[UIView alloc] init];
    for (int i = 1 ; i<array.count; i++) {
        accountListView.frame = CGRectMake(accountTF.left, accountTF.bottom, accountTF.width, 44*i);
        UIView *view = [self saveAccountView:i];
        CGRect frame = view.frame;
        frame.origin.y = 44*(i-1);
        [accountListView addSubview:view];
    }
    [self.view addSubview:accountListView];
    CGRect frame = middleView.frame;
    frame.origin.y = accountListView.bottom;
    middleView.frame = frame;

}

- (void)removeAcountView
{
    if (accountListView) {
        [accountListView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [accountListView removeFromSuperview];
        accountListView = nil;
        
        CGRect frame = middleView.frame;
        frame.origin.y = accountTF.bottom;
        middleView.frame = frame;
        
        selectAccount.selected = NO;
    }
}

-(void)keyboardWillHide:(NSNotification *)notification{
    [super keyboardWillHide:notification];
    CGRect frame = self.scrollView_.frame;
    frame.size.height = ScreenHeight;
    self.scrollView_.frame = frame;
}

-(void)keyboardWillShow:(NSNotification *)notification{
    [super keyboardWillShow:notification];
    CGRect frame = self.scrollView_.frame;
    frame.size.height = ScreenHeight-self.keyBoardHeight;
    self.scrollView_.frame = frame;
}

-(void)dismissKeyboard{
    [accountTF resignFirstResponder];
    [passwordTF resignFirstResponder];
    [securityTF resignFirstResponder];
}

@end
