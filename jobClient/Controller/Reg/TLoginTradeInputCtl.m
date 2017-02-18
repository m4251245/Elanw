//
//  TLoginTradeInputCtl.m
//  jobClient
//
//  Created by 一览ios on 15/1/6.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "TLoginTradeInputCtl.h"
#import "RegInfoThreeCtl.h"
#import "BindCtl.h"

#import "AssociationAppDelegate.h"
#import "RootTabBarViewController.h"

@interface TLoginTradeInputCtl ()<SelectTradeCtlDelegate>
{
    RequestCon *_saveUserCon;
}
@end

@implementation TLoginTradeInputCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        rightNavBarStr_ = @"完成";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"行业／职业";
    [self setNavTitle:@"行业／职业"];
    _tradeErrorLb.hidden = YES;
    CALayer *layer = _tradeBtn.layer;
    layer.backgroundColor = [UIColor clearColor].CGColor;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    if (requestCon == _saveUserCon) {
        Status_DataModal * dataModal = [dataArr objectAtIndex:0];
        if([dataModal.status_ isEqualToString:Success_Status]){
            [BaseUIViewController showAutoDismissSucessView:nil  msg:@"操作成功"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"showTip"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //刷新 左侧菜单
            _inDataModal.tradeName = _tradeTF.text;
            [Manager setUserInfo:_inDataModal];
//            [[Manager shareMgr].mainCtl_ refreshLoad:nil];
//            跳转到主界面
        }
        else
        {
            [BaseUIViewController showAutoDismissFailView:@"操作失败"  msg:dataModal.des_];
        }
    }
}

#pragma mark 第三方完善信息
-(void)saveUserInfo:(NSString*)userId
{
    if (!_saveUserCon) {
        _saveUserCon = [self getNewRequestCon:NO];
    }
    NSString *tradeId = _inDataModal.tradeId;
    [_saveUserCon saveUserInfo:userId job:_inDataModal.job_ sex:_inDataModal.sex_ pic:_inDataModal.img_ name:_inDataModal.name_ trade:_inDataModal.trade_ company:@"" nickname:@"" signature:@"" hkaId:@"" school:_inDataModal.school_ zym:_inDataModal.major_ rctypeId:_inDataModal.identity_ regionStr:nil workAge:nil brithday:nil tradeId:tradeId tradeName:_inDataModal.tradeName];
}

- (void)selectTrade
{
    [_jobTF resignFirstResponder];
    _tradeErrorLb.hidden = YES;
    CALayer *layer = _tradeTF.layer;
    layer.borderWidth = 0.5;
    layer.borderColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0].CGColor;
    RegInfoThreeCtl *regInfoCtl = [[RegInfoThreeCtl alloc]init];
    regInfoCtl.delegate = self;
    regInfoCtl.type = @"0";
    [self.navigationController pushViewController:regInfoCtl animated:YES];
    [regInfoCtl beginLoad:_inDataModal exParam:nil];
}


#pragma mark 选择行业代理
- (void)updateTrade:(personTagModel *)personTagModel
{
    _inDataModal.tradeId = personTagModel.tagId_;
    _inDataModal.tradeName = personTagModel.tagName_;
    _tradeTF.text = personTagModel.tagName_;
}

- (void)btnResponse:(id)sender
{
    if (sender == _tradeBtn) {
        [self selectTrade];
    }
}

- (void)rightBarBtnResponse:(id)sender
{
    __weak typeof(self) WeakSelf = self;
//    if (!_inDataModal.tradeId || [_inDataModal.tradeId isEqualToString:@"0"] || [_inDataModal.tradeId isEqualToString:@"1000"]) {
        if (_tradeTF.text && ![_tradeTF.text isEqualToString:@""]) {//如果是自定义的行业
            _inDataModal.tradeName = _tradeTF.text;
        }else{
            _tradeErrorLb.hidden = NO;
            CALayer *layer = _tradeTF.layer;
            layer.borderWidth = 1.0;
            layer.borderColor = [UIColor redColor].CGColor;
            return;
        }
//    }
    if (![[_jobTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        _inDataModal.trade_ = _jobTF.text;
    }
    
    [self saveUserInfo:_inDataModal.userId_];
    //查询绑定状态
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&", [Manager getUserInfo].userId_ ? [Manager getUserInfo].userId_:@""];
    [ELRequest postbodyMsg:bodyMsg op:@"job1001user_person_bind_busi" func:@"getBindInfo" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {

//        NSString *emailStatus = result[@"email"][@"status"];
//        NSString *phoneStatus = result[@"mobile"][@"status"];
//        NSString *qqStatus = result[@"qq"][@"status"];
//        NSString *wechatStatus = result[@"wechat"][@"status"];
//        NSString *weiboStatus = result[@"sina_weibo"][@"status"];
        
//        if (/*[emailStatus isEqualToString:@"FAIL"] && */[phoneStatus isEqualToString:@"FAIL"] ) {
//            [self goBindCtl];
//        }else{
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        }
        //完善用户信息后 直接登录
        if ([Manager shareMgr].haveLogin && [Manager shareMgr].isPublishReginfoCtl) {//登录时完善信息
            [WeakSelf login];
        }else{//注册时
            [Manager shareMgr].isPublishReginfoCtl = NO;
            [WeakSelf login];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

-(void)login{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"showTip"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if([Manager shareMgr].isThridLogin_){
        AssociationAppDelegate *delegate = (AssociationAppDelegate *)[[UIApplication sharedApplication] delegate];
        if ([Manager shareMgr].isNeedRefresh || [Manager shareMgr].isFirstLoading) {
            [Manager shareMgr].tabVC = [[RootTabBarViewController alloc]init];
            [Manager shareMgr].isNeedRefresh = NO;
        }
        if (![Manager shareMgr].tabVC) {
            [Manager shareMgr].tabVC = [[RootTabBarViewController alloc] init];
        }
        delegate.window.rootViewController = [Manager shareMgr].tabVC;
        for (id vc in [Manager shareMgr].tabVC.viewControllers) {
            if ([vc childViewControllers].count > 1) {
                [Manager shareMgr].tabVC.tabBar.hidden = YES;
            }
        }
    }
}

//设置右按扭的属性
- (void)setRightBarBtnAtt
{
    [rightBarBtn_ setTitle:@"完成" forState:UIControlStateNormal];
    [rightBarBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBarBtn_ setFrame:CGRectMake(0, 0, 55, 26)];
    [rightBarBtn_.titleLabel setFont:FIFTEENFONT_TITLE];
}

#pragma mark 下一步绑定手机号
- (void)jobTF_EndOnExit:(id)sender
{
    //保存用户信息
    [rightBarBtn_ sendActionsForControlEvents:UIControlEventTouchUpInside];


    
    //查询绑定状态
//    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&", [Manager getUserInfo].userId_ ? [Manager getUserInfo].userId_:@""];
//    [ELRequest postbodyMsg:bodyMsg op:@"job1001user_person_bind_busi" func:@"getBindInfo" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
//        NSString *emailStatus = result[@"email"][@"status"];
//        NSString *phoneStatus = result[@"mobile"][@"status"];
//        NSString *qqStatus = result[@"qq"][@"status"];
//        NSString *wechatStatus = result[@"wechat"][@"status"];
//        NSString *weiboStatus = result[@"sina_weibo"][@"status"];
//        
//        if ([emailStatus isEqualToString:@"FAIL"] && [phoneStatus isEqualToString:@"FAIL"] ) {
//            [self goBindCtl];
//        }else{
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        }
//        
//    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
//        
//    }];

    
}

- (void)goBindCtl
{
    BindCtl *bindPhoneCtl = [[BindCtl alloc]init];
    bindPhoneCtl.varifyType = VarifyTypeBindPhone;
    [self.navigationController pushViewController:bindPhoneCtl animated:YES];
}

@end
