//
//  ConsultantRecomCell.h
//  jobClient
//
//  Created by 一览ios on 15/6/8.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConsultantRecomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoImagv;

@property (weak, nonatomic) IBOutlet UIButton *gender;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *contentDescLb;
@property (weak, nonatomic) IBOutlet UILabel *jobLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *recomJobNameLb;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLb;
@property (weak, nonatomic) IBOutlet UILabel *readMark;
@end
