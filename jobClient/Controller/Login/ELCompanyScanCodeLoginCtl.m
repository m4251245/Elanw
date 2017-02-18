//
//  ELCompanyScanCodeLoginCtl.m
//  jobClient
//
//  Created by YL1001 on 16/8/20.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELCompanyScanCodeLoginCtl.h"

@interface ELCompanyScanCodeLoginCtl ()<UIAlertViewDelegate>
{
    NSString *_urlStr;
    NSString *_presentUrl;
}
@end

@implementation ELCompanyScanCodeLoginCtl

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"扫描绑定";
    [self setNavTitle:@"扫描绑定"];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)updateCom:(RequestCon *)con
{
    if (_urlStr) {
        NSURL *url = [NSURL URLWithString:_urlStr];
        NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
        [self.webView_ loadRequest:urlRequest];
    }
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    
    if (![Manager shareMgr].haveLogin) {
        [BaseUIViewController showAlertViewContent:@"请登录后再扫码绑定企业" toView:self.view second:2.0 animated:YES];
    }
    else
    {
        [self urlEncryption:dataModal];
    }
    
}

- (void)urlEncryption:(NSString *)urlStr
{
    NSString *componentStr = [[urlStr componentsSeparatedByString:@"uid="] lastObject];
    NSString *companyIdStr = [[componentStr componentsSeparatedByString:@"&"] firstObject];
    
    NSMutableString *keyStr = [NSMutableString stringWithFormat:@"%@job1001%@zhangtanhg", companyIdStr, [Manager getUserInfo].userId_];
    NSString *reverseKeyStr = [NSString stringWithString:[keyStr Reverse]];
    NSString *md5str = [MD5 getMD5:reverseKeyStr];
    
    
    _urlStr = [NSString stringWithFormat:@"%@&personid=%@&key=%@", urlStr, [Manager getUserInfo].userId_, md5str];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if ([_presentUrl containsString:@"http://www.job1001.com/companyServe/connect/app_company_bangding.php"])
    {
        NSString *lJs = @"document.documentElement.innerHTML";//获取当前网页的html
        NSString *currentHTML = [webView stringByEvaluatingJavaScriptFromString:lJs];
        NSLog(@"currentHTML----- %@", currentHTML);
        
        [self getHTMLStr:currentHTML];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlStr = [NSString stringWithFormat:@"%@",request.URL];
    NSLog(@"=========%@=======", urlStr);
    
    _presentUrl = urlStr;
    if ([urlStr containsString:@"http://m.job1001.com/connect/appcancel"])
    {
        [self btnResponse:self.closeBtn_];
        return NO;
    }
    
    return YES;
}

- (void)btnResponse:(id)sender
{
    if (sender == self.closeBtn_) {
        NSArray *array = [self.navigationController viewControllers];
        UIViewController *viewCtl = [array objectAtIndex:0];
        [self.navigationController popToViewController:viewCtl animated:YES];
    }
    else if (sender == self.backBtn_)
    {
        [self backBarBtnResponse:nil];
    }
}

//去掉html中的标签元素,获得纯文本
- (NSArray *)getHTMLStr:(NSString *)content
{
    NSRegularExpression *regularWxpression = [NSRegularExpression regularExpressionWithPattern:@"<[^>]*>|\n" options:0 error:nil];
    
    //替换所有html和换行匹配元素为"-"
    content = [regularWxpression stringByReplacingMatchesInString:content options:NSMatchingReportProgress range:NSMakeRange(0, content.length) withTemplate:@"-"];
    
    //把多个"-"匹配为一个"-"
    regularWxpression = [NSRegularExpression regularExpressionWithPattern:@"-{1,}" options:0 error:nil];
    content = [regularWxpression stringByReplacingMatchesInString:content options:NSMatchingReportProgress range:NSMakeRange(0, content.length) withTemplate:@"-"];
    
    //根据"-"分割到数组
    NSArray *arr = [NSArray array];
    content = [NSString stringWithString:content];
    arr = [content componentsSeparatedByString:@"-"];
    NSMutableArray *mArr = [NSMutableArray arrayWithArray:arr];
    [mArr removeObject:@""];
    [self parserData:[mArr firstObject]];
    return mArr;
}

- (void)parserData:(NSString *)jsonString
{
    if (jsonString == nil) {
        return;
    }
    
    NSError* parseError =nil;
    NSData *jsonData = [jsonString dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&parseError];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:dic[@"desc"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self btnResponse:self.closeBtn_];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
