//
//  MyAttentionCenterCtl.m
//  jobClient
//
//  Created by 一览ios on 15/4/23.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "MyAttentionCenterCtl.h"
#import "AttendtionOrganizationCtl.h"

@interface MyAttentionCenterCtl ()
{
    MyAudienceListCtl *myAudienceList;
    AttendtionOrganizationCtl *companyListCtl;
    AttendtionOrganizationCtl *schoolListCtl;
}
@end

@implementation MyAttentionCenterCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    self.navigationItem.title = @"我的关注";
    [self setNavTitle:@"我的关注"];
    _leftCountLb.layer.cornerRadius = 7.0;
    _leftCountLb.layer.masksToBounds = YES;
    _rightCountLb.layer.cornerRadius = 7.0;
    _rightCountLb.layer.masksToBounds = YES;
    _midCountLb.layer.cornerRadius = 7.0;
    _midCountLb.layer.masksToBounds = YES;
//    CGRect frame = _contentScrollView.frame;
//    frame.size.width = ScreenWidth;
//    _contentScrollView.frame = frame;
//    [_contentScrollView setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width *3, 0)];
//    [_contentScrollView addSubview:myAudienceList.view];
//    [_contentScrollView addSubview:companyListCtl.view];
//    [_contentScrollView addSubview:schoolListCtl.view];
//    [myAudienceList.view setFrame:_contentScrollView.bounds];
//    [companyListCtl.view setFrame:_contentScrollView.bounds];
//    [schoolListCtl.view setFrame:_contentScrollView.bounds];
//    CGRect rect = companyListCtl.view.frame;
//    rect.origin.x = _contentScrollView.bounds.size.width;
//    [companyListCtl.view setFrame:rect];
//    rect = schoolListCtl.view.frame;
//    rect.origin.x = _contentScrollView.bounds.size.width*2;
//    [schoolListCtl.view setFrame:rect];
    
    myAudienceList.view.frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44);
    [self.view addSubview:myAudienceList.view];
    [self addChildViewController:myAudienceList];
    companyListCtl.view.frame = myAudienceList.view.frame;
    [self.view addSubview:companyListCtl.view];
    [self addChildViewController:companyListCtl];
    schoolListCtl.view.frame = myAudienceList.view.frame;
    [self.view addSubview:schoolListCtl.view];
    [self addChildViewController:schoolListCtl];
    companyListCtl.view.hidden = YES;
    schoolListCtl.view.hidden = YES;
    
    // Do any additional setup after loading the view from its nib.
    
    CGRect rect1 = _redLineImagev.frame;
    rect1.origin.x = 0;
    rect1.size.width = ScreenWidth/3;
    [_redLineImagev setFrame:rect1];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setFd_prefersNavigationBarHidden:NO];
//    self.navigationItem.title = @"我的关注";
}

-(void)viewDidDisappear:(BOOL)animated{
//    self.navigationItem.title = @"";
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    if (!myAudienceList) {
        myAudienceList = [[MyAudienceListCtl alloc] init];
    }
    [myAudienceList beginLoad:@"1" exParam:nil];
    if (!companyListCtl) {
        companyListCtl = [[AttendtionOrganizationCtl alloc] init];
        companyListCtl.type_ = Organization_Company;
    }
    [companyListCtl beginLoad:nil exParam:nil];
    if (!schoolListCtl) {
        schoolListCtl = [[AttendtionOrganizationCtl alloc] init];
        schoolListCtl.type_ = Organization_School;
    }
    [schoolListCtl beginLoad:nil exParam:nil];
}


- (IBAction)leftBtnClick:(id)sender {
    [self changBtnStauts:sender];
}

- (IBAction)midBtnClick:(id)sender {
    [self changBtnStauts:sender];
}

- (IBAction)rightBtnClick:(id)sender {
    [self changBtnStauts:sender];
}

#pragma mark - 刷新小红点
- (void)freshRedCountStatus
{
//    _leftCountLb
//    _midCountLb
//    _rightCountLb
}

- (void)changBtnStauts:(id)sender
{
    UIButton *button = sender;
    myAudienceList.view.hidden = YES;
    companyListCtl.view.hidden = YES;
    schoolListCtl.view.hidden = YES;
    if (button == _leftBtn) {
        [_leftBtn setTitleColor:[UIColor colorWithRed:216.0/255.0 green:49.0/255.0 blue:39.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_rightBtn setTitleColor:LIGHTGRAYCOLOR forState:UIControlStateNormal];
        [_midBtn setTitleColor:LIGHTGRAYCOLOR forState:UIControlStateNormal];
        CGRect rect = _redLineImagev.frame;
        rect.origin.x = 0;
        rect.size.width = ScreenWidth/3;
        [_redLineImagev setFrame:rect];
//        [_contentScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        myAudienceList.view.hidden = NO;
    }else if (button == _rightBtn) {
        [_rightBtn setTitleColor:[UIColor colorWithRed:216.0/255.0 green:49.0/255.0 blue:39.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_leftBtn setTitleColor:LIGHTGRAYCOLOR forState:UIControlStateNormal];
        [_midBtn setTitleColor:LIGHTGRAYCOLOR forState:UIControlStateNormal];
        CGRect rect = _redLineImagev.frame;
        rect.origin.x = rect.size.width*2;
        [_redLineImagev setFrame:rect];
//        [_contentScrollView setContentOffset:CGPointMake(_contentScrollView.frame.size.width*2, 0) animated:NO];
        schoolListCtl.view.hidden = NO;
    }else if (button == _midBtn) {
        [_midBtn setTitleColor:[UIColor colorWithRed:216.0/255.0 green:49.0/255.0 blue:39.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_leftBtn setTitleColor:LIGHTGRAYCOLOR forState:UIControlStateNormal];
        [_rightBtn setTitleColor:LIGHTGRAYCOLOR forState:UIControlStateNormal];
        CGRect rect = _redLineImagev.frame;
        rect.origin.x = rect.size.width;
        [_redLineImagev setFrame:rect];
//        [_contentScrollView setContentOffset:CGPointMake(_contentScrollView.frame.size.width, 0) animated:NO];
        companyListCtl.view.hidden = NO;
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
