//
//  SalaryCompareOrder_Cell.h
//  jobClient
//
//  Created by 一览ios on 15/3/30.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//
#define CELL_MARGIN_TOP 14
#import <UIKit/UIKit.h>
@class OrderType_DataModal;

@interface SalaryCompareOrder_Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderNumLb;
@property (weak, nonatomic) IBOutlet UILabel *amountLb;

@property (weak, nonatomic) IBOutlet UILabel *serviceContentLb;
@property (weak, nonatomic) IBOutlet UILabel *orderTime;
@property (weak, nonatomic) IBOutlet UIView *tipsView1;
@property (weak, nonatomic) IBOutlet UILabel *tipsLb;

@property (weak, nonatomic) IBOutlet UIView *tipsView2;
@property (weak, nonatomic) IBOutlet UILabel *countLb;
@property (weak, nonatomic) IBOutlet UIButton *goUseBtn;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UIImageView *countUsedImgv;

@property (strong, nonatomic) OrderType_DataModal *order;

@end
