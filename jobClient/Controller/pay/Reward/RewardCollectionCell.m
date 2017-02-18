//
//  RewardCollectionCell.m
//  jobClient
//
//  Created by YL1001 on 15/11/1.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "RewardCollectionCell.h"

@implementation RewardCollectionCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    CALayer *layer = _priceLb.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 4.f;
    layer.borderColor = [UIColor colorWithRed:240.f/255 green:95.f/255 blue:95.f/255 alpha:1.f].CGColor;
    layer.borderWidth = 0.5f;
}

@end
