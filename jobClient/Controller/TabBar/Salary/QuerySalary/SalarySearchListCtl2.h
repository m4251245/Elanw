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
#import "EColumnChart.h"
#define  Color_Red         UIColorFromRGB(0xe75f53)
#define  Color_Blue        UIColorFromRGB(0x44a4cf)
#define  WhiteColor        [UIColor whiteColor]


@interface SalarySearchListCtl2 : BaseListCtl<CondictionListDelegate,ChooseHotCityDelegate,UITextFieldDelegate,EColumnChartDelegate, EColumnChartDataSource>
{
    IBOutlet UIButton    * locationBtn_;
    @public
    IBOutlet UITextField * jobTF_;
    @protected
    IBOutlet UIButton    * searchBtn_;
    IBOutlet UIView      * searchView_;
    IBOutlet UIButton    * competeBtn_;
    IBOutlet UILabel     * sumLb_;
    BOOL                  bLocation_;
    BOOL                  isHeadViewHiden_;
    float                 contentSetY_;
    NSString             *keyword_;
    UITapGestureRecognizer  *singleTapRecognizer_;  //单击的事件
    SalaryGuideCtl       *salaryGuideCtl_;
    SqlitData            *regionModel_;
    RequestCon           *sumCon_;
}

-(void)hideKeyboard;

@property  (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) UIView *subJobView;
@property (weak, nonatomic) UIButton *selectedJobBtn;

@property(nonatomic, copy) NSString *keyWords;
@property(nonatomic, copy) NSString *provinceId;
@property(nonatomic, copy) NSString *provinceName;

@property (strong, nonatomic) EColumnChart *eColumnChart;
@property (weak, nonatomic)  UILabel *valueLabel;

@property (weak, nonatomic)  UIImageView *imageV;
@property(nonatomic, copy) NSString *kwFlag;


@end
