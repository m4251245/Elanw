//
//  SalaryCtl2.h
//  jobClient
//
//  Created by 一览ios on 15/4/24.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"

@interface SalaryCtl2 : BaseListCtl

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) UIView *navView;
@property (weak, nonatomic) IBOutlet UIButton *personCenterBtn;
@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UILabel *redDotLb;

@property (strong, nonatomic) RequestCon *querySalaryCountCon;

@property (weak, nonatomic) UIView  *adView1;

- (void)hideKeyboard;

@property (assign, nonatomic) int selectType;//当前操作项

@end
