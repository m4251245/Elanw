//
//  WorkExperienceCell.h
//  jobClient
//
//  Created by 一览ios on 15/3/19.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkResume_DataModal.h"

@interface WorkExperienceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLb;

@property (weak, nonatomic) IBOutlet UILabel *companyNameLb;

@property (strong, nonatomic) UILabel *positionLb;

@property (weak, nonatomic) IBOutlet UIImageView *rightImage;

@property (weak, nonatomic) IBOutlet UIView *lineView;

- (void)cellAssignment:(WorkResume_DataModal *)dataModel;

@end
