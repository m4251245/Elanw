//
//  CycleScrollViewCell.h
//  CycleScrollView
//
//  Created by YL1001 on 16/8/26.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CycleScrollViewCell : UICollectionViewCell

@property (nonatomic, weak) UIImageView *imgView;
@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleLabelBackgroundColor;
@property (nonatomic, assign) CGFloat titleLabelHeight;

@property (nonatomic, assign) BOOL hasConfigured;

@end
