//
//  ELMyCollectNoDataView.m
//  jobClient
//
//  Created by YL1001 on 16/8/11.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELMyCollectNoDataView.h"

@implementation ELMyCollectNoDataView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self configUI];
    }
    
    return self;
}

- (void)configUI
{
    UIImageView *imagev = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 213 )/2, 79, 213, 179)];
    [imagev setImage:[UIImage imageNamed:@"img_myCollect_noData.png"]];
    [self addSubview:imagev];
    
    UILabel *tipsLb = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth - 200)/2, imagev.frame.origin.y + imagev.frame.size.height + 14, 200, 30)];
    tipsLb.textColor = UIColorFromRGB(0xbbbbbb);
    tipsLb.textAlignment = NSTextAlignmentCenter;
    tipsLb.font = [UIFont fontWithName:@"STHeitiSC-Regular" size:14];
    tipsLb.text = @"您还没有收藏";
    [self addSubview:tipsLb];
}


@end
