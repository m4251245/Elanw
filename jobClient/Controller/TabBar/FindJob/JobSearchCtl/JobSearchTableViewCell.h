//
//  JobSearchTableViewCell.h
//  jobClient
//
//  Created by 一览ios on 15-1-7.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"

@interface JobSearchTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *conditionLb;
@property (weak, nonatomic) IBOutlet CustomButton *deleteBtn;

@end
