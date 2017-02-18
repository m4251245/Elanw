//
//  NoNetworkVIew.m
//  jobClient
//
//  Created by YL1001 on 16/8/11.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "NoNetworkVIew.h"

@interface NoNetworkVIew()
{
    UIImageView *_imagView;
}

@end

@implementation NoNetworkVIew

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
        [self configUI];
    }
    
    return self;
}

- (void)configUI
{
    _imagView = [[UIImageView alloc] init];
    _imagView.frame = CGRectMake((ScreenWidth - 213.0)/2, 110, 213, 179);
    _imagView.image = [UIImage imageNamed:@"img_noNetwork.png"];
    [self addSubview:_imagView];
    
    UILabel *tipLb = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imagView.frame) + 14, ScreenWidth, 20)];
    tipLb.textAlignment = NSTextAlignmentCenter;
    tipLb.textColor = UIColorFromRGB(0xbbbbbb);
    tipLb.font = [UIFont fontWithName:@"STHeitiSC-Regular" size:14.0f];
    if (!_tipStr) {
        tipLb.text = @"失去信号了，刷新一下看看";
    }
    else
    {
        tipLb.text = _tipStr;
    }
    
    [self addSubview:tipLb];
}

- (void)addCustomSuperview:(UIView *)view topY:(CGFloat)topY
{
    [view addSubview:self];
    
}

@end
