//
//  YLAddressBookDeclarationCtl.m
//  jobClient
//
//  Created by 一览iOS on 15/6/18.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "YLAddressBookDeclarationCtl.h"

@interface YLAddressBookDeclarationCtl ()
{
    __weak IBOutlet UIWebView *webView_;
}
@end

@implementation YLAddressBookDeclarationCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //addressbookdeclaration
    //获取内容
//    self.navigationItem.title = @"服务声明";
    [self setNavTitle:@"服务声明"];
    webView_.multipleTouchEnabled = YES;
    webView_.scalesPageToFit = YES;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.yl1001.com/common/statement"]];
    [webView_ loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
