//
//  BaseInfoTableViewCell.m
//  jobClient
//
//  Created by 一览ios on 16/5/9.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "BaseInfoTableViewCell.h"

@implementation BaseInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
