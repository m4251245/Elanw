//
//  AssetsCollectionViewCell.m
//  jobClient
//
//  Created by 一览ios on 15/7/3.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "AssetsCollectionViewCell.h"
#import "ELImgClipHelper.h"
@implementation AssetsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    self.countBtn = (UIButton *)[[[ELImgClipHelper alloc]init] imgView:self.countBtn withClipSize:CGSizeMake(10, 10)];
    
    CALayer *layer = _countBtn.layer;
    layer.cornerRadius = 10;
    layer.borderWidth = 1;
    layer.borderColor = [UIColor whiteColor].CGColor;
    layer.masksToBounds = YES;
//    layer.shouldRasterize = YES;
}

@end
