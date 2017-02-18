//
//  CustomTradeTextField.m
//  jobClient
//
//  Created by 一览ios on 15/1/7.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "CustomTradeTextField.h"
#import "MyConfig.h"

@implementation CustomTradeTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setFont:FOURTEENFONT_CONTENT];
        self.layer.cornerRadius = 19;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0].CGColor;
    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x +15, bounds.origin.y, bounds.size.width-5, bounds.size.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x +15, bounds.origin.y, bounds.size.width-5, bounds.size.height);
}

@end
