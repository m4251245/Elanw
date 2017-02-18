//
//  RegCustomTextField.m
//  jobClient
//
//  Created by 一览ios on 14/12/23.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "RegCustomTextField.h"

@implementation RegCustomTextField


- (void)awakeFromNib
{
    [super awakeFromNib];
    CALayer *layer = self.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 4.0;
    self.backgroundColor = [UIColor whiteColor];
    layer.borderWidth = 0.5;
    layer.borderColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0].CGColor;
}


- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x +5, bounds.origin.y, bounds.size.width-5, bounds.size.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x +5, bounds.origin.y, bounds.size.width-5, bounds.size.height);
}

@end
