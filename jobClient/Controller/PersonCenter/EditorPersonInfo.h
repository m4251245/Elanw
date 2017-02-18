//
//  EditorPersonInfo.h
//  jobClient
//
//  Created by 一览ios on 14-12-30.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"
#import "PersonCenterDataModel.h"
#import "ExRequetCon.h"
#import "personTagModel.h"
#import "PreCondictionListCtl.h"
#import "CondictionList_DataModal.h"
#import "RegInfoThreeCtl.h"
#import "RegionCtl.h"

typedef enum {
    name_type = 0,       //姓名
    age_type,            //年龄
    workage_type,        //工龄
    workAddr_type,       //现工作地点
    trade_type,          //所属行业
    zhiye_type,          //职业
    touxian_type,        //头衔
    gender_type,         //性别
    expertIntro_type,    //行家简介
    intro_type,          //职业宣言
    role_type,           //社会宣言
    jobStatus_type,      //工作状态
}EDITORTYPE;

@protocol EditorPersonInfoDelegate <NSObject>

- (void)editorSuccess;

@end

typedef void(^editorBlock)();

@interface EditorPersonInfo : BaseEditInfoCtl<CondictionChooseDelegate,ChooseHotCityDelegate,SelectTradeCtlDelegate,UIActionSheetDelegate>
{
    IBOutlet    UIView        *editorView_;
    IBOutlet    UILabel       *tipsLb_;
    IBOutlet    UITextField   *editorTextField_;
    IBOutlet    UIButton      *editorBtn_;
    PersonCenterDataModel     *personInModel_;
    RequestCon                *editCon_;
    
    PersonCenterDataModel       *inModelOne_;
    CondictionList_DataModal    *regionDataModal_;          //居住地data
    CondictionList_DataModal    *birthDayDataModal_;        //出生日期data
    personTagModel              *personModel_;
    
}

@property(nonatomic,weak) id <EditorPersonInfoDelegate>  delegate;
@property (nonatomic, assign) EDITORTYPE  editorType;   //编辑资料
@property (nonatomic, assign) editorBlock  editorBlock;
@property(nonatomic,assign) BOOL fromResume;  //简历

@end
