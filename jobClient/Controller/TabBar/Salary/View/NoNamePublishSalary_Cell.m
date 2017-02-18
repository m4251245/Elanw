//
//  NoNamePublishSalary_Cell.m
//  jobClient
//
//  Created by 一览ios on 15/4/25.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "NoNamePublishSalary_Cell.h"

@implementation NoNamePublishSalary_Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    CALayer *layer = _publishbtn.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 4.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
