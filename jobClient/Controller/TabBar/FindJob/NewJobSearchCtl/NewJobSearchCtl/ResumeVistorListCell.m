//
//  ResumeVistorListCell.m
//  Association
//
//  Created by 一览iOS on 14-6-25.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "ResumeVistorListCell.h"

@implementation ResumeVistorListCell
@synthesize companyNameLb_,companyNatureLb_,readCountLb_,readTimeLb_;

- (void)awakeFromNib
{
    [super awakeFromNib];
    _iconImg.layer.borderColor = UIColorFromRGB(0xecedec).CGColor;
    _iconImg.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
