//
//  CounsultRecTableViewCell.m
//  jobClient
//
//  Created by 一览ios on 16/5/20.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "CounsultRecTableViewCell.h"

@implementation CounsultRecTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _recBgCollectionView.layer.cornerRadius = 5;
    _recBgCollectionView.layer.masksToBounds = YES;
    self.contentView.backgroundColor = UIColorFromRGB(0xf0f0f0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
