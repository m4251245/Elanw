//
//  SalaryButton.m
//  jobClient
//
//  Created by 一览ios on 15/4/24.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "SalaryButton.h"
#define imgRate 0.8

@implementation SalaryButton


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setTitleColor:[UIColor colorWithRed:102.f/255 green:102.f/255 blue:102.f/255 alpha:1.f] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:15];
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake((contentRect.size.width-40)/2.0,0, 40,40);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, contentRect.size.height -16, contentRect.size.width, 16);
}

@end
