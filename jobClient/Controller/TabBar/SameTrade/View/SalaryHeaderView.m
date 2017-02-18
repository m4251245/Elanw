//
//  SalaryHeaderView.m
//  jobClient
//
//  Created by 一览ios on 15/3/20.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "SalaryHeaderView.h"

@implementation SalaryHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    CALayer *layer = _recommendTipLb.layer;
    layer.borderWidth = 1.f;
    layer.borderColor = [UIColor redColor].CGColor;
    layer.masksToBounds = YES;
    layer.cornerRadius = 4.f;
}

@end
