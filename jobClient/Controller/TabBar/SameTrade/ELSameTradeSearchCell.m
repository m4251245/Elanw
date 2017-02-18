//
//  ELSameTradeSearchCell.m
//  jobClient
//
//  Created by 一览iOS on 15/10/23.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELSameTradeSearchCell.h"

@implementation ELSameTradeSearchCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    _personImage.clipsToBounds = YES;
    _personImage.layer.cornerRadius = 3.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
