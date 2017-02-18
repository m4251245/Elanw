//
//  CustomSearchBar.m
//  jobClient
//
//  Created by 一览ios on 15-1-5.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "CustomSearchBar.h"

@implementation CustomSearchBar



- (void)layoutSubviews {
    
    UITextField *searchField;
    NSUInteger numViews = [self.subviews count];
    for(int i = 0; i < numViews; i++) {
        if([[self.subviews objectAtIndex:i] isKindOfClass:[UITextField class]]) { //conform?
            searchField = [self.subviews objectAtIndex:i];
        }
    }
    
    if(!(searchField == nil)) {
        searchField.textColor = [UIColor redColor];
        searchField.backgroundColor = [UIColor redColor];
        [searchField setBorderStyle:UITextBorderStyleRoundedRect];
        UIImage *image = [UIImage imageNamed: @"出发位置.png"];
        UIImageView *iView = [[UIImageView alloc] initWithImage:image];
        searchField.leftView = iView;
    }
    [super layoutSubviews];
    
}

@end
