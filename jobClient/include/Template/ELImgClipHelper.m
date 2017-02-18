//
//  ELImgClipHelper.m
//  jobClient
//
//  Created by 一览ios on 16/10/15.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELImgClipHelper.h"
@implementation ELImgClipHelper

//给view切圆角（自己绘制）
-(id)imgView:(id)imageView withClipSize:(CGSize)size{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:[imageView bounds] byRoundingCorners:UIRectCornerAllCorners cornerRadii:size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = [imageView bounds];
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    [imageView layer].mask = maskLayer;
    return imageView;
}

@end
