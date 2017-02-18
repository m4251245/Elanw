//
//  RecommendJob_Cell.m
//  jobClient
//
//  Created by 一览ios on 15/11/19.
//  Copyright © 2015年 YL1001. All rights reserved.
//

#import "RecommendJob_Cell.h"

@implementation RecommendJob_Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    CALayer *layer = _conditionLb1.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 1.5;
    layer.borderWidth = 0.5;
    layer.borderColor = [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0].CGColor;
    layer = _conditionLb2.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 1.5;
    layer.borderWidth = 0.5;
    layer.borderColor = [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0].CGColor;
    layer = _conditionLb3.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 1.5;
    layer.borderWidth = 0.5;
    layer.borderColor = [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
