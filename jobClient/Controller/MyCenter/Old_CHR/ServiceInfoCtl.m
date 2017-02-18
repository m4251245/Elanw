//
//  ServiceInfoCtl.m
//  jobClient
//
//  Created by YL1001 on 14-9-13.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "ServiceInfoCtl.h"
#import "NJKWebViewProgressView.h"
#import "HRLoginCtl.h"

@interface ServiceInfoCtl ()
{
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    NSString * companyId_;
    NSString * url_;
}

@end

@implementation ServiceInfoCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"服务信息";
        rightNavBarStr_ = @"解除绑定";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    webView_.delegate = _progressProxy;
    
    
    webView_.scrollView.showsHorizontalScrollIndicator = NO;
    webView_.scrollView.showsVerticalScrollIndicator   = NO;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [_progressView removeFromSuperview];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
    
    if (bridge) {
        return;
    }
    [WebViewJavascriptBridge enableLogging];
    bridge = [WebViewJavascriptBridge bridgeForWebView:webView_ webViewDelegate:_progressProxy handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *phoneNum = data;
        NSArray *urlArray = [phoneNum componentsSeparatedByString:@"||"];
        NSString *num = [urlArray objectAtIndex:0];
        num = [num stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [self dialPhoneNumber:num];
    }];
}

- (void)viewDidLayoutSubviews
{
    [self.view layoutSubviews];
}

#pragma mark -UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = request.URL.absoluteString;
    urlString = [urlString lowercaseString];
    if ([urlString isEqualToString:@"http://m.job1001.com/?type=kefu"])
    {
        MessageContact_DataModel * dataModal = [[MessageContact_DataModel alloc] init];
        dataModal.userId = @"16244860";
        dataModal.isExpert = @"1";
        dataModal.userIname = @"企业在线客服";
        dataModal.pic = @"http://img105.job1001.com/myUpload2/201503/10/1425978515_391.gif";
        dataModal.gzNum = @"10.0";
        dataModal.userZW = @"产品经理";
        dataModal.age = @"10";
        dataModal.sameCity = @"1";
        dataModal.sex = @"女";
        MessageDailogListCtl *ctl = [[MessageDailogListCtl alloc]init];
        [self.navigationController pushViewController:ctl animated:YES];
        [ctl beginLoad:dataModal exParam:nil];
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
}


- (void) dialPhoneNumber:(NSString *)aPhoneNumber
{
    
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (messageClass != nil) {
        if ([messageClass canSendText]) {
            NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",aPhoneNumber]];
            if ( !callWebView ) {
                callWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
            }
            [callWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
            [self.view addSubview:callWebView];
        }
        else {
            [BaseUIViewController showAlertView:@"设备没有电话功能" msg:nil btnTitle:@"知道了"];
        }
    }
}

-(void)updateCom:(RequestCon *)con
{
    if (url_) {
        NSURL * url = [NSURL URLWithString:url_];
        NSURLRequest * urlRequest = [[NSURLRequest alloc] initWithURL:url];
        [webView_ loadRequest:urlRequest];
    }
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    companyId_ = dataModal;
    url_ = nil;
    [super beginLoad:dataModal exParam:exParam];
}

-(void)getDataFunction:(RequestCon *)con
{
    [con getServiceUrl:companyId_];
}


-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GetServiceUrl:
        {
            url_ = [dataArr objectAtIndex:0];
        }
            break;
        case Request_CancelBindCompany:
        {
            Status_DataModal * dataModal = [dataArr objectAtIndex:0];
            if ([dataModal.status_ isEqualToString:Success_Status]) {
                [BaseUIViewController showAutoDismissSucessView:@"解绑成功" msg:nil];
                NSInteger count = self.navigationController.childViewControllers.count;
                BaseUIViewController *ctl  =self.navigationController.childViewControllers[count-3];
                [self.navigationController popToViewController:ctl animated:NO];
                HRLoginCtl *loginCtl = [[HRLoginCtl alloc]init];
                [self.navigationController pushViewController:loginCtl animated:YES];
                [Manager shareMgr].messageCountDataModal.companyCnt = 0;
                [[Manager shareMgr].tabView_ setTabBarNewMessage];
                //[[Manager shareMgr].messageRefreshCtl requestCount];
            }
            else
            {
                [BaseUIViewController showAutoDismissFailView:@"解绑失败" msg:@"请稍后再试"];
            }
        }
            break;
   
        default:
            break;
    }
}

-(void)rightBarBtnResponse:(id)sender
{
    [self showChooseAlertView:1 title:@"温馨提示" msg:@"确定解绑企业？解除绑定后将需要重新登录" okBtnTitle:@"确定退出" cancelBtnTitle:@"取消"];
}

-(void)alertViewChoosed:(UIAlertView *)alertView index:(int)index type:(int)type
{
    [super alertViewChoosed:alertView index:index type:type];
    switch (type) {
        case 1:
        {
            //解绑企业
            if (!jiebangCon_) {
                jiebangCon_ = [self getNewRequestCon:NO];
            }
            [jiebangCon_ cancelBindCompany:companyId_ personId:[Manager getUserInfo].userId_];
        }
            break;
        default:
            break;
    }
}



#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    
}

@end
