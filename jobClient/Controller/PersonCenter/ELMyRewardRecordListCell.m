//
//  ELMyRewardRecordListCell.m
//  jobClient
//
//  Created by YL1001 on 15/11/2.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELMyRewardRecordListCell.h"

@implementation ELMyRewardRecordListCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _personImg.layer.cornerRadius = 8.0;
    _personImg.layer.masksToBounds = YES;
    
    _priceLb.layer.cornerRadius = 4.0;
    _priceLb.layer.masksToBounds = YES;
    _priceLb.layer.borderWidth = 1.0f;
    _priceLb.layer.borderColor = [UIColor redColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
