//
//  SalaryChangeTypeCtl.h
//  jobClient
//
//  Created by 一览iOS on 15-4-8.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"

@interface SalaryChangeTypeCtl : BaseListCtl
{
    RequestCon     * addlikeCon_;
    RequestCon     * shareLogsCon_;
    RequestCon     * addCommentCon_;
}

@property (nonatomic,assign) NSInteger salaryType;
@property (strong, nonatomic) IBOutlet UIButton *rigthBtn;
@property (strong, nonatomic) IBOutlet UIView *yinDaoPage;
@property (weak, nonatomic) IBOutlet UIImageView *rightImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIButton *yinDaoBtn;

@property (weak, nonatomic) IBOutlet UIView *navigationBarView;


@end
