//
//  ELCreateCourseCell.m
//  jobClient
//
//  Created by YL1001 on 15/10/8.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELCreateCourseCell.h"

@implementation ELCreateCourseCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];

    _contentBgView.layer.cornerRadius = 8.0;
    
    _courseTime.layer.cornerRadius = 3.0;
    _courseTime.layer.masksToBounds = YES;
    
    _coursePrice.layer.cornerRadius = 3.0;
    _coursePrice.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
