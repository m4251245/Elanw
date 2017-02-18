//
//  ServiceInfo.m
//  jobClient
//
//  Created by 一览ios on 15/3/7.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ServiceInfo.h"
#import "OrderCtl.h"
#import "ResumeOrderRecord.h"
#import "MBProgressHUD.h"

@interface ServiceInfo ()<UIWebViewDelegate, NoLoginDelegate>

@end

@implementation ServiceInfo
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        rightNavBarStr_ = @"订单记录";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"简历制作";
    [self setNavTitle:@"简历制作"];
    if (![Manager shareMgr].haveLogin) {
        [_buyBtn setTitle:@"立即申请" forState:UIControlStateDisabled];
    }else{
        [_buyBtn setTitle:@"您已经购买了该类服务" forState:UIControlStateDisabled];
    }
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.job1001.com/wgz/g3-jlzz/"]]];
    _webView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![Manager shareMgr].haveLogin) {
        _buyBtn.enabled = YES;
        return;
    }else{
        _buyBtn.enabled = NO;
    }
    [self beginLoad:nil exParam:nil];
//    self.navigationItem.title = @"简历制作";
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
}

- (void)getDataFunction:(RequestCon *)con
{
    NSString *userId = [Manager getUserInfo].userId_;
    if (![Manager shareMgr].haveLogin) {
//        [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
        return;
    }
//20 个人用户，企业用户不需要
    [con getServiceStatus:@"20" userId:userId serviceCode:@"P_RESUME"];
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GetServiceStatus://服务状态
        {
            NSDictionary *dict = dataArr[0];
            NSString * result = dict[@"result"];
            if ([result isEqualToString:@"0"] || [result isEqualToString:@"null"] || [result isEqualToString:@""]) {
                _buyBtn.enabled = YES;
            }else{
                 _buyBtn.enabled = NO;
                [_buyBtn setBackgroundColor:[UIColor grayColor]];
            }
        }
            break;
        
        default:
            break;
    }
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    [BaseUIViewController showModalLoadingView:NO title:nil status:nil];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    [BaseUIViewController showModalLoadingView:NO title:nil status:nil];
}


- (void)btnResponse:(id)sender
{
    if (![Manager shareMgr].haveLogin) {
        [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
        return;
    }
    if (sender == _buyBtn) {
        OrderCtl *orderCtl = [[OrderCtl alloc]init];
        [self.navigationController pushViewController:orderCtl animated:YES];
    }
}

- (void)setRightBarBtnAtt
{

    [super setRightBarBtnAtt];
}

- (void)rightBarBtnResponse:(id)sender
{
    //订单记录
    ResumeOrderRecord *resume = [[ResumeOrderRecord alloc] init];
    
    [resume beginLoad:nil exParam:nil];
    
    [self.navigationController pushViewController:resume animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)loginDelegateCtl
{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}

@end
