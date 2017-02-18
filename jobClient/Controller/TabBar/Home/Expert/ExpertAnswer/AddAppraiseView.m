//
//  AddAppraiseView.m
//  jobClient
//
//  Created by YL1001 on 15/8/12.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "AddAppraiseView.h"

@implementation AddAppraiseView

@synthesize commitBtn_,textView_,cancelBtn_,tipLb_;

- (void)awakeFromNib
{
    textView_.layer.borderWidth = 1;
    textView_.delegate = self;
}

- (IBAction)btnClick:(id)sender {
    
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
