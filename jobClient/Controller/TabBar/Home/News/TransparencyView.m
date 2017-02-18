//
//  TransparencyView.m
//  jobClient
//
//  Created by 一览iOS on 14-8-5.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "TransparencyView.h"

@implementation TransparencyView
@synthesize flag_,delegate_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

-(void)tappedCancel:(UIGestureRecognizer *)gesture
{
    if ([delegate_ respondsToSelector:@selector(removeView)]) {
        [delegate_ removeView];
    }
    flag_ = NO;
    [self removeFromSuperview];
}

@end
