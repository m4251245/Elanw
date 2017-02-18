//
//  SectionHeaderView.m
//  jobClient
//
//  Created by 一览ios on 16/5/9.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "SectionHeaderView.h"

@implementation SectionHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle]loadNibNamed:@"SectionHeaderView" owner:self options:nil].firstObject;
        [self.editBtn setTitleColor:UIColorFromRGB(0xe13e3e) forState:UIControlStateNormal];
        self.headerTitleLb.textColor = UIColorFromRGB(0x333333);
        self.backgroundColor = [UIColor clearColor];
        _bgView.backgroundColor = [UIColor whiteColor];
        _unWholeLb.layer.borderWidth = 1;
        _unWholeLb.layer.borderColor = UIColorFromRGB(0x2884e1).CGColor;
        
        _unWholeLb.layer.cornerRadius = 8;
        _unWholeLb.layer.masksToBounds = YES;
    }
    return self;
}

@end
