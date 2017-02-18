//
//  SalaryCompeteCtl.h
//  Association
//
//  Created by 一览iOS on 14-2-13.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "CondictionListCtl.h"
#import "BaseEditInfoCtl.h"
#import "User_DataModal.h"
#import "RegionCtl.h"
#import "SalaryCompareResultCtl.h"
#import "RegInfoThreeCtl.h"
#import "ChangeRegionViewController.h"

#define SalaryTextColor         UIColorFromRGB(0xFF5869)
#define PlaceHolderTextColor    UIColorFromRGB(0xCACACA)
#define SalaryTextBorderColor   [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1.0]

@interface SalaryCompeteCtl : BaseEditInfoCtl<CondictionListDelegate,UITextFieldDelegate,ChooseHotCityDelegate,SelectTradeCtlDelegate>
{
    IBOutlet UIView         * staticView_;
    IBOutlet UIButton       * regionBtn_;
    IBOutlet UITextField    * jobTF_;
    IBOutlet UITextField    * salaryTF_;
    IBOutlet UIButton       * commitBtn_;
    IBOutlet UIButton       * tradeBtn_;
    __weak IBOutlet UIView *toolBar;
    
    User_DataModal  * modal_;
    
    NSString * inLocation_;
    NSString * trade_;
    SqlitData            *regionModel_;
    personTagModel              *personModel_;
    
    NSString  *is_free;
}


@property(nonatomic,assign) int             type_;
@property(nonatomic,assign) BOOL            haveKw_;
@property(nonatomic,strong) NSString      * kwFlag_;

@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIButton *querySalaryBtn;
@property (weak, nonatomic) IBOutlet UIButton *orderBtn;
@property (weak, nonatomic) IBOutlet UILabel *countLb;

@property(nonatomic, copy) NSString *orderId;
@property(nonatomic, copy) NSString *orderNum;

@property (weak, nonatomic) IBOutlet UILabel *alertLabel;
@property (weak, nonatomic) IBOutlet UILabel *changeLabel;

@property (weak, nonatomic) IBOutlet UILabel *placeLabel;

@property(nonatomic,assign) BOOL isEnablePop;

@end
