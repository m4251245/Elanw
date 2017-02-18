//
//  SalaryBaoDetail_Cell.h
//  jobClient
//
//  Created by 一览ios on 15/4/27.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//薪指入口 曝工资

#import <UIKit/UIKit.h>
#import "ELSalaryResultModel.h"


@interface SalaryBaoDetail_Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *jobLb;
@property (weak, nonatomic) IBOutlet UILabel *salaryLb;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (weak, nonatomic) IBOutlet UILabel *schoolLb;
@property (weak, nonatomic) IBOutlet UILabel *beatLb;
@property (weak, nonatomic) IBOutlet UIView *salaryView;
@property (weak, nonatomic) IBOutlet UILabel *educationLevelLb;
@property (weak, nonatomic) IBOutlet UILabel *workAgeLb;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImgv;

@property (strong, nonatomic) ELSalaryResultModel *salaryResultModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *salaryViewLeftToProgress;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *schoolLabWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jobWidth;


@end
