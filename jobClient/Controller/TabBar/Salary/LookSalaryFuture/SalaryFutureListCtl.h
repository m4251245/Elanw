//
//  SalaryListCtl.h
//  jobClient
//
//  Created by YL1001 on 14/11/20.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//看前景

#import "BaseListCtl.h"
#import "ExRequetCon.h"
#import "CondictionListCtl.h"
#import "RegionCtl.h"
#import "SqlitData.h"
#import "FMDatabase.h"

#define  Color_Red         UIColorFromRGB(0xe75f53)
#define  Color_Blue        UIColorFromRGB(0x44a4cf)
#define  WhiteColor        [UIColor whiteColor]


@interface SalaryFutureListCtl : BaseListCtl

-(void)hideKeyboard;

@property  (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) UIView *subJobView;
@property (weak, nonatomic) UIButton *selectedMajorBtn;
@property (weak, nonatomic) IBOutlet UIButton *yearBtn;
@property (weak, nonatomic) IBOutlet UITextField *majorTF;

@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@property (weak, nonatomic) UIView *containerView;
@property (weak, nonatomic) UIPickerView *pickView;
@property (assign, nonatomic) BOOL shouldSearch;
@property (strong, nonatomic) NSMutableDictionary *queryInfo;

-(void)pushSearchCtl;

@end
