//
//  RootTabBarViewController.h
//  jobClient
//
//  Created by 一览ios on 16/7/14.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TabBarView;
@interface RootTabBarViewController : UITabBarController

@property (nonatomic,strong)TabBarView *tabBarView;
@property(nonatomic,strong)UIButton *seleBtn;
-(void)showControllerIndex:(NSInteger)index;

@end
