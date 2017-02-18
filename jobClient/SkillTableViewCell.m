//
//  SkillTableViewCell.m
//  jobClient
//
//  Created by 一览ios on 16/5/9.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "SkillTableViewCell.h"

@implementation SkillTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _mainConLab.textColor = UIColorFromRGB(0x333333);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
