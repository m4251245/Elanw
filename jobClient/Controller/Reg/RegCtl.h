//
//  RegCtlViewController.h
//  MBA
//
//  Created by sysweal on 13-11-12.
//  Copyright (c) 2013年 job1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"

#import "ExRequetCon.h"
#import "AgreementCtl.h"
#import "UserHYListCtl.h"

@class RegCtl;

@protocol RegisterOKDelegate <NSObject>

-(void)registerOK:(RegCtl*) ctl  username:(NSString*)uname  pwd:(NSString*)pwd;

@end


@interface RegCtl : BaseUIViewController<UITextFieldDelegate,UIGestureRecognizerDelegate,ChooseHYDelegate>
{
    UITapGestureRecognizer  *singleTapRecognizer_;
    
    RequestCon * saveInfoCon_;
    RequestCon * registerCon_;
    RequestCon * phoneCon_;
    User_DataModal * mydataModal_;
    NSString * sexStr;
    BOOL         bAccept_;
    
    AgreementCtl * agreementCtl_;
    UserHYListCtl * userHyListCtl_;
    
    IBOutlet UIImageView * phoneBg_;
    IBOutlet UIImageView * codeBg_;
    IBOutlet UIImageView * pswBg_;
    IBOutlet UIImageView * psw2Bg_;
    IBOutlet UIImageView * nameBg_;
    IBOutlet UIImageView * jobBg_;
    IBOutlet UIImageView * majorBg_;
    IBOutlet UIImageView * sexBg_;
    
    IBOutlet UIImageView * vLineImg1_;
    IBOutlet UIImageView * vLineImg2_;
    IBOutlet UIImageView * vLineImg3_;
    IBOutlet UIImageView * vLineImg4_;
    IBOutlet UIImageView * vLineImg5_;
    IBOutlet UIImageView * vLineImg6_;
    IBOutlet UIImageView * vLineImg7_;
    IBOutlet UIImageView * vLineImg8_;
    
    
}

@property(nonatomic,assign) id<RegisterOKDelegate> delegate_;
@property(nonatomic,unsafe_unretained)  IBOutlet    UITextField     *phoneTf_;
@property(nonatomic,unsafe_unretained)  IBOutlet    UIButton        *nextBtn_;
@property(nonatomic,unsafe_unretained)  IBOutlet    UIScrollView    *scrollView_;
@property(nonatomic,unsafe_unretained)  IBOutlet    UITextField     *passwordTf_;
@property(nonatomic,unsafe_unretained)  IBOutlet    UITextField     *pwdAgainTf_;
@property(nonatomic,unsafe_unretained)  IBOutlet    UIImageView     *step1Img_;
@property(nonatomic,unsafe_unretained)  IBOutlet    UIImageView     *step2Img_;
@property(nonatomic,unsafe_unretained)  IBOutlet    UIImageView     *step3Img_;
@property(nonatomic,unsafe_unretained)  IBOutlet    UITextField     *codeTf_;
@property(nonatomic,unsafe_unretained)  IBOutlet    UITextField     *majorTf_;
@property(nonatomic,unsafe_unretained)  IBOutlet    UIButton        *nextBtn2_;
@property(nonatomic,unsafe_unretained)  IBOutlet    UITextField     *nameTf_;
@property(nonatomic,unsafe_unretained)  IBOutlet    UITextField     *jobNameTf_;
@property(nonatomic,unsafe_unretained)  IBOutlet    UIButton        *boyBtn_;
@property(nonatomic,unsafe_unretained)  IBOutlet    UIButton        *girlBtn_;
@property(nonatomic,unsafe_unretained)  IBOutlet    UIButton        *okBtn_;
@property(nonatomic,unsafe_unretained)  IBOutlet    UIButton        *setAccept_;
@property(nonatomic,unsafe_unretained)  IBOutlet    UIButton        *checkAgreement_;
@property(nonatomic,unsafe_unretained)  IBOutlet    UIButton        *hyBtn_;

//注册手机
-(void) regestPhone;

//注册成功
-(void) regestOK;

//自己视图的单击事件
-(void) viewSingleTap:(id)sender;

//根据注册来源获取上传统计的字符串
+(NSString*)getRegTypeStr:(RegisteType)type;

@end
