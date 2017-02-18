//
//  ViewController.m
//  WechatPayDemo
//
//  Created by Alvin on 3/22/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "WeiXinPayCtl.h"
#import "Constant.h"
#import "MBProgressHUD.h"
#import "WXPayClient.h"

#import "APViewController.h"
#import "ServiceInfo.h"

NSString * const HUDDismissNotification = @"HUDDismissNotification";

@interface WeiXinPayCtl ()

@end

@implementation WeiXinPayCtl

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideHUD) name:HUDDismissNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideHUD
{
    //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [BaseUIViewController showLoadView:NO content:nil view:nil];
}

#pragma mark - Action

- (IBAction)pay:(id)sender
{
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BaseUIViewController showLoadView:YES content:nil view:nil];
    [[WXPayClient shareInstance] payProduct];
}

- (IBAction)alipay:(id)sender {
    APViewController *c = [[APViewController alloc]init];
    [self.navigationController pushViewController:c animated:YES];
}

- (IBAction)serviceInfor:(id)sender {
    ServiceInfo *c = [[ServiceInfo alloc]init];
    [self.navigationController pushViewController:c animated:YES];
}
@end
