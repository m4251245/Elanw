//
//  LoginCtl.h
//  MBA
//
//  Created by sysweal on 13-11-11.
//  Copyright (c) 2013年 job1001. All rights reserved.
//

/******************************
 
 登录类
 LoginCtl
 
 ******************************/
#import "BaseUIViewController.h"
#import "ExRequetCon.h"
#import "User_DataModal.h"
#import "EAIntroView.h"
#import "FindPasswordCtl.h"
#import "Login_DataModal.h"
#import "PreRequestCon.h"
#import "FindPwdCtl.h"
#import "RegPhoneCtl.h"
#import "MMLocationManager.h"
#import "WXApi.h"
//#import "WeiboSDK.h"

//${PRODUCT_NAME:rfc1034identifier}
@protocol ReLoginDelegate <NSObject>

-(void)reLogin;

@end

@interface LoginCtl:BaseUIViewController<UITextFieldDelegate,EAIntroDelegate,RegisterPhoneOKDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate>{
 
    
    
//    FindPwdCtl                  *findPwdCtl_;
    
    BOOL                        bPwdRember_;
    RequestCon                  *notificeCon_;
    FindPasswordCtl             *findPwdCtl_;    //邮箱找回密码
    RequestCon                  *initPushCon_;
    FindPwdCtl                  *findPhonePwdCtl_;  //手机找回密码
    
    UITapGestureRecognizer  *singleTapRecognizer_;  //单击的事件
//    IBOutlet    UIButton        *sinaLoginBtn_;
//    IBOutlet    UIButton        *qqLoginBtn_;
//    IBOutlet    UIButton        *weChatLoginBtn_;
    RequestCon                  *sinaDetectBindingCon_;
    RequestCon                  *qqDetectBindingCon_;
    RequestCon                  *wxDetectBindingCon_;
    RequestCon                  *bulidPersonCon_;
    User_DataModal              *userDataModel_;
    NSString                    *openId_;
    RequestCon                  *loginCon_;
    RequestCon                  *groupsCon_;
//    TencentOAuth                *_tencentOAuth;
    NSString                    *sinaAccessToken_;
    NSString                    *wxAccessToken_;
    NSString                    *wxCode_;
    NSString                    *wxOpenId_;
    User_DataModal              *tempModel_;
    IBOutlet                UIView  *userNameView_;
    IBOutlet                UIView  *passWordView_;
    IBOutlet                UILabel *tipsLb_;
    IBOutlet                UIView  *thirdView_;
    IBOutlet                UILabel *findPwdLb_;
    CGRect                  thridViewRect;
    BOOL                        qqLoginFlag_;
   
}

@property(nonatomic,weak) IBOutlet UITextField     *usernameTf_;
@property(nonatomic,weak) IBOutlet UITextField     *pwdTf_;
@property(nonatomic,weak) IBOutlet UIButton        *findPwdBtn_;
@property(nonatomic,weak) IBOutlet UILabel         *pwdRemberLb_;
@property(nonatomic,weak) IBOutlet UIButton        *pwdRemberBtn_;
@property(nonatomic,weak) IBOutlet UIButton        *regBtn_;
@property(nonatomic,weak) IBOutlet UIButton        *loginBtn_;
@property(nonatomic,strong) User_DataModal         *userDataModal_;
@property(nonatomic,weak) IBOutlet UIButton        *noLoginBtn_;

@property(nonatomic,assign) id<ReLoginDelegate>     delegate_;
@property(nonatomic,assign)  BOOL weChatLoginFlag_;

@property(nonatomic,assign) BOOL showBackBtn;

//登录
-(void) login:(int)status;

//注册
-(void) reg;

//随便看看
-(IBAction)visit:(id)sender;

-(void)registNotifice;

-(void)initPushSettings;

-(void)updateView;

//新浪第三方登录
-(void)sinaLoginMethod;
//QQ第三方登录
-(void)qqLoginMethod;
//微信第三方登录
- (void)weChatLoginMethod;

+ (NSString*)verifyLogin:(NSString*)userId checkCode:(NSString*)code;

@end
