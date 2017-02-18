//
//  ProfessionList_Cell.m
//  jobClient
//
//  Created by 一览ios on 15/4/27.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ProfessionList_Cell.h"
#import "MyConfig.h"

@implementation ProfessionList_Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    _titleLb.font = FIFTEENFONT_TITLE;
    [_titleLb setTextColor:UIColorFromRGB(0x666666)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
