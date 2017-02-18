//
//  CondictionPlaceCtl_School.h
//  CampusClient
//
//  Created by job1001 job1001 on 12-5-28.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

/******************************
 
    PreCondictionListCtl Class
 
 ******************************/

#import <UIKit/UIKit.h>
#import "PreBaseResultListCtl.h"
#import "CondictionList_DataModal.h"

#define PreCondictionListCtl_Xib_Name          @"PreCondictionListCtl"

typedef enum
{
    CondictionNullType,
    
    GetCondicitonNilType = 0,       //无
    GetSearchType,                  //获取搜索类型
    GetZWType,                      //获取职位类型
    GetTradeType,                   //获取行业类型
    GetRegionType,                  //获取工作地区
    GetDateType,                    //获取发布日期
    GetSchoolType,                  //获取学校
    GetEduType,                     //获取学历列表
    GetYearType,                    //获取工作年限
    GetMapRangType,                 //获取定位范围
    
    GetBirthDayDateType,            //获取时间分类(有:年-月-日)
    GetDateHaveNullType,            //获取时间类型(有:年-月-日 有不限按扭)
    GetPlaceOriginType,             //获取籍贯类型
    GetPostionLevelType,            //获取现有职称
    GetMarrayType,                  //获取婚姻类型
    GetPoliticsType,                //获取政治面貌
    GetCountyType,                  //国籍
    GetIdtypeType,                  //证件类型
    GetSalaryType,                  //年薪
    
    GetNationType,                  //获取民族类型
    
    GetJobType,                     //获取求职类型
    GetWorkDateType,                //获取可到职日期
    
    GetEndDateType,                 //获取结束日期(有:年-月-日 还有:至今可供选择)
    
    GetCompanyEmployeType,          //获取公司规模
    GetCompanyAttType,              //获取公司性质
    GetYearSalayType,               //获取年薪
    GetYearBounsType,               //获取年终奖
    
    GetYearMonthDateType,           //获取(年-月)日期格式的数据
    GetYearMonthDateHaveToNowType,  //获取(年-月)，并且还有至今可供选择
    
    GetZyeType,                     //获取专业分类
    GetZyeHaveAllType,              //可以选择所有专业分类
    GetTalentMarketRegionType,      //人才市场地区类型
    
    
    GetPartJobType,                 //兼职,实习分类
    GetMajorNameType,               //获取专业名称
}CondictionChooseType;


//条件选择已经完成
@protocol CondictionChooseDelegate <NSObject>

@optional
//选择了一个
-(void) condictionChooseComplete:(PreBaseUIViewController *)ctl dataModal:(CondictionList_DataModal *)dataModal type:(CondictionChooseType)type;

@optional
//选择了多个
-(void) condictionChooseComplete:(PreBaseUIViewController *)ctl dataModalArr:(NSArray *)dataModalArr type:(CondictionChooseType)type;

@end

#define TimeToNow_Str                               @"至今"
#define Cer_Date_Add_Inditifer                      @"-"

@interface PreCondictionListCtl : PreBaseResultListCtl<UIPickerViewDelegate,UIPickerViewDataSource> {
    IBOutlet    UIView              *contentView_;          //内容view
    IBOutlet    UIButton            *nullBtn_;              //不限btn
    IBOutlet    UIButton            *timeToNowBtn_;         //至今btn
    IBOutlet    UIButton            *okBtn_;                //确定btn
    IBOutlet    UIPickerView        *pickView_;             //
    //IBOutlet    UIDatePicker        *datePickView_;         //时间选择
    
    UIViewController                *presentCtl_;
    
    NSInteger                       selectIndex_;           //选中了哪行    
    NSInteger                       yearsIndex_;
    NSInteger                       monthsIndex_;
    
    CondictionChooseType            condictionType_;        //选择的类型
}
@property (nonatomic,strong) UIDatePicker *datePickView_;
@property(nonatomic,assign) id<CondictionChooseDelegate>    delegate_;

//获取教育str
+(NSString *) getEduStr:(NSString *)eduId;

//获取教育Id
+(NSString *) getEduId:(NSString *)eduStr;

//开始获取数据
-(void) beginGetData:(id)myParam exParam:(id)exParam type:(CondictionChooseType)type;

//显示/隐藏ContentView
-(void) showContentView:(BOOL)flag;

@end
