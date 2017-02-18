//
//  IndexNavView.m
//  jobClient
//
//  Created by 一览ios on 15/7/31.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "IndexNavView.h"
#import "SalaryButton.h"
#import "MyConfig.h"

#define kNavViewHeight 100
#define kNavPadding 20
#define kNavMarginTop   14
#define kPageNavNum 4 //每页最多导航菜单个数
#define kItemWidth 60//每个导航菜单的宽度
#define kItemHeight 65
#define UIScreenWidth [UIScreen mainScreen].bounds.size.width

@implementation IndexNavView
{
    UIButton *friendBtn;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        [scrollView setBackgroundColor:[UIColor whiteColor]];
        [scrollView setCanCancelContentTouches:NO];
        scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        scrollView.clipsToBounds = YES;
        scrollView.scrollEnabled = YES;
        scrollView.pagingEnabled = YES;
        scrollView.tag = 1;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.frame = self.bounds;
        _scrollView = scrollView;
        [self addSubview:scrollView];
        self.backgroundColor = [UIColor colorWithRed:240.f/255 green:240.f/255 blue:240.f/255 alpha:1.f];
    }
    return self;
}

#pragma mark 首页最新导航
- (void)setIndexNavArray:(NSArray *)indexNavArray
{
    _indexNavArray = [NSArray arrayWithArray:indexNavArray];

    long rowNum = (_indexNavArray.count -1)/4 +1;
    _scrollView.frame = CGRectMake(0, 0, UIScreenWidth, rowNum * kItemHeight + (rowNum+1)*kNavMarginTop);
    self.bounds = CGRectMake(0, 0, UIScreenWidth, rowNum * kItemHeight + (rowNum+1)*kNavMarginTop +5);
    CGFloat floatX = (UIScreenWidth-kItemWidth*kPageNavNum)/4;
    for (NSInteger i=0; i<_indexNavArray.count; i++) {
        int column = i%4;
        long row = i/4;
        NSInteger navPadding;
        if (_indexNavArray.count<4) {
            navPadding = (UIScreenWidth - _indexNavArray.count*kItemWidth)/(_indexNavArray.count*2);
        }else{
            navPadding = kNavPadding;
        }
        //CGRect frame = CGRectMake(navPadding +(navPadding*2 +kItemWidth)*column, kNavMarginTop +(kNavMarginTop +kItemHeight)*row, kItemWidth, kItemHeight);
        CGRect frame = CGRectMake(floatX/2+(floatX+kItemWidth)*column, kNavMarginTop +(kNavMarginTop +kItemHeight)*row, kItemWidth, kItemHeight);
        SalaryButton *btn = [[SalaryButton alloc]initWithFrame:frame];
        [btn setTitleColor:[UIColor colorWithRed:102.f/255 green:102.f/255 blue:102.f/255 alpha:1.f] forState:UIControlStateNormal];
        btn.titleLabel.font = FIFTEENFONT_TITLE;
        btn.tag = i;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        NSString *type = _indexNavArray[i];
        if ([type isEqualToString:@"pengyq"])
        {
            [btn setImage:[UIImage imageNamed:@"icon_trade_freinds.png"] forState:UIControlStateNormal];
            [btn setTitle:@"朋友圈" forState:UIControlStateNormal];
            friendBtn = btn;
        }else if ([type isEqualToString:@"zhid"]) {
            [btn setImage:[UIImage imageNamed:@"icon_trade_jobguide.png"] forState:UIControlStateNormal];
            [btn setTitle:@"业问" forState:UIControlStateNormal];
        }else if ([type isEqualToString:@"zhaoth"]) {
            [btn setImage:[UIImage imageNamed:@"icon_trade_findTrade.png"] forState:UIControlStateNormal];
            [btn setTitle:@"找同行" forState:UIControlStateNormal];
        }else if ([type isEqualToString:@"chagz"]) {
            [btn setImage:[UIImage imageNamed:@"icon_salary_bao.png"] forState:UIControlStateNormal];
            [btn setTitle:@"查工资" forState:UIControlStateNormal];
        }else if ([type isEqualToString:@"guanxs"]) {
            [btn setImage:[UIImage imageNamed:@"icon_salary_guan.png"] forState:UIControlStateNormal];
            [btn setTitle:@"灌薪水" forState:UIControlStateNormal];
        }else if ([type isEqualToString:@"bixz"]) {
            [btn setImage:[UIImage imageNamed:@"icon_salary_bi.png"] forState:UIControlStateNormal];
            [btn setTitle:@"比薪资" forState:UIControlStateNormal];
        }else if ([type isEqualToString:@"kanqj"]) {
            [btn setImage:[UIImage imageNamed:@"icon_salary_kan.png"] forState:UIControlStateNormal];
            [btn setTitle:@"看钱景" forState:UIControlStateNormal];
        }else if ([type isEqualToString:@"shuoxw"]) {
            [btn setImage:[UIImage imageNamed:@"icon_salary_shuo.png"] forState:UIControlStateNormal];
            [btn setTitle:@"说薪闻" forState:UIControlStateNormal];
        }else if ([type isEqualToString:@"zhaorc"]){
            [btn setImage:[UIImage imageNamed:@"icon_trade_searchman"] forState:UIControlStateNormal];
            [btn setTitle:@"找人才" forState:UIControlStateNormal];
        }else if ([type isEqualToString:@"group"]){
            [btn setImage:[UIImage imageNamed:@"icon_salary_shequn"] forState:UIControlStateNormal];
            [btn setTitle:@"社群" forState:UIControlStateNormal];
        }else if ([type isEqualToString:@"offer"]){
            [btn setImage:[UIImage imageNamed:@"today_offer_image"] forState:UIControlStateNormal];
            [btn setTitle:@"offer派" forState:UIControlStateNormal];
        }else if ([type isEqualToString:@"shyg"]){
            [btn setImage:[UIImage imageNamed:@"today_sanhaoyigai"] forState:UIControlStateNormal];
            [btn setTitle:@"三好一改" forState:UIControlStateNormal];
        }
        
        [btn addTarget:self action:@selector(indexNavBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn];
    }
    
}

#pragma mark 首页导航点击
- (void)indexNavBtnClick:(UIButton *)sender
{
    NSInteger index = sender.tag;
    __block NSString *type = _indexNavArray[index];
    if (_clickBlock) {
        _clickBlock(type);
        return;
    }
}

-(void)reloadFriendMessageCountLb:(NSInteger)count withFriendCount:(NSInteger)friendCount
{
    if (!friendBtn) {
        return;
    }
    if (count > 0)
    {
        if (!_countLb) {
            _countLb = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(friendBtn.frame)-7,CGRectGetMinY(friendBtn.frame)-3,14,14)];
            _countLb.layer.cornerRadius = 7.0;
            _countLb.textColor = [UIColor whiteColor];
            _countLb.backgroundColor = FONEREDCOLOR;
            _countLb.textAlignment = NSTextAlignmentCenter;
            _countLb.font = [UIFont fontWithName:@"STHeitiSC-Light" size:10];
            _countLb.layer.masksToBounds = YES;
            _countLb.numberOfLines = 1;
            [_scrollView addSubview:_countLb];
        }
        _countLb.hidden = NO;
        if (friendCount > 0) {
            [_countLb setText:[NSString stringWithFormat:@"%ld",(long)friendCount]];
        }
        else
        {
            [_countLb setText:@" "];
        }
    }
    else
    {
        _countLb.hidden = YES;
    }
}

@end
