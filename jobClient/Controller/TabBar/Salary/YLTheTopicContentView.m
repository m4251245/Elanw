//
//  YLTheTopicContentView.m
//  jobClient
//
//  Created by 一览iOS on 15/6/19.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "YLTheTopicContentView.h"

@implementation YLTheTopicContentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)init
{
    self = [super init];
    if(self)
    {
        self.clipsToBounds = YES;
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
        self.layer.cornerRadius = 4.0;
        
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0,0,0,40)];
        self.backView.backgroundColor = UIColorFromRGB(0xe6e6e6);
        [self addSubview:self.backView];
        [self sendSubviewToBack:self.backView];
        
        self.contentLb = [[UILabel alloc] initWithFrame:CGRectMake(50,10,200,20)];
        self.contentLb.font = FIFTEENFONT_TITLE;
        self.contentLb.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.contentLb];
        
        self.percentageLb = [[UILabel alloc] initWithFrame:CGRectMake(250,10,50,20)];
        self.percentageLb.textColor = FONEREDCOLOR;
        self.percentageLb.font = TWEELVEFONT_COMMENT;
        self.percentageLb.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.percentageLb];
    }
    return self;
}

-(void)showView:(CGFloat)percentage
{
    self.percentageF = percentage;
    CGRect rect = self.backView.frame;
    rect.size.width = self.frame.size.width * percentage * 0.01;
    [UIView animateWithDuration:0.5 animations:^{
        self.backView.frame = rect;
    }];
    self.percentageLb.text = [NSString stringWithFormat:@"%.2f%%",percentage];
    /*
    if (rect.size.width > 250) {
        self.percentageLb.frame = CGRectMake(200,10,50,20);
        self.percentageLb.textColor = [UIColor whiteColor];
    }
    else
    {
        self.percentageLb.frame = CGRectMake(250,10,50,20);
        self.percentageLb.textColor = [UIColor orangeColor];
    }
     */
}

-(void)hideView
{
    self.percentageLb.text = @"";
    self.backView.frame = CGRectMake(0,0,0,40);
}

@end
