//
//  shareHeaderView.m
//  jobClient
//
//  Created by 一览ios on 16/9/12.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "shareHeaderView.h"

@implementation shareHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
       
    }
    return self;
}

- (void)layoutSubviews
{
    UILabel *label = [[UILabel alloc] init];
    label.center = CGPointMake(ScreenWidth/2, self.frame.size.height/2);
    label.bounds = CGRectMake(0, 0, 100, 14);
    label.text = @"分享到";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = UIColorFromRGB(0x757575);
    [self addSubview:label];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(13, 34, ScreenWidth-26, 1)];
    line.backgroundColor = UIColorFromRGB(0xdddddd);
    [self addSubview:line];
}

@end
