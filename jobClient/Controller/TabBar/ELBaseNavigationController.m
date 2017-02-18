//
//  ELBaseNavigationController.m
//  jobClient
//
//  Created by 一览ios on 16/5/12.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELBaseNavigationController.h"
#import "BaseUIViewController.h"

@interface ELBaseNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>
{
    UIViewController *recordVC;
    Manager *manager;
}

@end

@implementation ELBaseNavigationController

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //    self.navigationBarHidden = YES;
//    self.interactivePopGestureRecognizer.delegate = self;
//    self.interactivePopGestureRecognizer.enabled = YES;
//        self.delegate = self;
}

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    
//    return YES;
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
////    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
////        return YES;
////    }
////    return NO;
//    return YES;
//}

//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    [super pushViewController:viewController animated:animated];
//    self.interactivePopGestureRecognizer.enabled = NO;
//}
//
//- (UIViewController *)popViewControllerAnimated:(BOOL)animated
//{
//    
//    return [super popViewControllerAnimated:animated];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
