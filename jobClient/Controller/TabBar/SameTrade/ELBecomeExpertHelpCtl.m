//
//  ELBecomeExpertHelpCtl.m
//  jobClient
//
//  Created by 一览iOS on 15/9/22.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELBecomeExpertHelpCtl.h"

@interface ELBecomeExpertHelpCtl ()
{
    __weak IBOutlet UIWebView *webView_;
    
}

@end

@implementation ELBecomeExpertHelpCtl

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.navigationItem.title = @"申请帮助";
    [self setNavTitle:@"申请帮助"];

    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://m.yl1001.com/common/applyhelp"]];
    
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
