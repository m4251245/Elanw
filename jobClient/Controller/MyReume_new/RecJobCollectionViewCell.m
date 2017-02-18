//
//  RecJobCollectionViewCell.m
//  jobClient
//
//  Created by 一览ios on 16/5/20.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "RecJobCollectionViewCell.h"
#import "ZPinfoDataModel.h"
@implementation RecJobCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _iconImg.layer.borderColor = UIColorFromRGB(0xecedec).CGColor;
    _iconImg.layer.borderWidth = 1;
}

@end
