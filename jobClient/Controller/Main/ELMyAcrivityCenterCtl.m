//
//  ELMyAcrivityCenterCtl.m
//  jobClient
//
//  Created by 一览iOS on 15/9/16.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELMyAcrivityCenterCtl.h"
#import "ELActivityListCtl.h"

@interface ELMyAcrivityCenterCtl () <UIScrollViewDelegate>
{
    __weak IBOutlet UIButton *rightBtn;
    __weak IBOutlet UIButton *leftBtn;
    __weak IBOutlet UIScrollView *scrollView_;
    IBOutlet UIView *titleView;
    
    ELActivityListCtl *leftCtl;
    ELActivityListCtl *rightCtl;
}
@end

@implementation ELMyAcrivityCenterCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationItem.titleView = titleView;
    titleView.clipsToBounds = YES;
    titleView.layer.borderWidth = 1.0;
    titleView.layer.borderColor = [UIColor whiteColor].CGColor;
    titleView.layer.cornerRadius = 4.0;
    [self changeCtlBtnRespone:leftBtn];
    
    scrollView_.delegate = self;
    scrollView_.scrollEnabled = NO;
    [scrollView_ setContentSize:CGSizeMake(2*[UIScreen mainScreen].bounds.size.width,1)];
    
    leftCtl = [[ELActivityListCtl alloc] init];
    leftCtl.view.frame = CGRectMake(0,0,scrollView_.bounds.size.width,scrollView_.bounds.size.height);
    [scrollView_ addSubview:leftCtl.view];
    [self addChildViewController:leftCtl];
    [leftCtl beginLoad:nil exParam:nil];
    
    rightCtl = [[ELActivityListCtl alloc] init];
    rightCtl.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width,0,scrollView_.bounds.size.width,scrollView_.bounds.size.height);
    [scrollView_ addSubview:rightCtl.view];
    [self addChildViewController:rightCtl];
    [rightCtl beginLoad:nil exParam:nil];
    
    leftCtl.listType = 1;
    rightCtl.listType = 2;
    
    [[self getNoNetworkView] removeFromSuperview];
}


- (IBAction)changeCtlBtnRespone:(UIButton *)sender
{
    if (sender == leftBtn)
    {
        [rightBtn setBackgroundColor:[UIColor colorWithRed:225.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:1.0]];
        [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [leftBtn setBackgroundColor:[UIColor whiteColor]];
        [leftBtn setTitleColor:REDCOLOR forState:UIControlStateNormal];
        [scrollView_ setContentOffset:CGPointMake(0,0) animated:YES];
    }
    else if(sender == rightBtn)
    {
        [leftBtn setBackgroundColor:[UIColor colorWithRed:225.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:1.0]];
        [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [rightBtn setBackgroundColor:[UIColor whiteColor]];
        [rightBtn setTitleColor:REDCOLOR forState:UIControlStateNormal];
        [scrollView_ setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width,0) animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
