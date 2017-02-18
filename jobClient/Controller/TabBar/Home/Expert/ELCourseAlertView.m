//
//  ELCourseAlertView.m
//  jobClient
//
//  Created by 一览iOS on 16/12/14.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELCourseAlertView.h"

@implementation ELCourseAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithTitle:(NSString *)title{
    self = [[[NSBundle mainBundle] loadNibNamed:@"ELCourseAlertView" owner:self options:nil] lastObject];
    if (self){
        self.frame = [[UIApplication sharedApplication] keyWindow].bounds;
        self.contentLb.text = title;
    }
    return self;
}

-(void)showView{
    self.frame = [[UIApplication sharedApplication] keyWindow].bounds;
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
    }];
}

-(void)hideView{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (IBAction)cancelBtnClick:(id)sender {
    [self hideView];
}
- (IBAction)rightBtnClick:(id)sender{
    if ([_alertDelegate respondsToSelector:@selector(delegateRightBtnClick)]) {
        [_alertDelegate delegateRightBtnClick];
    }
    [self hideView];
}

@end
