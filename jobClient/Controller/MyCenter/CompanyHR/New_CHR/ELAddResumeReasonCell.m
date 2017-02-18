//
//  ELAddResumeReasonCell.m
//  jobClient
//
//  Created by 一览ios on 16/12/12.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELAddResumeReasonCell.h"

@implementation ELAddResumeReasonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews
{
    self.height = 48;
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, ScreenWidth-100, 16)];
    _nameLabel.textColor = UIColorFromRGB(0x212121);
    _nameLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:_nameLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
