//
//  BaseResumeCtl.h
//  jobClient
//
//  Created by job1001 job1001 on 12-2-6.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

/*********************************
        1.简历修改中的导航类
        2.简历基类
 *********************************/

#import <UIKit/UIKit.h>
#import "PreBaseUIViewController.h"
#import "PreRequestCon.h"
#import "PersonDetailInfo_DataModal.h"


//导航的种类
typedef enum {
    PreNullResume = -1,     //不起做用的设置
    
    BaseResumeInfo = 0,     //基本资料      (一定要等于0)
    WantResumeJob,          //...
    EduResume,
    WorksResume,
    IntroduceResume,
    SkillResume,
    CerResume,
    AwardResume,
    LeaderResume,
    ProjectResume,
    StudentInfoResume,
}ResumeNavIndex;


@class ResumeNavCtl;

@protocol ResumeNavChangeDelegate <NSObject>

@required
-(void) resumeNavHaveChange:(ResumeNavCtl *)resumeNavCtl index:(int)index;

@end

@interface ResumeNavCtl : PreBaseUIViewController {
    IBOutlet    UIScrollView            *scrollView_;           //滚动视图
    IBOutlet    UIView                  *lineView_;             //line view
    IBOutlet    UIImageView             *rowImageView_;         //row image view
    IBOutlet    UIButton                *baseInfoBtn_;          //基本资料
    IBOutlet    UIButton                *wantJobBtn_;           //求职意向
    IBOutlet    UIButton                *eduBtn_;               //教育背景
    IBOutlet    UIButton                *worksBtn_;             //工作经历
    IBOutlet    UIButton                *skillBtn_;             //工作技能
    IBOutlet    UIButton                *cerBtn_;               //证书管理
    IBOutlet    UIButton                *studentLeaderBtn_;     //担任学生干部经历
    IBOutlet    UIButton                *studentAwardBtn_;      //所获奖项经历
    IBOutlet    UIButton                *studentProjectBtn_;    //项目活动经历
    
    UIImage                             *hightImage_;
    UIImage                             *personInfoImage_On_;   //基本资料Image_On
    UIImage                             *personInfoImage_Off_;  //基本资料...
    UIImage                             *wantJobImage_On_;      //求职意向...
    UIImage                             *wantJobImage_Off_;     //求职意向...
    UIImage                             *eduImage_On_;          //...
    UIImage                             *eduImage_Off_;         //...
    UIImage                             *workImage_On_;         //...
    UIImage                             *workImage_Off_;        //...
    UIImage                             *skillImage_On_;        //...
    UIImage                             *skillImage_Off_;       //...
    UIImage                             *cerImage_On_;          //...
    UIImage                             *cerImage_Off_;         //...
    UIImage                             *awardImage_On_;
    UIImage                             *awardImage_Off_;
    UIImage                             *leaderImage_On_;
    UIImage                             *leaderImage_Off_;
    UIImage                             *projectImage_On_;
    UIImage                             *projectImage_Off_;
    
    ResumeNavIndex                      currentNavIndex_;       //当前导航索引
    ResumeNavIndex                      preNavIndex_;           //之前操作了的导航索引,不能直接用currentNavIndex_ - 1来获取
}

@property(nonatomic,assign) id<ResumeNavChangeDelegate>         delegate_;

@property(nonatomic,assign) ResumeNavIndex      currentNavIndex_;
@property(nonatomic,assign) ResumeNavIndex      preNavIndex_;

//获取当前的索引
-(int) getNavIndex;

//获取之前操作的索引(不能用currentNavIndex_ -1)
-(int) getPreNavIndex;

//获取之后的索引
-(int) getNextNavIndex;

//设置当前的索引
-(void) setNavIndex:(int)index;


//修改当前选中的导航按扭状态
-(void) changeNavBtnStatus;

@end

//简历中的数据有效期
#define BaseResumeCtl_ValidateSeconds       7*24*3600

@class BaseResumeCtl;
@protocol BaseResumeDelegate <NSObject>

-(void) resumeInfoChanged:(BaseResumeCtl *)ctl modal:(PersonDetailInfo_DataModal *)modal;

@end

@interface BaseResumeCtl : PreBaseUIViewController<ResumeNavChangeDelegate,UITextFieldDelegate,UITextViewDelegate> {
    IBOutlet    UIScrollView            *scrollView_;
    IBOutlet    UILabel                 *navContentLb_;
    IBOutlet    UIButton                *saveBtn_;
    IBOutlet    UIButton                *nextBtn_;
    
    PreRequestCon                          *PreRequestCon_Update_;    //数据连接类更新
    
    BOOL                                bHaveSave_;             //是否已经保存
    BOOL                                bHaveUpdateComData_;         //是否已经加载过数据
    
    CGSize                              scrollViewContentSize_; //scrollView原来的contentSize
}

@property(nonatomic,weak)   id<BaseResumeDelegate>  resumeDelegate_;

//获取简历导航Ctl
+(ResumeNavCtl*) getResumeNav;

-(void) changeSize;

//移动subObj到顶端,以便用户输入
-(void) autoMove:(UIView *)subObj;

//还原已经移动的size
-(void) recoverMoveSize;

//设置数据是否被加载过
-(void) setHaveUpdateComFlag:(BOOL)flag;

//注销
-(void) loginOff;

//保存
-(void) saveResume;

//让有焦点的控件失去焦点
-(void) comResignFirstResponse;

@end

//简历共享一个个人信息详情DataModal
extern PersonDetailInfo_DataModal  *personDetailInfoDataModal;
