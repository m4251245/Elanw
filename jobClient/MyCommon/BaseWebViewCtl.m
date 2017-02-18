//
//  BaseWebViewCtl.m
//  jobClient
//
//  Created by YL1001 on 14-9-4.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseWebViewCtl.h"
#import "NJKWebViewProgressView.h"

@interface BaseWebViewCtl ()<UIGestureRecognizerDelegate>

@end

@implementation BaseWebViewCtl
{
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    NSString            * url_;
}
@synthesize webView_,backBtn_,closeBtn_;

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
////    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
////        return YES;
////    }
////    return NO;
//    return YES;
//}

- (void)dealloc
{
    [_progressView removeFromSuperview];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.hidesBackButton = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView_.dataDetectorTypes = UIDataDetectorTypeNone;
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    webView_.delegate = _progressProxy;
    closeBtn_.alpha = 0.0;
    
    webView_.scrollView.showsHorizontalScrollIndicator = NO;
    webView_.scrollView.showsVerticalScrollIndicator   = NO;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController.navigationBar addSubview:_progressView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [_progressView removeFromSuperview];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateCom:(RequestCon *)con
{
    NSURL * url = [NSURL URLWithString:url_];
    NSURLRequest * urlRequest = [[NSURLRequest alloc] initWithURL:url];
    [webView_ loadRequest:urlRequest];
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    if (dataModal == nil) {
//        self.navigationItem.title = @"微雇主";
        [self setNavTitle:@"微雇主"];
        url_ = @"http://m.job1001.com/wgz/index";
        [self updateCom:nil];
    }
    else
    {
        [super beginLoad:dataModal exParam:exParam];
    }
    
    
}


-(void)btnResponse:(id)sender
{
    if (sender == backBtn_) {
        if (webView_.canGoBack) {
            [webView_ goBack];
        }
        else
        {
            [self backBarBtnResponse:nil];
        }
    }
    else if(sender == closeBtn_)
    {
        [self backBarBtnResponse:nil];
    }
}

-(void)backBarBtnResponse:(id)sender{
    [super backBarBtnResponse:sender];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (webView_.canGoBack) {
        closeBtn_.alpha = 1.0;
    }
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}


//加密
- (NSString *)encryptionId:(NSString *)personId
{
    
    NSInteger index1 = arc4random() % 9 + 1;
    NSInteger index2 = arc4random() % 9 + 1;
    NSInteger index3 = arc4random() % 9 + 1;
    
    NSMutableString *str = [[NSMutableString alloc] initWithString:personId];
    [str insertString:[NSString stringWithFormat:@"%ld",(long)index1] atIndex:str.length];
    [str insertString:[NSString stringWithFormat:@"%ld",(long)index2] atIndex:3];
    [str insertString:[NSString stringWithFormat:@"%ld",(long)index3] atIndex:0];
    
    NSString *subStr = @"background";
    NSString *strTwo = @"";
    
    for (NSInteger i = 0;i <str.length; i++)
    {
        NSString *strOne = [subStr substringWithRange:NSMakeRange([[str substringWithRange:NSMakeRange(i,1)] integerValue],1)];
        strTwo = [NSString stringWithFormat:@"%@%@",strTwo,strOne];
    }
    
    return strTwo;
}

//同步3G登录页面
- (NSString *)changeLinkUrl:(NSString *)url PersonId:(NSString *)personId
{
    if (url && ![url isEqualToString:@""])
    {
        NSString *timeNow = [NSString stringWithFormat:@"%.f",[[NSDate date] timeIntervalSince1970]];
        NSString *personIdStr = personId;
        if(!personIdStr || [personIdStr isEqualToString:@""]){
            return url;
        }
        NSString *mD5CodeStr = @"1qaz2wsx1001";
        NSString *md5_1 = [MD5 getMD5:[NSString stringWithFormat:@"%@%@",personIdStr,timeNow]];
        NSString *cksMD5Str = [MD5 getMD5:[NSString stringWithFormat:@"%@%@",md5_1, mD5CodeStr]];
        
        NSString *encodedString = (NSString *)
        CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                  (CFStringRef)url,
                                                                  NULL,
                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                  kCFStringEncodingUTF8));
        
        NSString *relUrl = [NSString stringWithFormat:@"http://m.yl1001.com/general/login?pid=%@&time=%@&cks=%@&jumpurl=%@", personIdStr, timeNow, cksMD5Str, encodedString];
        return relUrl;
    }
    return nil;
}

@end
