//
//  WebLinkCtl.m
//  Association
//
//  Created by 一览iOS on 14-1-20.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "WebLinkCtl.h"
#import "MD5.h"

@interface WebLinkCtl ()

@end

@implementation WebLinkCtl
- (void)dealloc
{

}

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

    [self setNavTitle:@"官方网站"];
    webview_.scalesPageToFit = YES;
    webview_.delegate = self;
    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
    
    NSURL *url = nil;
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long int temp = (long long int)time;
    
    NSString *mdfStr = [MD5 getMD5:[NSString stringWithFormat:@"%@%lld",[Manager getUserInfo].userId_, temp]];
    md5Scr_ = [MD5 getMD5:[NSString stringWithFormat:@"%@1qaz2wsx1001",mdfStr]];
    
    if ([Manager shareMgr].haveLogin) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.yl1001.com/general/login?pid=%@&time=%lld&cks=%@&appflag=1002",[Manager getUserInfo].userId_, temp, md5Scr_]];
    }else{
        url = [[NSURL alloc]initWithString:@"http://www.yl1001.com?appflag=1002"];
    }
    [webview_ loadRequest:[NSURLRequest requestWithURL:url]];
    
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    [self updateCom:nil];
}


-(void)dismissModal
{
    [BaseUIViewController showLoadView:NO content:nil view:nil];
    [BaseUIViewController showAutoDismissSucessView:@"加载完毕" msg:nil];
}

#pragma mark-  UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [BaseUIViewController showLoadView:YES content:@"正在加载" view:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [BaseUIViewController showLoadView:NO content:nil view:nil];
    [BaseUIViewController showAutoDismissSucessView:@"加载完毕" msg:nil];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [BaseUIViewController showLoadView:NO content:nil view:nil];
//    [BaseUIViewController showAutoDismissFailView:@"网络连接失败" msg:nil];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
     NSString *urlStr = [NSString stringWithFormat:@"%@",request.URL];
    
    if (![urlStr containsString:@"appflag"]) {//子页面没有包含appflag，则拼接appflag=1002
        if([urlStr containsString:@"?"]){
            urlStr = [NSString stringWithFormat:@"%@&appflag=1002",urlStr];
        }else{
            urlStr = [NSString stringWithFormat:@"%@?appflag=1002",urlStr];
        }
        
        NSURL * url = [NSURL URLWithString:urlStr];
        NSURLRequest * urlRequest = [[NSURLRequest alloc] initWithURL:url];
        [webview_ loadRequest:urlRequest];
        return NO;
    }
    
    return YES;
}

@end
