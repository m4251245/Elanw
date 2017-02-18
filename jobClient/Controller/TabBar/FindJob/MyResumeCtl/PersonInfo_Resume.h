//
//  PersonInfo_ResumeCtl.h
//  jobClient
//
//  Created by job1001 job1001 on 12-2-6.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

/*********************************
 
        简历--->基本资料
 *********************************/


#import <UIKit/UIKit.h>
#import "BaseResumeCtl.h"
#import "PreCommon.h"
#import "PreCondictionListCtl.h"
#import "RegionCtl.h"

#define PersonInfo_ResumeCtl_Title              @"基本资料"
#define PersonInfo_ResumeCtl_Xib_Name           @"PersonInfo_ResumeCtl"

#define PersonInfo_Gz_Num_Max                   80      //工作年限的最大值
#define PersonInfo_Gz_Num_Min                   0       //工作年限的最小值

@interface PersonInfo_ResumeCtl : BaseResumeCtl<UITextFieldDelegate,CondictionChooseDelegate,ChooseHotCityDelegate> {
    //必填
    IBOutlet    UITextField                     *nameTf_;
    IBOutlet    UITextField                     *yearTf_;
    IBOutlet    UIButton                        *boyBtn_;
    IBOutlet    UIButton                        *girlBtn_;
    IBOutlet    UIButton                        *hightEduBtn_;
    IBOutlet    UIButton                        *placeOriginBtn_;   //籍贯
    IBOutlet    UIButton                        *birthBayBtn_;      //出生日期(年/月/日)
    IBOutlet    UITextField                     *cellPhoneTf_;
    IBOutlet    UITextField                     *emailTf_;
    IBOutlet    UIButton                        *addressBtn_;

    //选填
    //IBOutlet    UIButton                        *nowSalaryBtn_;     //目前年薪
    IBOutlet    UIButton                        *marryBtn_;         //婚姻
    IBOutlet    UIButton                        *politicsBtn_;      //政治面貌
    IBOutlet    UIButton                        *nationBtn_;        //民族
    IBOutlet    UIButton                        *positionLevelBtn_; //现有职称等级
    
    SexState                                    sexState_;
    NSString                                    *edu_;
    NSString                                    *hka_;
    NSString                                    *birthday_;
    NSString                                    *nowRegionId_;
    NSString                                    *zcheng_;
    NSString                                    *marray_;
    NSString                                    *zzmm_;
    NSString                                    *mzhu_;
    
    UIImage                                     *selectImageOn_;    //选中时的图片
    UIImage                                     *selectImageOff_;   //没有选中时的图片
    
        
    CondictionList_DataModal                    *eduDataModal_;             //学历data
    CondictionList_DataModal                    *placeOriginDataModal_;     //籍贯data
    CondictionList_DataModal                    *birthDayDataModal_;        //出生日期data
    CondictionList_DataModal                    *regionDataModal_;          //居住地data
    CondictionList_DataModal                    *positionLevelDataModal_;   //现有职称data
    CondictionList_DataModal                    *marrayDataModal_;          //婚姻data
    CondictionList_DataModal                    *politicsDataModal_;        //政治面貌data
    CondictionList_DataModal                    *nationDataModal_;          //民族data
}

//更改性别按扭状态
-(void) changeSexBtnStatus;

//检测是否能保存
-(BOOL) checkCanSave;

@end
