//
//  SalaryBao_Cell.m
//  jobClient
//
//  Created by 一览ios on 15/4/25.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "SalaryBao_Cell.h"

@implementation SalaryBao_Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    CALayer *layer = _lookAtBtn.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 4.f;
    
    layer = _myselfBtn.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 4.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
