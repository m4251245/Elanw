//
//  ELBaseUIViewController.m
//  jobClient
//
//  Created by 一览ios on 15/8/22.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELBaseUIViewController.h"

@interface ELBaseUIViewController ()<UIGestureRecognizerDelegate>
{
    NoNetworkVIew *_noNetworkView;
    UIButton *leftBtn;
}
@end

@implementation ELBaseUIViewController
- (void)dealloc
{
    NSLog(@"释放-%@",self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"进入页面-%@",self);
//    self.tabBarController.tabBar.hidden = YES;  
    //left返回键
    [self.navigationController setNavigationBarHidden:NO];
    leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 0, 30,30)];
    [leftBtn setBackgroundColor:[UIColor clearColor]];
    [leftBtn addTarget:self action:@selector(leftBarButtonItemClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setImage:[UIImage imageNamed:@"back_white_new"] forState:UIControlStateNormal];
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIBarButtonItem *backNavigationItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    if(([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0?20:0)){
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -10;
        self.navigationItem.leftBarButtonItems = @[negativeSpacer, backNavigationItem];
    }else{
        self.navigationItem.leftBarButtonItem = backNavigationItem;
    }
    //背景颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"icon_nav_bar_f05f5f.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor purpleColor];
    
    [self isNoNetwork];
    [MyLog Log:@"updateCom happen error!!!" obj:self];
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

-(void)setHideBackButton:(BOOL)hideBackButton{
    if (hideBackButton) {
        leftBtn.hidden = YES;
    }else{
        leftBtn.hidden = NO;
    }
}


- (void)leftBarButtonItemClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

char *alertKey;
-(UIAlertView *) showChooseAlertViewWithTag:(NSInteger)tag alertName:(NSString *)name title:(NSString *)title msg:(NSString *)msg okBtnTitle:(NSString *)okBtnTitle cancelBtnTitle:(NSString *)cancelBtnTitle
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:okBtnTitle,cancelBtnTitle,nil];
    alert.tag = tag;
    objc_setAssociatedObject(alert, &alertKey, name, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [alert show];
    return alert;
}

#pragma mark alertView delegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [MyLog Log:[NSString stringWithFormat:@"Alert View Choosed Cancel. Type=>%ld",(long)alertView.tag] obj:self];
    
    //不起做用
    if( alertView.tag < 0 )
    {
        [MyLog Log:@"Alert View Choosed , But is null, please check it" obj:self];
    }else
    {
        if( buttonIndex == 0 ){
            [self alertViewChoosed:alertView tag:alertView.tag alertName:objc_getAssociatedObject(alertView, &alertKey)];
        }else
            [self alertViewCancel:alertView tag:alertView.tag alertName:objc_getAssociatedObject(alertView, &alertKey)];
    }
}

//alert view choosed
-(void) alertViewChoosed:(UIAlertView *)alertView tag:(NSInteger)tag alertName:(NSString *)alertName
{
    
}

//alert view choosed cancel
-(void) alertViewCancel:(UIAlertView *)alertView tag:(NSInteger)tag alertName:(NSString *)alertName
{
    
}

- (void)isNoNetwork
{
    if (![AFNetworkReachabilityManager sharedManager].isReachable  && [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus != AFNetworkReachabilityStatusUnknown)
    {
        [self showNoNetworkView:YES];
    }
    else
    {
        [self showNoNetworkView:NO];
    }
}

//无网络情况下的视图
- (UIView *)getNoNetworkView
{
    if (!_noNetworkView) {
        _noNetworkView = [[NoNetworkVIew alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
    }
    return _noNetworkView;
}

- (UIView *)getSuperView
{
    return self.view;
}

- (void)showNoNetworkView:(BOOL)flag
{
    if (flag) {
        UIView *superView = [self getSuperView];
        UIView *myView = [self getNoNetworkView];
        
        if( superView && myView ){
            [myView removeFromSuperview];
            [superView addSubview:myView];
            
            //set the rect
            CGRect rect = myView.frame;
            rect.origin.x = 0;
            rect.origin.y = (int)((superView.frame.size.height - rect.size.height)/2.0);
            [myView setFrame:rect];
        }
    }
    else
    {
        [[self getNoNetworkView] removeFromSuperview];
    }
}
























@end
