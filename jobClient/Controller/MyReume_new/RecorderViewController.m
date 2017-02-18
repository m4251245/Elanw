//
//  RecorderViewController.m
//  jobClient
//
//  Created by 一览ios on 16/5/16.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "RecorderViewController.h"
#import "MD5.h"

#define BASE_URL @"http://www.job1001.com/myNew/m_3g.php?mode=resume&doaction=sendoutlogs&detail=index"
@interface RecorderViewController ()<UIWebViewDelegate>{
    UIWebView *webView;
    UIActivityIndicatorView *activityIndicate;
    UIView *view;
}

@end

@implementation RecorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self loadData];
}

#pragma mark-- 配置界面
-(void)configUI{
//    self.navigationItem.title = @"外发记录";
    [self setNavTitle:@"外发记录"];
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    webView.delegate = self;
    [self.view addSubview:webView];
    
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [view setBackgroundColor:UIColorFromRGB(0xbbbbbb)];
    [view setAlpha:0.5];
    [self.view addSubview:view];
    
    activityIndicate = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    activityIndicate.center = CGPointMake(ScreenWidth/2, ScreenHeight/4);
    [activityIndicate setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [view addSubview:activityIndicate];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick:)];
}
#pragma mark-- 加载数据
-(void)loadData{
    NSString *roleType = @"10";
    NSString *personId = [Manager getUserInfo].userId_;
    NSString *enkeyStr = [NSString stringWithFormat:@"%@%@",personId,@"job1001056"];
    NSString *enkey = [MD5 getMD5:enkeyStr];
    NSString *loadUrl = [NSString stringWithFormat:@"%@&uid=%@&roletype=%@&role_id=%@&enkey=%@&fromtype=app&showNum=1",BASE_URL,personId,roleType,personId,enkey];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:loadUrl]]];
}

#pragma mark-- 代理
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [activityIndicate startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [activityIndicate stopAnimating];
    [view removeFromSuperview];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"%@",error);
}
#pragma mark--事件
-(IBAction)backBtnClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setNavTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] init];
    label.center = CGPointMake(ScreenWidth/2, self.navigationController.navigationBar.height/2);
    label.bounds = CGRectMake(0, 0, 150, 44);
    label.font = [UIFont systemFontOfSize:17];
    label.text = title;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
