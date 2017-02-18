//
//  DetailConTableViewCell.m
//  jobClient
//
//  Created by 一览ios on 16/5/9.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "DetailConTableViewCell.h"

@implementation DetailConTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.timeLab.textColor = UIColorFromRGB(0x888888);
    self.introLab.textColor = UIColorFromRGB(0x333333);
    self.detailLab.textColor = UIColorFromRGB(0x888888);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
