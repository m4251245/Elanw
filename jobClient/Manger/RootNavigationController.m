    //
//  RootNavigationController.m
//  jobClient
//
//  Created by 一览ios on 16/7/15.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "RootNavigationController.h"
#import "MyResumeController.h"
@interface RootNavigationController ()

@end

@implementation RootNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

-(void)configUI{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"icon_nav_bar_f05f5f.png"] forBarMetrics:UIBarMetricsDefault];
    [UINavigationBar appearance].shadowImage = [[UIImage alloc]init];
    self.navigationBar.translucent = NO;//    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationBar.barTintColor = UIColorFromRGB(0xe13e3e);
    
    //设置导航条字体
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    NSMutableDictionary *titleDict = [NSMutableDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [titleDict setObject:[UIFont fontWithName:@"STHeitiSC-Light" size:18] forKey:NSFontAttributeName];
    [titleDict setObject:shadow forKey:NSShadowAttributeName];
    // forKey:UITextAttributeTextShadowColor];UITextAttributeTextShadowColor 7.0之前
    [[UINavigationBar appearance] setTitleTextAttributes:titleDict];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
