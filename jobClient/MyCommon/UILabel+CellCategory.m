//
//  UILabel+CellCategory.m
//  jobClient
//
//  Created by YL1001 on 15/4/7.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "UILabel+CellCategory.h"
#import "MyConfig.h"

@implementation UILabel (CellCategory)

-(void)setStytle:(LabelType)type
{
    switch (type) {
        case Title_type:
        {
            
        }
            break;
            
        default:
            break;
    }
}

-(void)setFont:(UIFont *)font Color:(UIColor *)color
{
    self.font = font;
    self.textColor = color;
}

@end
