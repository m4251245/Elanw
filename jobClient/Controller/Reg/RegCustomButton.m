//
//  CustomButton.m
//  jobClient
//
//  Created by 一览ios on 15/12/22.
//  Copyright © 2015年 YL1001. All rights reserved.
//

#import "RegCustomButton.h"

@implementation RegCustomButton


- (void)awakeFromNib
{
    [super awakeFromNib];
    CALayer *layer = self.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 4.0;
    [self setBackgroundColor:[UIColor colorWithRed:226.f/255 green:62.f/255 blue:62.f/255 alpha:1.f]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
