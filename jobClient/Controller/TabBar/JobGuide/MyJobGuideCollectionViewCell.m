//
//  MyJobGuideCollectionViewCell.m
//  jobClient
//
//  Created by YL1001 on 15/10/13.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "MyJobGuideCollectionViewCell.h"
#import "ELLineView.h"

@implementation MyJobGuideCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.viewLine = [[ELLineView alloc] initWithFrame:CGRectMake(0,0,1,46) WithColor:UIColorFromRGB(0xe0e0e0)];
    [self.contentView addSubview:self.viewLine];
}

@end
