//
//  ServiceInfo.m
//  jobClient
//
//  Created by 一览ios on 15/3/7.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//简历直推

#import "RRServiceInfo.h"
#import "RROrderCtl.h"
#import "RRResumeOrderRecord.h"
#import "MBProgressHUD.h"

@interface RRServiceInfo ()<UIWebViewDelegate, NoLoginDelegate>
{
    NSString *_buyServiceDetailId;
}
@end

@implementation RRServiceInfo
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        rightNavBarStr_ = @"订单记录";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"一览直推";
    [self setNavTitle:@"一览直推"];
    [_buyBtn setTitle:@"立即申请" forState:UIControlStateDisabled];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.job1001.com/xuanchuan/2015/personservice/zhitui.php"]]];
    _webView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (![Manager shareMgr].haveLogin) {
        _buyBtn.enabled = YES;
        return;
    }
    _buyBtn.enabled = NO;
    [self beginLoad:nil exParam:nil];
    [super viewWillAppear:animated];
//    self.navigationItem.title = @"一览直推";
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
    [con getResumeApplyStatus:userId];
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_ResumeApplyStatus://服务状态
        {
            Status_DataModal *statusModel = dataArr[0];
            if ([statusModel.code_ isEqualToString:@"10"]) {//申请
                 _buyBtn.enabled = YES;
                [_buyBtn setTitle:statusModel.des_ forState:UIControlStateNormal];
                _applyStatus = ResumeRecommendApply;
            }else if ([statusModel.code_ isEqualToString:@"30"]) {//购买
                _buyBtn.enabled = YES;
                [_buyBtn setTitle:statusModel.des_ forState:UIControlStateNormal];
                _applyStatus = ResumeRecommendPay;
                _buyServiceDetailId = statusModel.exDic_[@"service_detail_id"];
            }else if ([statusModel.code_ isEqualToString:@"20"]) {//正在审核
                _buyBtn.enabled = NO;
                [_buyBtn setTitle:statusModel.des_ forState:UIControlStateDisabled];
                [_buyBtn setBackgroundColor:[UIColor grayColor]];
                _applyStatus = ResumeRecommendExamine;
            }else{
                _buyBtn.enabled = NO;
            }
            
        }
            break;
        
        default:
            break;
    }
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{

}


- (void)btnResponse:(id)sender
{
    if (![Manager shareMgr].haveLogin) {
        [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
        return;
    }
    if (sender == _buyBtn) {
        if (_applyStatus == ResumeRecommendApply || _applyStatus == ResumeRecommendPay) {//申请页面 支付页面
            RROrderCtl *orderCtl = [[RROrderCtl alloc]init];
            orderCtl.applyStatus = _applyStatus;
            if (_applyStatus == ResumeRecommendPay) {
                orderCtl.serviceDetailId = _buyServiceDetailId;
            }
            [self.navigationController pushViewController:orderCtl animated:YES];
            [orderCtl beginLoad:nil exParam:nil];
        }
        
        return;
    }
}

- (void)setRightBarBtnAtt
{

    [super setRightBarBtnAtt];
}

- (void)rightBarBtnResponse:(id)sender
{
    //订单记录
    RRResumeOrderRecord *resume = [[RRResumeOrderRecord alloc] init];
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
