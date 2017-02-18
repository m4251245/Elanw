//
//  SuitJobTableViewCell.h
//  jobClient
//
//  Created by 一览ios on 16/5/18.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuitJobTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *jobLb;
@property (weak, nonatomic) IBOutlet UILabel *areaLb;
@property (weak, nonatomic) IBOutlet UILabel *salaryLb;
@property (weak, nonatomic) IBOutlet UILabel *conditionLb;
@property (weak, nonatomic) IBOutlet UILabel *companyLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *companyTopTo;

@end
