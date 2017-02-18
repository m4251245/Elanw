//
//  SuitJobTableViewCell.m
//  jobClient
//
//  Created by 一览ios on 16/5/18.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "SuitJobTableViewCell.h"

@implementation SuitJobTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _iconImg.layer.borderWidth = 1;
    _iconImg.layer.borderColor = UIColorFromRGB(0xecedec).CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
