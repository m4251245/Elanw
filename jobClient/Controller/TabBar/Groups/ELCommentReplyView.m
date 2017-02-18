//
//  ELCommentReplyView.m
//  jobClient
//
//  Created by 一览iOS on 16/8/5.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELCommentReplyView.h"


@implementation ELCommentReplyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        CGFloat optionHeight = 40;
        self.frame = [UIScreen mainScreen].bounds;
        UIView *mask = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];//遮罩
        mask.backgroundColor = [UIColor blackColor];
        [self addSubview:mask];
        
        UIView *optionView = [[UIView alloc]init];
        optionView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, optionHeight*2);
        [self addSubview:optionView];
        
        UIButton *answerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [answerBtn setTitle:@"回复" forState:UIControlStateNormal];
        answerBtn.backgroundColor = [UIColor whiteColor];
        [answerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        answerBtn.frame = CGRectMake(0, 0, optionView.frame.size.width, optionHeight);
        UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gg_home_line2.png"]];
        line.frame = CGRectMake(-8, 0, ScreenWidth+16, 1);
        [answerBtn addSubview:line];
        [answerBtn addTarget:self action:@selector(buttonRespone:) forControlEvents:UIControlEventTouchUpInside];
        [optionView addSubview:answerBtn];
        
        UIButton *copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [copyBtn setTitle:@"复制" forState:UIControlStateNormal];
        copyBtn.backgroundColor = [UIColor whiteColor];
        [copyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        copyBtn.frame = CGRectMake(0, optionHeight, optionView.frame.size.width, optionHeight);
        line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gg_home_line2.png"]];
        line.frame = CGRectMake(-8, 0, ScreenWidth+16, 1);
        [copyBtn addSubview:line];
        [copyBtn addTarget:self action:@selector(buttonRespone:) forControlEvents:UIControlEventTouchUpInside];
        [optionView addSubview:copyBtn];
        
        [mask addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskClick)]];
    }
    return self;
}

-(void)buttonRespone:(UIButton *)button{
    [self removeFromSuperview];
    if ([_replyDelegate respondsToSelector:@selector(btnResponeWithTitle:)]){
        [_replyDelegate btnResponeWithTitle:button.titleLabel.text];
    }
}

#pragma mark 隐藏选项框
- (void)maskClick
{
    [UIView animateWithDuration:0.3 animations:^{
        UIView *mask = self.subviews[0];
        mask.alpha = 0.0;
        UIView *optionView = self.subviews[1];
        CGRect frame = optionView.frame;
        frame.origin.y += 80;
        optionView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)showView{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    UIView *mask = self.subviews[0];
    UIView *optionView = self.subviews[1];
    optionView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 80);
    mask.alpha = 0.0;//父view的alpha会影响子view的alpha
    [UIView animateWithDuration:0.3 animations:^{
        UIView *mask = self.subviews[0];
        mask.alpha = 0.5;
        UIView *optionView = self.subviews[1];
        CGRect frame = optionView.frame;
        frame.origin.y -= 80;
        optionView.frame = frame;
    }];
}

@end
