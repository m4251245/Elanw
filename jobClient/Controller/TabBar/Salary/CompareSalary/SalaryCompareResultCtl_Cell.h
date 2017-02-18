//
//  SalaryCompareResultCtl_Cell.h
//  jobClient
//
//  Created by YL1001 on 15/6/25.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User_DataModal;

@interface SalaryCompareResultCtl_Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *contentView_;

@property (weak, nonatomic) IBOutlet UIImageView *SexImg;

@property (weak, nonatomic) IBOutlet UILabel *jobLb;

@property (weak, nonatomic) IBOutlet UILabel *salaryLb;

@property (weak, nonatomic) IBOutlet UILabel *firstNameLb;
@property (weak, nonatomic) IBOutlet UILabel *sexLb;
@property (weak, nonatomic) IBOutlet UILabel *moneyLb;

@property (weak, nonatomic) IBOutlet UILabel *addressLb;

@property (weak, nonatomic) IBOutlet UILabel *educationLb;

@property (weak, nonatomic) IBOutlet UIView *workAgeLine;
@property (weak, nonatomic) IBOutlet UILabel *workAgeLb;

@property (weak, nonatomic) IBOutlet UIView *schoolLine;
@property (weak, nonatomic) IBOutlet UILabel *schoolLb;


@property (weak, nonatomic) IBOutlet UIButton *resumeLookBtn;

@property (weak, nonatomic) IBOutlet UIButton *resumeCmpBtn;

@property (weak, nonatomic) IBOutlet UIView *lineView;
@end
