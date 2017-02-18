//
//  ELNewBaseViewController.h
//  jobClient
//
//  Created by 一览ios on 16/7/11.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELNewBaseViewController : UIViewController

/**
 *  设置leftBarBtton
 *  @param itemImg item图标
 */
-(void)leftButtonItem:(NSString *)itemImg;

/**
 *  leftBarBtton 点击
 *  @param button leftBarBtton
 */
-(void)leftBtnClick:(id)button;

/**
 *  设置backBarBtton
 *  @param itemImg item图标
 */
-(void)backButtonItem:(NSString *)itemImg;

/**
 *  backBarBtton 点击
 *  @param button leftBarBtton
 */
-(void)backBtnClick:(id)button;

/**
 *  设置rightButtonItem
 *  @param itemImg item图标
 */
-(void)rightButtonItem:(NSString *)itemImg;

/**
 *  设置rightButtonItem
 *
 *  @param itemTitle itemTitle 标题
 */
-(void)rightButtonItemWithTitle:(NSString *)itemTitle;

/**
 *  backBarBtton 点击
 *  @param button leftBarBtton
 */
-(void)rightBtnClick:(id)button;

- (void)setNavTitle:(NSString *)title;
@end
