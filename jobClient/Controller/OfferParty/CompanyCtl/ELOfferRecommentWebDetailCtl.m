//
//  ELOfferRecommentWebDetailCtl.m
//  jobClient
//
//  Created by 一览iOS on 16/5/20.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELOfferRecommentWebDetailCtl.h"
#import "User_DataModal.h"

@interface ELOfferRecommentWebDetailCtl () <UIWebViewDelegate>
{
    __weak IBOutlet UIActivityIndicatorView *_activityView;
    __weak IBOutlet UIWebView *_webView;
    User_DataModal *dataModel;
}
@end

@implementation ELOfferRecommentWebDetailCtl

- (void)viewDidLoad {
    self.footerRefreshFlag = NO;
    self.headerRefreshFlag = NO;
    self.showNoDataViewFlag = NO;
    self.showNoMoreDataViewFlag = NO;
    self.noRefershLoadData = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.navigationItem.title = @"推荐报告";
    [self setNavTitle:@"推荐报告"];
   
}

-(void)beginLoad:(id)param exParam:(id)exParam{
    dataModel = param;
    [self loadData];
}

-(void)loadData{

    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:dataModel.jlType forKey:@"tjtype"];
    [conditionDic setObject:dataModel.recommendId forKey:@"tjid"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&roletype=%@&role_id=%@&conditionArray=%@",dataModel.userId_,_type,dataModel.role_id,conditionStr];
    NSString * function = @"getPreivewResumeUrl_offerpai";
    NSString * op = @"offerpai_busi";
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:result[@"url"]]];
        _webView.delegate = self;
        [_webView loadRequest:request];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}


-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [_activityView startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_activityView stopAnimating];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_activityView stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
