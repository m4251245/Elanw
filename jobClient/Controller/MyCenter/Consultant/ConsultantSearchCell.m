//
//  ConsultantSearchCell.m
//  jobClient
//
//  Created by 一览ios on 15/6/8.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ConsultantSearchCell.h"

@implementation ConsultantSearchCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _visitorBtn.layer.borderColor = UIColorFromRGB(0xbbbbbb).CGColor;
    _visitorBtn.layer.borderWidth = 0.5;
    
    _visitorBtn.layer.cornerRadius = 3;
    _visitorBtn.layer.masksToBounds = YES;
    
    _photoImagv.layer.cornerRadius = 5;
    _photoImagv.layer.masksToBounds = YES;
    
    _gender.layer.cornerRadius = 2.0;
    _gender.layer.masksToBounds = YES;
    
    _noReadMark.layer.borderWidth = 0.5;
    _noReadMark.layer.borderColor = UIColorFromRGB(0xe13e3e).CGColor;
    _noReadMark.layer.cornerRadius = 2;
    _noReadMark.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
