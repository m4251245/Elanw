//
//  UILabel+CellCategory.h
//  jobClient
//
//  Created by YL1001 on 15/4/7.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    Title_type,
    Content_Type,
    Time_Type,
    Comment_Type,
    Name_Type,
    Num_Type,
    Tag_Type,
    
}LabelType;

@interface UILabel (CellCategory)

-(void)setStytle:(LabelType)type;

-(void)setFont:(UIFont *)font Color:(UIColor*)color;

@end
