//
//  YLOfferListCtlCell.h
//  jobClient
//
//  Created by 一览iOS on 15/7/22.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLOfferListCtlCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *timeBackView;

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *job;
@property (weak, nonatomic) IBOutlet UILabel *dateLb;
@property (weak, nonatomic) IBOutlet UILabel *weekLb;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLb;
@property (weak, nonatomic) IBOutlet UIImageView *statuImgv;

@property (weak, nonatomic) IBOutlet UIImageView *rightImage;

@property (weak, nonatomic) IBOutlet UIImageView *lineImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeBackViewLeftWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineImageLeftWidth;

@end
