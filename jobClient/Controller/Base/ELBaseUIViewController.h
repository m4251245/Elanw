//
//  ELBaseUIViewController.h
//  jobClient
//
//  Created by 一览ios on 15/8/22.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELPersonCenterCtl.h"
#import "objc/runtime.h"
#import "NSString+Size.h"


@interface ELBaseUIViewController : AMScrollingNavbarViewController

/**
 *  设置导航栏标题
 *
 *  @param title
 */
- (void)setNavTitle:(NSString *)title;

#pragma mark alertName区分alert
-(UIAlertView *) showChooseAlertViewWithTag:(NSInteger)tag alertName:(NSString *)name title:(NSString *)title msg:(NSString *)msg okBtnTitle:(NSString *)okBtnTitle cancelBtnTitle:(NSString *)cancelBtnTitle;

#pragma mark alertName区分alert
-(void) alertViewChoosed:(UIAlertView *)alertView tag:(NSInteger)tag alertName:(NSString *)alertName;

-(void) alertViewCancel:(UIAlertView *)alertView tag:(NSInteger)tag alertName:(NSString *)alertName;

#pragma mark 无网络视图
- (void)isNoNetwork;
- (void)showNoNetworkView:(BOOL)flag;
- (UIView *)getNoNetworkView;
- (UIView *)getSuperView;

- (void)leftBarButtonItemClick:(UIButton *)btn;

@property (nonatomic,assign) BOOL hideBackButton;

@end

