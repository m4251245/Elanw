//
//  SalaryNavView.m
//  jobClient
//
//  Created by 一览ios on 15/4/24.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//  薪水导航

#import "SalaryNavView.h"
#import "SalaryButton.h"
#import "SalaryListCtl.h"
#import "SalaryIrrigationCtl.h"
#import "NewsCtl.h"


#define kNavViewHeight 110
#define kNavPadding 20
#define kNavMarginTop   10
#define kNavPageBarH   25
#define kPageNavNum 4 //每页最多导航菜单个数
#define kItemWidth 40//每个导航菜单的宽度
#define kItemHeight kNavViewHeight - kNavMarginTop - kNavPageBarH

@implementation SalaryNavView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, kNavViewHeight - 7)];
        [scrollView setBackgroundColor:[UIColor whiteColor]];
        [scrollView setCanCancelContentTouches:NO];
        scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        scrollView.clipsToBounds = YES;
        scrollView.scrollEnabled = YES;
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        scrollView.tag = 1;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.frame = self.bounds;
        _scrollView = scrollView;
        [self addSubview:scrollView];
        
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.center = CGPointMake(self.frame.size.width/2, (kNavViewHeight-kNavPageBarH)*0.5); // 设置pageControl的位置
        pageControl.pageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_salary_graydot.png"]];
        pageControl.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_salary_reddot.png"]];
        
        [pageControl.layer setCornerRadius:8]; // 圆角层
        [pageControl setBackgroundColor:[UIColor whiteColor]];
        pageControl.userInteractionEnabled = NO;
        [self addSubview:pageControl];
        _pageControl = pageControl;
        
        UIImageView *sepatateView = [[UIImageView alloc]initWithFrame:CGRectMake(-10, kNavViewHeight -1, 340, 1)];
        sepatateView.image = [UIImage imageNamed:@"gg_home_line2.png"];
        [self addSubview:sepatateView];
    }
    return self;
}

- (void)setNavArray:(NSArray *)navArray
{
    _navArray = navArray;
    NSInteger pageCount = (_navArray.count -1)/kPageNavNum + 1;
    if(pageCount < 2){
        _pageControl.hidden = YES;
    }else{
        _pageControl.numberOfPages = pageCount;
        _pageControl.currentPage = 0;
        [_pageControl setBounds:CGRectMake(0, 0, 16*(pageCount-1)+16, kNavPageBarH)]; //页面控件上的圆点间距基本在16左右。
        _pageControl.center = CGPointMake(160, kNavViewHeight - kNavPageBarH+kNavPageBarH*0.5);
    }
    
    _scrollView.contentSize = CGSizeMake((320/kPageNavNum)*navArray.count, kNavViewHeight -7);
    for (int i=0; i<navArray.count; i++) {
        NSDictionary *dict = navArray[i];
        NSInteger navPadding;
        if (_navArray.count<4) {
            navPadding = (320 - _sameTradeNavArray.count*kItemWidth)/(_sameTradeNavArray.count*2);
        }else{
            navPadding = kNavPadding;
        }
        CGRect frame = CGRectMake(navPadding +(navPadding*2 +kItemWidth)*i, kNavMarginTop, kItemWidth, kItemHeight);
        SalaryButton *btn = [[SalaryButton alloc]initWithFrame:frame];
        btn.tag = i;
        btn.imageEdgeInsets = UIEdgeInsetsMake(-22, 0, 0, 0);
        [btn setTitle:dict[@"title"] forState:UIControlStateNormal];
        NSString *type = dict[@"type"];
        if ([type isEqualToString:@"bao"]) {
            [btn setImage:[UIImage imageNamed:@"icon_salary_bao.png"] forState:UIControlStateNormal];
        }else if ([type isEqualToString:@"bi"]) {
            [btn setImage:[UIImage imageNamed:@"icon_salary_bi.png"] forState:UIControlStateNormal];
        }else if ([type isEqualToString:@"guan"]) {
            [btn setImage:[UIImage imageNamed:@"icon_salary_guan.png"] forState:UIControlStateNormal];
        }else if ([type isEqualToString:@"shuo"]) {
            [btn setImage:[UIImage imageNamed:@"icon_salary_shuo.png"] forState:UIControlStateNormal];
        }else if ([type isEqualToString:@"kanqj"]) {
            [btn setImage:[UIImage imageNamed:@"icon_salary_kan.png"] forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(salaryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn];
    }
    
}

#pragma mark 薪水导航点击
- (void)salaryBtnClick:(UIButton *)sender
{
    NSInteger index = sender.tag;
    NSDictionary *navDict = _navArray[index];
    __block NSString *type = navDict[@"type"];
    if ([type isEqualToString:@"bao"]) {
        SalaryListCtl *salaryCompareCtl = [[SalaryListCtl alloc]init];
        [[self viewController].navigationController pushViewController:salaryCompareCtl animated:YES];
        [salaryCompareCtl beginLoad:nil exParam:nil];
    }else if ([type isEqualToString:@"bi"]) {
        if (_clickBlock) {
            _clickBlock(@"bi");
            return;
        }
    }else if ([type isEqualToString:@"kanqj"]) {
        if (_clickBlock) {
            _clickBlock(type);
            return;
        }
    }else if ([type isEqualToString:@"guan"]) {
        SalaryIrrigationCtl *salaryIrrigationCtl = [[SalaryIrrigationCtl alloc]init];
        [[self viewController].navigationController pushViewController:salaryIrrigationCtl animated:YES];
        [salaryIrrigationCtl beginLoad:nil exParam:nil];
    }else if ([type isEqualToString:@"shuo"]) {
        NewsCtl *newsCtl = [[NewsCtl alloc]init];
        [[self viewController].navigationController pushViewController:newsCtl animated:YES];
        [newsCtl beginLoad:nil exParam:nil];
    }
}

- (UIViewController *)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

#pragma mark 同行导航菜单
- (void)setSameTradeNavArray:(NSArray *)navArray
{
    _sameTradeNavArray = [NSArray arrayWithArray:navArray];
    NSInteger pageCount = (_sameTradeNavArray.count -1)/kPageNavNum + 1;
    if(pageCount < 2){
        _pageControl.hidden = YES;
    }else{
        _pageControl.numberOfPages = pageCount;
        _pageControl.currentPage = 0;
        [_pageControl setBounds:CGRectMake(0, 0, 16*(pageCount-1)+16, kNavPageBarH)]; //页面控件上的圆点间距基本在16左右。
        _pageControl.center = CGPointMake(160, kNavViewHeight - kNavPageBarH+kNavPageBarH*0.5);
    }
    
    _scrollView.contentSize = CGSizeMake((320/kPageNavNum)*navArray.count, kNavViewHeight -7);
    for (NSInteger i=0; i<navArray.count; i++) {
        NSInteger navPadding;
        if (_sameTradeNavArray.count<4) {
            navPadding = (320 - _sameTradeNavArray.count*kItemWidth)/(_sameTradeNavArray.count*2);
        }else{
            navPadding = kNavPadding;
        }
        CGRect frame = CGRectMake(navPadding +(navPadding*2 +kItemWidth)*i, kNavMarginTop, kItemWidth, kItemHeight);
        SalaryButton *btn = [[SalaryButton alloc]initWithFrame:frame];
        btn.tag = i;
        btn.imageEdgeInsets = UIEdgeInsetsMake(-22, 0, 0, 0);
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        NSString *type = navArray[i];
        if ([type isEqualToString:@"pengyq"]) {
            [btn setImage:[UIImage imageNamed:@"icon_trade_freinds.png"] forState:UIControlStateNormal];
            [btn setTitle:@"朋友圈" forState:UIControlStateNormal];
        }else if ([type isEqualToString:@"zhid"]) {
            [btn setImage:[UIImage imageNamed:@"icon_trade_jobguide.png"] forState:UIControlStateNormal];
            [btn setTitle:@"职导" forState:UIControlStateNormal];
        }else if ([type isEqualToString:@"zhaoth"]) {
            [btn setImage:[UIImage imageNamed:@"icon_trade_findTrade.png"] forState:UIControlStateNormal];
            [btn setTitle:@"找同行" forState:UIControlStateNormal];
        }

        [btn addTarget:self action:@selector(sameTradeNavBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn];
    }

}

#pragma mark 同行导航点击
- (void)sameTradeNavBtnClick:(UIButton *)sender
{
    NSInteger index = sender.tag;
    __block NSString *type = _sameTradeNavArray[index];
    if (_clickBlock) {
        _clickBlock(type);
        return;
    }
}

- (void)setFrame:(CGRect)frame
{
    frame.size.height = kNavViewHeight;
    frame.size.width = 320;
    [super setFrame:frame];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag == 1)
    {
        NSInteger index = ceil(fabs(scrollView.contentOffset.x) / scrollView.frame.size.width);
        [_pageControl setCurrentPage:index];
    }
}

@end
