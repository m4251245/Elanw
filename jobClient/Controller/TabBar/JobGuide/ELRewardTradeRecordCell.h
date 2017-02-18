//
//  ELRewardTradeRecordCell.h
//  jobClient
//
//  Created by YL1001 on 15/8/31.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELRewardTradeRecordCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *bgView_;

@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *statusLb;
@property (weak, nonatomic) IBOutlet UILabel *detailLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *moneyLb;
@property (weak, nonatomic) IBOutlet UIImageView *giftImg;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *detailLbAutoLeading;

@end
