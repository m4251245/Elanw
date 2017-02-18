//
//  ELSuitJobTableviewCell.h
//  jobClient
//
//  Created by 一览ios on 16/9/9.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELSuitJobTableviewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *jobLabel;
@property (weak, nonatomic) IBOutlet UILabel *salaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *JobRequireLabel;
@property (weak, nonatomic) IBOutlet UIImageView *companyLogo;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *welfareHeight;

@end
