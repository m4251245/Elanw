//
//  CustomTagButton.m
//  jobClient
//
//  Created by 一览iOS on 14-11-3.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "CustomTagButton.h"
#import "BaseUIViewController.h"
@implementation CustomTagButton
@synthesize isSeleted_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self.titleLabel setFont:FOURTEENFONT_CONTENT];
        self.layer.cornerRadius = 19;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = UIColorFromRGB(0xbdbdbd).CGColor;
        self.layer.backgroundColor = [UIColor whiteColor].CGColor;
    }
    return self;
}

@end
