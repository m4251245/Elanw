//
//  WantJob_ResumeCtl.h
//  jobClient
//
//  Created by job1001 job1001 on 12-2-7.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

/*********************************
 
        简历--->求职意向
 *********************************/

#import <UIKit/UIKit.h>
#import "BaseResumeCtl.h"
#import "PreCondictionListCtl.h"
//#import "RegionCtl.h"

//意向职位类型,是哪种意向,例如是第一种意向职位
typedef enum {
    Want_ZW_1,
    Want_ZW_2,
    Want_ZW_3,
}WantZWType;

//意向地区类型,是哪种意向,例如是第一种意向地区
typedef enum {
    Want_Region_1,
    Want_Region_2,
    Want_Region_3,
}WantRegionType;

typedef void(^backBlock)(PersonDetailInfo_DataModal *model);

@interface WantJob_ResumeCtl : BaseResumeCtl<UITextFieldDelegate,UITextViewDelegate,CondictionChooseDelegate,ChooseHotCityDelegate> {
    IBOutlet    UIButton        *jobTypeBtn_;       //求职类型
    IBOutlet    UIButton        *zw1Btn_;           //意向职位1
    IBOutlet    UIButton        *zw2Btn_;           //意向职位2
    IBOutlet    UIButton        *zw3Btn_;           //意向职位3
    IBOutlet    UIButton        *region1Btn_;       //意向地区1
    IBOutlet    UIButton        *region2Btn_;       //意向地区2
    IBOutlet    UIButton        *region3Btn_;       //意向地区3
    IBOutlet    UIButton        *workDateBtn_;      //可到职日期(workdate)
    IBOutlet    UITextField     *monthSalaryTf_;    //期望月薪(yuex)
//    IBOutlet    UITextView      *grzzTv_;           //自我评价(数据库中是"个人自传,因此是:grzz")
    
    IBOutlet    UILabel        *jobTypeLb_;
    IBOutlet    UILabel        *zw1Lb_;
    IBOutlet    UILabel        *zw2Lb_;
    IBOutlet    UILabel        *zw3Lb_;
    IBOutlet    UILabel        *region1Lb_;
    IBOutlet    UILabel        *region2Lb_;
    IBOutlet    UILabel        *region3Lb_;
    IBOutlet    UILabel        *workDateLb_;
    IBOutlet    UILabel        *monthSalaryLb_;
//    IBOutlet    UILabel        *grzzLb_;
    IBOutlet    UILabel        *regionTitleLb_;
    IBOutlet    UILabel        *zwTitleLb_;
    WantZWType                  currentWantZWType_;         //现在正在想要哪种意向职位
    WantRegionType              currentWantRegionType_;     //现在正在想要哪种意向地区
    
    NSString                    *jobtype_;
    NSString                    *zw1_;
    NSString                    *zw2_;
    NSString                    *zw3_;
    NSString                    *region1_;
    NSString                    *region2_;
    NSString                    *region3_;
    NSString                    *workdate_;
    NSString                    *yuex_;
    NSString                    *grzz_;
}

@property(nonatomic,copy) backBlock  backBlock;
//检查是否能保存
-(BOOL) checkCanSave;
@property (weak, nonatomic) IBOutlet UISwitch *receiveEmailSwitch;

@end
