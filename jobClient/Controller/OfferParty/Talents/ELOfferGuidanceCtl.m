//
//  ELOfferGuidanceCtl.m
//  jobClient
//
//  Created by YL1001 on 16/4/26.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELOfferGuidanceCtl.h"
#import "RootTabBarViewController.h"

@interface ELOfferGuidanceCtl ()<UIGestureRecognizerDelegate>
{
    __weak IBOutlet UIView *_maskView;
    __weak IBOutlet UIImageView *_tipImg;
}
@end

@implementation ELOfferGuidanceCtl

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView:)];
    singleTap.delegate = self;
    [_tipImg addGestureRecognizer:singleTap];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)showViewCtl
{
    RootTabBarViewController *rootVc = [Manager shareMgr].tabVC;
    if (rootVc) {
        UINavigationController *selectedVC = rootVc.selectedViewController;
        UIViewController *visiVC = selectedVC.visibleViewController;
        if ([visiVC isKindOfClass:[TodayFocusListCtl class]]) {
            [[[UIApplication sharedApplication] keyWindow] addSubview:self.view];
            [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:self.view];
        }
    }
    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    [userdefault setBool:YES forKey:@"showOfferListTip"];
    [userdefault synchronize];
}

- (void)hideView:(UITapGestureRecognizer *)recognizer
{
    [self.view removeFromSuperview];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
