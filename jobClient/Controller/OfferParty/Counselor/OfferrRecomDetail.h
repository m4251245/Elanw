//
//  OfferrRecomDetail.h
//  jobClient
//
//  Created by 一览ios on 15/7/8.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"

@interface OfferrRecomDetail : BaseListCtl

@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UILabel *job;

@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIButton *genderBtn;
@property (weak, nonatomic) IBOutlet UIButton *recommentBtn;
@property (assign, nonatomic) BOOL consultantCompanyFlag;//顾问企业列表

@property (nonatomic, copy) NSString *navTitle;
@property (nonatomic, copy) NSString *jobfair_id;

@end
