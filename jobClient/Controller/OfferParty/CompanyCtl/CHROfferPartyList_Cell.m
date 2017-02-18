//
//  CHRIndexCtl_Cell.m
//  jobClient
//
//  Created by 一览ios on 15/6/2.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "CHROfferPartyList_Cell.h"
#import "BaseUiviewController.h"

@implementation CHROfferPartyList_Cell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    CALayer *layer = _redDotLb.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 4.f;
    layer = _companyLogoImgv.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 2.f;
    layer.borderWidth = 0.5f;
    layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
