//
//  ELRootViewController.m
//  jobClient
//
//  Created by 一览ios on 16/5/3.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELRootViewController.h"
#import "TodayFocusListCtl.h"
#import "ELBaseNavigationController.h"
#import "ELMyGroupCenterCtl.h"
#import "MyManagermentCenterCtl.h"

@interface ELRootViewController ()<TabViewDelegate,UIGestureRecognizerDelegate>
{
    Manager *manager;
//    ELBaseNavigationController *baseNav;
}
@end

@implementation ELRootViewController

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        [self.navigationItem setHidesBackButton:YES animated:NO];
    }
    return  self;
}


- (void)setNavigationControl:(UIViewController *)Ctl

{
//    [self popToRootViewControllerAnimated:NO];
    [self pushViewController:Ctl animated:NO];
    
    return;
    
    for (ELBaseNavigationController *nav in self.childViewControllers) {
        [nav removeFromParentViewController];
    }
     Ctl.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    ELBaseNavigationController *baseNav = [[ELBaseNavigationController alloc] initWithRootViewController:Ctl];
    if (!manager) {
        manager = [Manager shareMgr];
    }
//    manager = [Manager shareMgr];
    manager.centerNav_ = baseNav;
//    baseNav.navigationBarHidden = NO;
    [self addChildViewController:baseNav];
    
    [self.view addSubview:baseNav.view];
    //[Manager setNavAtt:nil image:nil color:nil];
    
    if(!manager.tabView_ ){
        manager.tabView_ = [[[NSBundle mainBundle] loadNibNamed:@"TabView" owner:self options:nil] lastObject];
        manager.tabView_.delegate_ = self;
        
         [manager.tabView_ addGesture];
    }
   
    CGRect rect = manager.tabView_.frame;
    rect.origin.y = [UIScreen mainScreen].bounds.size.height - rect.size.height;
    rect.size.width = ScreenWidth;
    [manager.tabView_ setFrame:rect];
    if ([Ctl isKindOfClass:NSClassFromString(@"MyManagermentCenterCtl")]) {
        rect.origin.y -= 20;
        [manager.tabView_ setFrame:rect];
    }
    
    CGFloat width = (ScreenWidth - 320)/5;
    manager.tabView_.widthOne.constant = width;
    manager.tabView_.widthTwo.constant = width;
    manager.tabView_.widthThree.constant = width;
    manager.tabView_.widthFour.constant = width;
    [Ctl.view addSubview:manager.tabView_];
    [Ctl.view bringSubviewToFront:manager.tabView_];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  
}

- (void) setTabType:(TabType)tabType
{
    [manager.tabView_ changeModel:tabType];
    [self tabViewModalChanged:manager.tabView_ type:tabType];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if(!manager)
    {
        manager = [Manager shareMgr];
    }
    if(!manager.tabView_ ){
        manager.tabView_ = [[[NSBundle mainBundle] loadNibNamed:@"TabView" owner:self options:nil] lastObject];
        manager.tabView_.delegate_ = self;
        
        [manager.tabView_ addGesture];
    }
    
    CGRect rect = manager.tabView_.frame;
    rect.origin.y = [UIScreen mainScreen].bounds.size.height - rect.size.height;
    rect.size.width = ScreenWidth;
    [manager.tabView_ setFrame:rect];
//    if ([Ctl isKindOfClass:NSClassFromString(@"MyManagermentCenterCtl")]) {
//        rect.origin.y -= 20;
//        [manager.tabView_ setFrame:rect];
//    }
    
    CGFloat width = (ScreenWidth - 320)/5;
    manager.tabView_.widthOne.constant = width;
    manager.tabView_.widthTwo.constant = width;
    manager.tabView_.widthThree.constant = width;
    manager.tabView_.widthFour.constant = width;
    [self.view addSubview:manager.tabView_];
    [self.view bringSubviewToFront:manager.tabView_];


//    if (!manager) {
//         manager = [Manager shareMgr];
//    }
//   
//    if (!manager.todayFocusListCtl) {
//        manager.todayFocusListCtl = [[TodayFocusListCtl alloc] init];
//    }
//    manager.todayFocusListCtl.navigationController.navigationBarHidden = NO;
//    [self pushViewController:manager.todayFocusListCtl animated:YES];
////    [self setNavigationControl:manager.todayFocusListCtl];
//    [manager.todayFocusListCtl beginLoad:nil exParam:nil];
//    [manager.tabView_ changeModel:Tab_First];
    [self tabViewModalChanged:manager.tabView_ type:Tab_First];
}

#pragma TabViewDelegate
-(void) tabViewModalChanged:(TabView *)tab type:(TabType)type
{
    if (type == Tab_Fifth) {
        if (![Manager shareMgr].haveLogin) {
            [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
            [Manager shareMgr].loginActionIndex = LoginFollow_MessageCenter;
            return;
        }
        manager.messageCenterListCtl.isThisCtl = YES;
    }else{
        manager.messageCenterListCtl.isThisCtl = NO;
    }
    
    [tab changeModel:type];
    switch ( type ) {
        case Tab_First:
        {
           
            if (!manager.todayFocusListCtl) {
                manager.todayFocusListCtl = [[TodayFocusListCtl alloc] init];
               // [manager.todayFocusListCtl beginLoad:nil exParam:nil];
                manager.tabType_ = 0;
                manager.registeType_ = FromZTDH;
            }else{
              
            }
            //[self popToRootViewControllerAnimated:NO];
            
            manager.todayFocusListCtl.navigationController.navigationBarHidden = NO;
            [self setNavigationControl:manager.todayFocusListCtl];
          
          
        }
            break;
        case Tab_Second:
        {
        //            [manager.centerNav_ popToRootViewControllerAnimated:YES];
          
            if (!manager.myGroupCtl_) {
                manager.myGroupCtl_ = [[ELMyGroupCenterCtl alloc] init];
                [manager.myGroupCtl_ beginLoad:nil exParam:nil];
                manager.registeType_ = FromSQ;
                manager.tabType_ = 1;

            }
            [self setNavigationControl:manager.myGroupCtl_];
            manager.myGroupCtl_.navigationController.navigationBarHidden = NO;
          
        }
            break;
        case Tab_Third:
        {
           
//            [manager.centerNav_ popToRootViewControllerAnimated:NO];
            
            if (!manager.myCenterCtl) {
                manager.myCenterCtl = [[MyManagermentCenterCtl alloc] init];
                 [Manager shareMgr].registeType_ = FromXZ;
                [manager.myCenterCtl beginLoad:nil exParam:nil];
                manager.tabType_ = 2;
            }
            [self setNavigationControl:manager.myCenterCtl];
            manager.myCenterCtl.navigationController.navigationBarHidden = YES;
           
        }
            break;
        case Tab_Fourth:
        {
           
            if (!manager.findJobCtl_) {
                manager.findJobCtl_ = [[MyJobSearchCtl alloc] init];
                [manager.findJobCtl_ beginLoad:nil exParam:nil];
                manager.registeType_ = FromQZ;
                manager.tabType_ = 3;
            }
            [self setNavigationControl:manager.findJobCtl_];
            manager.findJobCtl_.navigationController.navigationBarHidden  = NO;
        }
            break;
        case Tab_Fifth:
        {
            if (!manager.messageCenterListCtl) {
                manager.messageCenterListCtl = [[MessageCenterList alloc] init];
            }
            [self setNavigationControl:manager.messageCenterListCtl];
            manager.tabType_ = 4;
        }
            break;
        default:
            break;
    }
    
    [self.view bringSubviewToFront:manager.tabView_];
}


-(void)loginDelegateCtl
{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}

#pragma mark - tabview double click
- (void)scrollViewToTop
{
//    [manager.todayFocusListCtl statusBarTouchedAction];
    if (!manager.todayFocusListCtl) {
        manager.todayFocusListCtl = [[TodayFocusListCtl alloc] init];
    }
    NSLog(@"------- %@ %@",manager.todayFocusListCtl,self.childViewControllers);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"statusBarTouchedAction" object:nil];
}

- (void)findJobScrollViewToTop
{
//    [manager.findJobCtl_ statusBarTouchedAction];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"statusBarTouchedAction" object:nil];
}

- (void)myGroupScrollViewToTop
{
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
