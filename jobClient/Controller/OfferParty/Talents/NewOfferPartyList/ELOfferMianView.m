//
//  ELOfferMianView.m
//  jobClient
//
//  Created by YL1001 on 16/10/27.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELOfferMianView.h"
#import "ELNewOfferListCtl.h"
#import "ELOfferPartyGroupsCtl.h"

static NSInteger kBtnTag = 50;
static NSInteger ksegmentViewHeight = 41;

@interface ELOfferMianView ()<UIScrollViewDelegate>
{
    BOOL _isExist;
}

@property (nonatomic, strong) UIView *segmentView;
@property (nonatomic, strong) UIImageView *redLine;      //小红条
@property (nonatomic, strong) NSArray *titleArr;    //顶部导航标题
@property (nonatomic, strong) NSArray *listCtlArr;  //列表
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, weak) UIButton *selectBtn;
@property (nonatomic, weak) UIViewController *parenController;

@end

@implementation ELOfferMianView

- (instancetype)initWithFrame:(CGRect)frame TitleArr:(NSArray *)titleArr Controllers:(NSArray *)controllers ParentController:(UIViewController *)parenController
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        if (!_isFromHome) {
            [self checkForOfferPartys];
        }
        
        self.backgroundColor = UIColorFromRGB(0xf0f0f0);
        float btnWidth = (ScreenWidth-20)/titleArr.count;
        
        self.titleArr = titleArr;
        self.listCtlArr = controllers;
        self.parenController = parenController;
        
        self.segmentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, ksegmentViewHeight)];
        self.segmentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.segmentView];
        
        self.redLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_offer_redLine.png"]];
        self.redLine.frame = CGRectMake(10, ksegmentViewHeight - 2, btnWidth, 2);
        [self.segmentView addSubview:self.redLine];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ksegmentViewHeight, self.frame.size.width, self.frame.size.height - ksegmentViewHeight)];
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.contentSize = CGSizeMake(ScreenWidth*controllers.count, self.frame.size.height - ksegmentViewHeight);
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.delegate = self;
        self.scrollView.bounces = NO;
        self.scrollView.directionalLockEnabled = YES;
        [self addSubview:self.scrollView];
        
        [self addChildViewController:controllers];
        
        for (NSInteger i = 0; i < titleArr.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(10+i*btnWidth, 0, btnWidth, ksegmentViewHeight);
            btn.tag = i + kBtnTag;
            btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
            [btn setTitle:[titleArr objectAtIndex:i] forState:UIControlStateNormal];
            [btn setTitleColor:UIColorFromRGB(0x616161) forState:UIControlStateNormal];
            [btn setTitleColor:UIColorFromRGB(0xe13e3e) forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.segmentView addSubview:btn];
            
            if (i == 0) {
                [self btnClick:btn];
            }
        }
        
    }
    
    return self;
}

//检测是否存在用户参加且正在举行的offer派
- (void)checkForOfferPartys
{
    if ([Manager shareMgr].haveLogin) {
        NSString *op = @"jobfair_person_busi";
        NSString *function = @"getJobfairByPersonid";
        
        NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@", [Manager getUserInfo].userId_];
        
        [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
            
            NSDictionary *dict = result;
            BOOL ishold = [dict[@"ishold"] boolValue];
            NSString *jobfairId = dict[@"jobfair_id"];
            if (ishold && ![jobfairId isEqualToString:@""]) {
                UIButton *btn = (UIButton *)[self.segmentView viewWithTag:(2 + kBtnTag)];
                [self btnClick:btn];
            }
         
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            
        }];
    }
}

#pragma mark - 添加子控制器
- (void)addChildViewController:(NSArray *)controllers
{
    for (NSInteger i = 0; i < controllers.count; i++) {
        UIViewController * childVC = controllers[i];
        childVC.view.frame = CGRectMake(i*ScreenWidth, 0, self.frame.size.width, _scrollView.frame.size.height);
        [self.scrollView addSubview:childVC.view];
        [_parenController addChildViewController:childVC];
        [childVC didMoveToParentViewController:_parenController];
    }
}

// 按钮点击
- (void)btnClick:(UIButton *)sender
{
    self.selectBtn.selected = NO;
    self.selectBtn = sender;
    self.selectBtn.selected = YES;
    
    NSInteger index = sender.tag - kBtnTag;
    [self setUpOneChildViewController:index];
    [self.scrollView setContentOffset:CGPointMake(index*ScreenWidth, 0) animated:YES];
    [self changeRedLineFrame:sender.frame];
   
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectVC" object:sender userInfo:nil];
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)setUpOneChildViewController:(NSUInteger)i
{
    UIViewController *vc = _parenController.childViewControllers[i];
    
    if (i < 3) {
        ELNewOfferListCtl *offerlistCtl = (ELNewOfferListCtl *)vc;
        offerlistCtl.selectTableTag = i;
        if (!offerlistCtl.isCanLoad) {
            [offerlistCtl beginLoad:nil exParam:nil];
        }
    }
    else if (i == 3)
    {
        ELOfferPartyGroupsCtl *GroupsCtl = (ELOfferPartyGroupsCtl *)vc;
        if (!GroupsCtl.isCanLoad) {
            [GroupsCtl beginLoad:nil exParam:nil];
        }
    }
    
    if (vc.view.superview) {
        return;
    }
    
    vc.view.frame = CGRectMake(i*ScreenWidth, 0, self.frame.size.width, _scrollView.frame.size.height);
    [self.scrollView addSubview:vc.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    UIButton *btn = (UIButton *)[self.segmentView viewWithTag:((self.scrollView.contentOffset.x/ScreenWidth) + kBtnTag)];
    [self btnClick:btn];
}

- (void)changeRedLineFrame:(CGRect)btnFrame
{
    CGRect frame = self.redLine.frame;
    frame.origin.x = btnFrame.origin.x;
    self.redLine.frame = frame;
}

@end
