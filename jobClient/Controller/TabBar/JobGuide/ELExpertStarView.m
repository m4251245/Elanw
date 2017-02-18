//
//  ELExpertStarView.m
//  jobClient
//
//  Created by 一览iOS on 15/8/28.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELExpertStarView.h"

@implementation ELExpertStarView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        for (NSInteger i= 0; i<5; i++)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.selected = YES;
            btn.frame = CGRectMake(10+30*i,0,30,30);
            btn.tag = 100+i;
            [btn setImage:[UIImage imageNamed:@"jobstarthree"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnRespone:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(170,2,40,30)];
        lable.font = FOURTEENFONT_CONTENT;
        lable.tag = 1000;
        lable.textColor = [UIColor grayColor];
        [self addSubview:lable];
    }
    return self;
}

-(void)giveDataWithStar:(CGFloat)star
{
    for (NSInteger i = 1; i<=5; i++)
    {
        UIButton *btn = (UIButton *)[self viewWithTag:99+i];
        if (i <= star) {
            [btn setImage:[UIImage imageNamed:@"jobstarone"] forState:UIControlStateNormal];
        }
        else
        {
            [btn setImage:[UIImage imageNamed:@"jobstarthree"] forState:UIControlStateNormal];
        }
        
        if (star > i-1 && star < i)
        {
            [btn setImage:[UIImage imageNamed:@"jobstartwo"] forState:UIControlStateNormal];
        }
    }
    UILabel *lable = (UILabel *)[self viewWithTag:1000];
    lable.text = [NSString stringWithFormat:@"%.1f星",star];
    _currentStar = [NSString stringWithFormat:@"%.0f",star];
}

-(void)btnRespone:(UIButton *)sender
{
    if (!_selectedBtn)
    {
        return;
    }
    [self giveDataWithStar:sender.tag-99];
}

@end

