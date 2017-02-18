//
//  SalaryListCtl.h
//  jobClient
//
//  Created by YL1001 on 14/11/20.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "ExRequetCon.h"
#import "CondictionListCtl.h"
#import "RegionCtl.h"
#import "SalaryGuideCtl.h"
#import "SqlitData.h"
#import "FMDatabase.h"
@class ExposureSalaryCtl2;

#define  Color_Red         UIColorFromRGB(0xe75f53)
#define  Color_Blue        UIColorFromRGB(0x44a4cf)
#define  WhiteColor        [UIColor whiteColor]


@interface SalaryListCtl : BaseListCtl<CondictionListDelegate,ChooseHotCityDelegate,UITextFieldDelegate>
{
    IBOutlet UIButton    * locationBtn_;

    IBOutlet UIView      * searchView_;
    
    BOOL                  bLocation_;
    
    BOOL                  isHeadViewHiden_;
    float                 contentSetY_;
    
    NSString             *keyword_;
    UITapGestureRecognizer  *singleTapRecognizer_;  //单击的事件
    
    SalaryGuideCtl       *salaryGuideCtl_;
    
    SqlitData            *regionModel_;
    
    
    FMDatabase           *database;

}

-(void)hideKeyboard;

@property  (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) UIView *subJobView;
@property (weak, nonatomic) UIButton *selectedJobBtn;

@property (weak, nonatomic) IBOutlet UITextField * jobTF;
@property (weak, nonatomic) IBOutlet UIButton    * searchBtn;
@property (assign, nonatomic) BOOL shouldSearch;
@property (assign, nonatomic) BOOL shouldShowExposureSalary;
@property (strong, nonatomic) ExposureSalaryCtl2 *exposureCtl;
@property (weak, nonatomic) IBOutlet UIButton *loadMoreBtn;//加载更多
@property (weak, nonatomic) IBOutlet UIButton *exposureSalaryBtn;//曝工资
@property (weak, nonatomic) IBOutlet UILabel *userCountLb;

@property(assign,nonatomic) BOOL isBtnHot;

#pragma mark 跳转到搜索的页面
-(void)pushSearchCtl;

@end
