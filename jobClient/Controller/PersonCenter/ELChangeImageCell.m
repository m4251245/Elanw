//
//  ELChangeImageCell.m
//  jobClient
//
//  Created by 一览iOS on 16/1/15.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELChangeImageCell.h"

@implementation ELChangeImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _addImageBtn.clipsToBounds = YES;
    _addImageBtn.layer.borderColor = UIColorFromRGB(0xd6d6d6).CGColor;
    _addImageBtn.layer.borderWidth = 0.5;
}

@end
