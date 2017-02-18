//
//  AgreementCtl.m
//  Association
//
//  Created by 一览iOS on 14-3-20.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "AgreementCtl.h"

@interface AgreementCtl ()

@end

@implementation AgreementCtl


- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = @"用户协议";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (_showBlackTitle) {
        [self setNavTitle:@"用户协议" withColor:[UIColor blackColor]];
    }else{
        [self setNavTitle:@"用户协议"];
    }
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    NSString * filePath_ = [[NSBundle mainBundle] pathForResource:@"deal" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath_ encoding:NSUTF8StringEncoding error:nil];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,ScreenHeight-64)];
    [self.view addSubview:webView];
    [webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath_]];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)setBackBarBtnAtt{
    [super setBackBarBtnAtt];
    if (_showBlackTitle) {
        [backBarBtn_ setImage:[UIImage imageNamed:@"back_grey_new_back"] forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
