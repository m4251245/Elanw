//
//  TabBarView.h
//  jobClient
//
//  Created by 一览ios on 16/7/15.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarButton : UIButton

@end

@protocol TabBarDelegate <NSObject>

/**
 *   点击的按钮
 *
 *  @param btn 
 */
-(void)buttonSelectedClick:(UIButton *)btn;

@end

@interface TabBarView : UIView

@property(nonatomic,assign)id<TabBarDelegate>delegate;

/**
 *  初始化
 *
 *  @param frame 大小
 *  @param num   控制器个数
 *
 *  @return
 */
-(instancetype)initWithFrame:(CGRect)frame controllersNum:(int)num;

/**
 *  数字角标
 *
 *  @param num   所要显示数字
 *  @param index 位置
 */
-(void)showBadgeMark:(NSInteger)badge index:(NSInteger)index;

/**
 *  红点
 *
 *  @param index 位置
 */
-(void)showPointMark:(NSInteger)mark Index:(NSInteger)index;

/**
 *  切换显示控制器
 *
 *  @param index 位置
 */
-(void)showControllerIndex:(NSInteger)index;

/**
 *  取消默认选中
 *
 *  @param idx 选中位置
 */
-(void)selectedBtnIdx:(BOOL)isLogin;

@end
