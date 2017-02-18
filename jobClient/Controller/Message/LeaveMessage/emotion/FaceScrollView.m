//
// 
//  jobClient
//
//  Created by 一览ios on 14/12/8.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//  表情

#import "FaceScrollView.h"
#define PageControlW 40
#define PageControlH 20

@implementation FaceScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (id)initWithBlock:(SelectBlock)block {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        faceView.block = block;
    }
    return self;
}

- (void)initViews {
    faceView = [[FaceView alloc] init];
    faceView.frame = CGRectZero;
    faceScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, faceView.height)];
    faceScrollView.backgroundColor = [UIColor clearColor];
    faceScrollView.contentSize = CGSizeMake(faceView.width, faceView.height);
    faceScrollView.pagingEnabled = YES;
    faceScrollView.showsHorizontalScrollIndicator = NO;
    faceScrollView.clipsToBounds = NO;
    faceScrollView.delegate = self;
    [faceScrollView addSubview:faceView];
    [self addSubview:faceScrollView];
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-40)*0.5, faceView.height+10, 40, 20)];
    pageControl.backgroundColor = [UIColor clearColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.numberOfPages = faceView.pageNumber;
    pageControl.currentPage = 0;
    [self addSubview:pageControl];
    
    self.height = faceView.height + pageControl.frame.size.height+10;
    self.width = faceView.width;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int pageNumber = scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
    pageControl.currentPage = pageNumber;
}

- (void)drawRect:(CGRect)rect {
    [[UIImage imageNamed:@"emoticon_keyboard_background.png"] drawInRect:rect];
}

- (void)setFrame:(CGRect)frame
{
    frame = CGRectMake(frame.origin.x, frame.origin.y, [UIScreen mainScreen].bounds.size.width, self.height);
    [super setFrame:frame];
}

@end
