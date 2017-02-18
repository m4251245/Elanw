//
//  ELTodayJobSearchCell.h
//  jobClient
//
//  Created by 一览iOS on 15/10/23.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELTodayJobSearchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *jobImage;
@property (weak, nonatomic) IBOutlet UILabel *jobName;
@property (weak, nonatomic) IBOutlet UILabel *jobSalary;
@property (weak, nonatomic) IBOutlet UILabel *jobCompany;
@property (weak, nonatomic) IBOutlet UILabel *jobRegion;
@property (weak, nonatomic) IBOutlet UILabel *speedLb;
@property (weak, nonatomic) IBOutlet UIImageView *lineImage;

@end
