//
//  RecommendJob_Cell.h
//  jobClient
//
//  Created by 一览ios on 15/11/19.
//  Copyright © 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendJob_Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *summaryLb;
@property (weak, nonatomic) IBOutlet UILabel *salaryLb;
@property (weak, nonatomic) IBOutlet UILabel *conditionLb1;
@property (weak, nonatomic) IBOutlet UILabel *conditionLb2;
@property (weak, nonatomic) IBOutlet UILabel *conditionLb3;
@property (weak, nonatomic) IBOutlet UILabel *conditionTitleLb;

@end
