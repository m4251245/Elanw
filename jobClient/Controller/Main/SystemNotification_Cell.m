//
//  SystemNotification_Cell.m
//  jobClient
//
//  Created by YL1001 on 14/10/31.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "SystemNotification_Cell.h"

@implementation SystemNotification_Cell

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
    
    self.separatorInset = UIEdgeInsetsZero;
    if (IOS8) {
        self.layoutMargins = UIEdgeInsetsZero;
    }
    
    self.bgView_.layer.borderColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0].CGColor;
    self.bgView_.layer.borderWidth = 0.5;
    
    [self.contentLb_ setFont:FOURTEENFONT_CONTENT];
    [self.contentLb_ setTextColor:BLACKCOLOR];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
