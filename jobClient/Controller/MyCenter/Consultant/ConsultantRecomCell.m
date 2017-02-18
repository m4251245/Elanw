//
//  ConsultantRecomCell.m
//  jobClient
//
//  Created by 一览ios on 15/6/8.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ConsultantRecomCell.h"

@implementation ConsultantRecomCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _readMark.layer.borderWidth = 0.5;
    _readMark.layer.borderColor = UIColorFromRGB(0xe13e3e).CGColor;
    
    _readMark.layer.cornerRadius = 2;
    _readMark.layer.masksToBounds = YES;
}

- (void)setFrame:(CGRect)frame
{
//    frame.origin.x = MARGION;
//    frame.size.width -= 2*MARGION;
//    frame.origin.y += TOPMARGION;
//    frame.size.height -= TOPMARGION + BUTTOMMARGION;
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
