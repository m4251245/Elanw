//
//  New_HeaderBtn.m
//  jobClient
//
//  Created by 一览ios on 16/7/29.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "New_HeaderBtn.h"
@interface New_HeaderBtn()

@end
@implementation New_HeaderBtn

-(instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title arrCount:(NSInteger)count{
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle]loadNibNamed:@"New_HeaderBtn" owner:nil options:nil].firstObject;
        self.titleLb.text = title;
        self.titleLb.lineBreakMode = NSLineBreakByTruncatingTail;
        _markImg.hidden = YES;
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 43, ScreenWidth/count, 1)];
        line.backgroundColor = UIColorFromRGB(0xecedec);
        [self addSubview:line];
        [self insertSubview:line belowSubview:self.markImg];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}
/**
 *  点击
 *
 *  @param sender sender description
 */
- (IBAction)btnTapClick:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(newHeaderBtnClick:)]) {
        [_delegate newHeaderBtnClick:sender];
    }
}

-(void)configImg{
    if (!self.isSelected) {
        self.titleImg.image = [UIImage imageNamed:@"小筛选下拉more-sel"];
        self.markImg.hidden = NO;
    }
    else{
        self.titleImg.image = [UIImage imageNamed:@"小筛选下拉more"];
        self.markImg.hidden = YES;
    }
    self.isSelected = !self.isSelected;
}

@end
