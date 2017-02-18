//
//  SalaryNavView.h
//  jobClient
//
//  Created by 一览ios on 15/4/24.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SalaryNavView : UIView<UIScrollViewDelegate>

@property (strong, nonatomic) NSArray *navArray;

@property (strong, nonatomic) NSArray *sameTradeNavArray;//同行导航

@property (weak, nonatomic) UIPageControl *pageControl;

@property (weak, nonatomic) UIScrollView *scrollView;

@property(nonatomic, copy) void (^clickBlock)(NSString *type );

@end
