//
//  ToRecomResumeCell.h
//  jobClient
//
//  Created by 一览ios on 15/6/9.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToRecomResumeCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *seletedImagev;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *zwLb;
@property (weak, nonatomic) IBOutlet UILabel *markLb;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet UILabel *selectLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleRightWidth;

@property (weak, nonatomic) IBOutlet UILabel *offerNameLb;

@end
