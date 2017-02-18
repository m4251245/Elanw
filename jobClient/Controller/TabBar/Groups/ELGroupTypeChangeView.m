//
//  ELGroupTypeChangeView.m
//  jobClient
//
//  Created by 一览iOS on 16/7/6.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELGroupTypeChangeView.h"
#import "ELGroupListTypeCountModel.h"

//#define kTopWithBottomHeight 8
static double kTopWithBottomHeight = 8;

@interface ELGroupTypeChangeView()<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
}

@end

@implementation ELGroupTypeChangeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)init
{
    self = [super init];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.clipsToBounds = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];
        self.backgroundColor = UIColorFromRGB(0xf0f0f0);
    }
    return self;
}

-(void)setButtonNameArr:(NSMutableArray *)buttonNameArr{
    _buttonNameArr = buttonNameArr;
    CGSize size = [self changeButtonSize];
    _scrollView.frame = CGRectMake(0,0,ScreenWidth-kTopWithBottomHeight,kTopWithBottomHeight*2+size.height);
    CGFloat contentSizeWidth = ScreenWidth-kTopWithBottomHeight;
    CGFloat buttonMaxX = 0;
    for (NSInteger i = 0;i<buttonNameArr.count;i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonMaxX += kTopWithBottomHeight;
        button.frame = CGRectMake(buttonMaxX,kTopWithBottomHeight,size.width,size.height);
        button.clipsToBounds = YES;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = FIFTEENFONT_TITLE;
        
        [button sd_setBackgroundImageWithURL:[NSURL URLWithString:[buttonNameArr[i] pic]] forState:UIControlStateNormal];
        //[button setBackgroundImage:[UIImage imageNamed:@"personcenter_back_image"] forState:UIControlStateNormal];
        [button setTitle:[buttonNameArr[i] name] forState:UIControlStateNormal];
        button.tag = 100+i;
        [button addTarget:self action:@selector(buttonResopne:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:button];
        buttonMaxX = CGRectGetMaxX(button.frame);
        contentSizeWidth = buttonMaxX > contentSizeWidth ? buttonMaxX:contentSizeWidth;
    }
    
    _scrollView.contentSize = CGSizeMake(contentSizeWidth,kTopWithBottomHeight*2+size.height);
    self.viewHeight = kTopWithBottomHeight*2+size.height;
}

-(CGSize)changeButtonSize{
    CGFloat width = (ScreenWidth-24)/2.0;
    CGFloat height = (width*98)/336.0;
    return CGSizeMake(width,height);
}

-(void)buttonResopne:(UIButton *)sender{
    if (_selectBlock) {
        _selectBlock(_buttonNameArr[sender.tag-100]);
    }
}

@end
