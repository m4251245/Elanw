//
//  SalaryCompareQuery_Cell.h
//  jobClient
//
//  Created by 一览ios on 15/3/30.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//
#define CELL_MARGIN_TOP 14

#import <UIKit/UIKit.h>
@class User_DataModal;

@interface SalaryCompareQuery_Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *countLb;

@property (weak, nonatomic) IBOutlet UILabel *detailLb;

@property (weak, nonatomic) IBOutlet UILabel *timeLb;

@property (strong, nonatomic) User_DataModal *userModel;

@end
