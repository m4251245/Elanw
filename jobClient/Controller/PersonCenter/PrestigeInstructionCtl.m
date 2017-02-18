//
//  PrestigeInstructionCtl.m
//  jobClient
//
//  Created by 一览iOS on 15-3-5.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "PrestigeInstructionCtl.h"

@interface PrestigeInstructionCtl ()

@end

@implementation PrestigeInstructionCtl

-(id)init
{
    self = [super init];
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([_type isEqualToString:@"1"]) {
//        self.navigationItem.title = @"一览行家约谈服务条规说明";
        [self setNavTitle:@"一览行家约谈服务条规说明"];
    }
    else if ([_type isEqualToString:@"interViewFingerpost"])
    {
//        self.navigationItem.title = @"约谈指南";
        [self setNavTitle:@"约谈指南"];
    }
    else if ([_type isEqualToString:@"行家类型说明"])
    {
//        self.navigationItem.title = @"行家类型说明";
        [self setNavTitle:@"行家类型说明"];
    }
    else
    {
//        self.navigationItem.title = @"声望与徽章帮助说明";
        [self setNavTitle:@"声望与徽章帮助说明"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"声望与徽章帮助说明";
    [self setNavTitle:@"声望与徽章帮助说明"];
    // Do any additional setup after loading the view from its nib.
    
    if ([_type isEqualToString:@"1"]) {//行家约谈服务条规
        NSURL *url = [NSURL URLWithString:@"http://m.yl1001.com/common/yuetanhelp"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
    else if ([_type isEqualToString:@"interViewFingerpost"])
    {
        NSURL *url = [NSURL URLWithString:@"http://m.yl1001.com/common/zdhelp"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
    else if ([_type isEqualToString:@"行家类型说明"])
    {
        NSURL *url = [NSURL URLWithString:@"http://m.yl1001.com/common/experthelpp"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
//    else
//    {
//        NSString * filePath_ = [[NSBundle mainBundle] pathForResource:@"usersign" ofType:@"html"];
//        NSString *htmlString = [NSString stringWithContentsOfFile:filePath_ encoding:NSUTF8StringEncoding error:nil];
//        [self.webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath_]];
//    }
    
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
