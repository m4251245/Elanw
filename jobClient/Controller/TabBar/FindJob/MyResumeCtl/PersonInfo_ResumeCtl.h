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
#import "EditorPersonInfo.h"
#import "ELCountryICtl.h"
#import "ELIdTypeCtl.h"

@class New_PersonDataModel;

#define PersonInfo_ResumeCtl_Title              @"基本信息"
#define PersonInfo_ResumeCtl_Xib_Name           @"PersonInfo_ResumeCtl"

#define PersonInfo_Gz_Num_Max                   80      //工作年限的最大值
#define PersonInfo_Gz_Num_Min                   0       //工作年限的最小值

@protocol PersonInfo_ResumeCtlDelegate <NSObject>

- (void)personInfoChang;
-(void)backCtl;

@end

@interface PersonInfo_ResumeCtl : BaseResumeCtl<UITextFieldDelegate,CondictionChooseDelegate,/*ChooseHotCityDelegate,*/EditorPersonInfoDelegate,countryICtlDelegate,idTypeCtlDelegate,UIActionSheetDelegate> {
    
    
    BOOL showKeyBoard;
    CGFloat keyboarfHeight;
    UIView *viewTF;
    
    
    //必填
    IBOutlet    UITextField                     *nameTf_;//姓名
    __weak IBOutlet UIButton *sexBtn;//性别
    
    IBOutlet    UITextField                     *yearTf_;//工作年限
    
    __weak IBOutlet UIButton *roleBtn;//求职身份
    
    
    __weak IBOutlet UIButton *jobStatusBtn;//求职状态
    IBOutlet    UIButton                        *boyBtn_;
    IBOutlet    UIButton                        *girlBtn_;
    IBOutlet    UIButton                        *hightEduBtn_;
    IBOutlet    UIButton                        *placeOriginBtn_;   //籍贯
    IBOutlet    UIButton                        *birthBayBtn_;      //出生日期(年/月/日)
    IBOutlet    UITextField                     *cellPhoneTf_;//手机
    IBOutlet    UITextField                     *emailTf_;//邮箱
    IBOutlet    UIButton                        *addressBtn_;//现居地址
    
    __weak IBOutlet UIButton *countryBtn;//国籍
    
    
    IBOutlet    UIButton                        *marryBtn_;         //婚姻
    IBOutlet    UIButton                        *politicsBtn_;      //政治面貌
    IBOutlet    UIButton                        *nationBtn_;        //民族
    IBOutlet    UIButton                        *positionLevelBtn_; //现有职称等级
    
    IBOutlet    UILabel                     *nameLb_;
    IBOutlet    UILabel                     *yearLb_;
    IBOutlet    UILabel                        *boyLb_;
    IBOutlet    UILabel                        *girLb_;
    IBOutlet    UILabel                        *hightEduLb_;
    IBOutlet    UILabel                        *placeOriginLb_;   //籍贯
    IBOutlet    UILabel                        *birthBayLb_;      //出生日期(年/月/日)
    IBOutlet    UILabel                     *cellPhoneLb_;
    IBOutlet    UILabel                     *emailLb_;
    IBOutlet    UILabel                        *addressLb_;
    IBOutlet    UILabel                        *marryLb_;         //婚姻
    IBOutlet    UILabel                        *politicsLb_;      //政治面貌
    IBOutlet    UILabel                        *nationLb_;        //民族
    __weak IBOutlet UIButton *idTypeBtn;//证件类型
    
    __weak IBOutlet UITextField *idNumField;//证件号码
    
    __weak IBOutlet UITextField *heightField;//身高
    
    __weak IBOutlet UITextField *weightField;//体重
    
    
    __weak IBOutlet UIButton *salaryBtn;//薪水
    
    IBOutlet    UILabel                        *positionLevelLb_; //现有职称等级
    
    __weak IBOutlet UILabel *sexLb;
    
    __weak IBOutlet UILabel *roleLb;
    
    __weak IBOutlet UILabel *jobStatusLb;
    
    __weak IBOutlet UILabel *countryLb;
    
    __weak IBOutlet UILabel *idTypeLb;
    
    __weak IBOutlet UILabel *idNumLb;
    
    __weak IBOutlet UILabel *heightLb;
    
    __weak IBOutlet UILabel *weightLb;
    
    
    __weak IBOutlet UILabel *salaryLb;
    
    __weak IBOutlet UIView *salaryView;
    
    
    
    SexState                                    sexState_;
    NSString                                    *edu_;
    NSString                                    *hka_;
    NSString                                    *birthday_;
    NSString                                    *nowRegionId_;
    NSString                                    *zcheng_;
    NSString                                    *marray_;
    NSString                                    *zzmm_;
    
    NSString                                    *role;
    NSString                                    *jobStatus;
    NSString                                    *country;
    NSString                                    *idType;
    NSString                                    *idNum;
    NSString                                    *height;
    NSString                                   *weight;
    NSString                                   *salary;
    NSString                                   *jobStatus1;
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
//    CondictionList_DataModal                    *sexDataModal_;             //性别data
//    CondictionList_DataModal                    *roleDataModal_;            //求职身份data
    
}
@property(nonatomic,strong)New_PersonDataModel * personVO;
@property(nonatomic,weak) id <PersonInfo_ResumeCtlDelegate> delegate;

@property(nonatomic, copy) void (^myBlock)(NSString *str);

//更改性别按扭状态
-(void) changeSexBtnStatus;

//检测是否能保存
-(BOOL) checkCanSave;

@end
