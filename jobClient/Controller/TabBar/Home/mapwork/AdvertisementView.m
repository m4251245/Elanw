//
//  AdvertisementView.m
//  ImgCircleDemo
//
//  Created by 一览iOS on 16/10/9.
//  Copyright (c) 2016年 Fu All rights reserved.
//

#import "AdvertisementView.h"
#import "ShowComInfoCardView.h"
@interface AdvertisementView () <UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,assign) NSInteger currentIndex;
@end

#define SCREEN_WIDTH self.bounds.size.width
#define SCREEN_HEIGHT self.bounds.size.height
#define BTN_WIDTH 15

@implementation AdvertisementView

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self configUI];
        [self addNoyify];
    }
    return self;
}

#pragma mark--初始化UI
-(void)configUI
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width - 25, 100)];
    _scrollView.clipsToBounds = NO;
    [self addSubview:_scrollView];

    //创建三个imageView
    for(int i = 0; i < 3; i++)
    {
        ShowComInfoCardView *infoCardView = [[ShowComInfoCardView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 20)*i, 0, SCREEN_WIDTH - 10, SCREEN_HEIGHT)];
        infoCardView.tag = 1000+i;
        [_scrollView addSubview:infoCardView];
    }

    //设置画布大小
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*3, SCREEN_HEIGHT);

    //设置初始显示的位置
    _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH - 25, 0);

    //设置分页
    _scrollView.pagingEnabled = YES;

    //设置代理
    _scrollView.delegate = self;

    //关闭弹动效果
    _scrollView.bounces = NO;
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;

}

#pragma mark -- 设置显示的数据
-(void)setImgArray:(NSArray *)imgArray
{
    _imgArray = imgArray;
    [self changeImage];
}

#pragma mark--代理
#pragma mark--停止滚动更新显示
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    if(offset.x == 0)
    {
        //向右移动的时候
        //计算新的index
        _currentIndex = [self trueIndexByCurrentIndex:_currentIndex-1];

    }
    else
    {
        //向左移动的时候
        //计算新的index
        _currentIndex = [self trueIndexByCurrentIndex:_currentIndex+1];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RealAnnonation" object:nil userInfo:@{@"realNum":@(_currentIndex)}];
    
    //将图片视图还原位置
    scrollView.contentOffset = CGPointMake(SCREEN_WIDTH-25, 0);
    //更换显示
    [self changeImage];
}

#pragma mark--通知
-(void)addNoyify{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notify:) name:@"ToRealAnnonationIdx" object:nil];
}

-(void)notify:(NSNotification *)notify{
    NSDictionary *dic = notify.userInfo;
    NSInteger idx = [dic[@"toRealNum"] integerValue];
    _currentIndex = idx;
    //将图片视图还原位置
    _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH - 25, 0);
    //更换显示
    [self changeImage];
}

-(void)dealloc{
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark--业务逻辑
#pragma mark -- 获取正确的model
-(void)changeImage
{
    ShowComInfoCardView *View1 = (id)[_scrollView viewWithTag:1000];
    View1.model = _imgArray[[self trueIndexByCurrentIndex:_currentIndex-1]];

    ShowComInfoCardView *View2 = (id)[_scrollView viewWithTag:1001];
    View2.model = _imgArray[_currentIndex];

    ShowComInfoCardView *View3 = (id)[_scrollView viewWithTag:1002];
    View3.model = _imgArray[[self trueIndexByCurrentIndex:_currentIndex+1]];
}

//计算真实的下标
-(NSInteger)trueIndexByCurrentIndex:(NSInteger)index
{
    if(index== -1)
    {
        return _imgArray.count-1;
    }
    else if(index == _imgArray.count)
    {
        return 0;
    }
    return index;
}


@end
