//
//  CycleScrollViewCell.m
//  CycleScrollView
//
//  Created by YL1001 on 16/8/26.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "CycleScrollViewCell.h"

@implementation CycleScrollViewCell
{
//    __weak UILabel *_titleLabel;
    CGFloat _titleLbWidth;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupImageView];
        [self setupTitleLabel];
        self.contentView.layer.masksToBounds = YES;
    }
    return self;
}

- (void)setTitleLabelBackgroundColor:(UIColor *)titleLabelBackgroundColor
{
    _titleLabelBackgroundColor = titleLabelBackgroundColor;
    _titleLabel.backgroundColor = titleLabelBackgroundColor;
}

- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    _titleLabel.textColor = titleColor;
}

- (void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
    _titleLabel.font = titleFont;
}

- (void)setupImageView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    _imgView = imageView;
    _imgView.frame = self.bounds;
    [self.contentView addSubview:imageView];
}

- (void)setupTitleLabel
{
    UILabel *label = [[UILabel alloc] init];
    _titleLabel = label;
    _titleLabel.hidden = YES;
    [self.contentView addSubview:label];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _imgView.frame = self.bounds;
}


@end
