//
//  ConsltRecHeaderCollectionViewCell.m
//  jobClient
//
//  Created by 一览ios on 16/5/20.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ConsltRecHeaderCollectionViewCell.h"

@implementation ConsltRecHeaderCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _iconImg.layer.cornerRadius = 22;
    _iconImg.layer.masksToBounds = YES;
}

@end
