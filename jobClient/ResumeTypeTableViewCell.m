//
//  ResumeTypeTableViewCell.m
//  jobClient
//
//  Created by 一览ios on 16/5/6.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ResumeTypeTableViewCell.h"

@implementation ResumeTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.underLineView.backgroundColor = UIColorFromRGB(0xecedec);
    self.titleLb.textColor = UIColorFromRGB(0x333333);
    self.timeLab.textColor = UIColorFromRGB(0x999999);
    _timeLab.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
