//
//  LoginCtl.m
//  MBA
//
//  Created by sysweal on 13-11-11.
//  Copyright (c) 2013年 job1001. All rights reserved.
//

#import "LoginCtl.h"
#import "AssociationAppDelegate.h"
#import "RegWelcomeCtl.h"
#import <UMSocialCore/UMSocialCore.h>
#import "RegPhoneInputCtl.h"
#import "objc/runtime.h"
#import "ELBaseNavigationController.h"
#import "BindCtl.h"
#import "RegInfoOneCtl.h"
#import "PreCommon.h"
#import "RootTabBarViewController.h"


#import "ELNewNewsListVO.h"
#import "ELNewNewsInfoVO.h"
#import "ELNewsListDAO.h"

@interface LoginCtl () <RegisterSuccessDelegate>
{
    int status_;   //区分是否为推送时的自动登录
    RequestCon *_validUserNameCon;
    //    __weak IBOutlet UIButton *backBtn;
    UIButton       *sinaLoginBtn_;
    UIButton       *qqLoginBtn_;
    UIButton       *weChatLoginBtn_;
    UIButton       *backBtn;
    BOOL           isThirdFirstLogin;
    User_DataModal * sendDataModal;
}
@property (weak, nonatomic) IBOutlet UIButton *isShowPassWordBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginLogoToTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userNameToTop;
@end

@implementation LoginCtl

@synthesize usernameTf_,pwdTf_,findPwdBtn_,regBtn_,pwdRemberBtn_,pwdRemberLb_,loginBtn_,userDataModal_,noLoginBtn_,delegate_,weChatLoginFlag_;

#pragma mark - LifeCycle
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RegistSuccess" object:nil];
    NSLog(@"%s",__func__);
}

-(id) init
{
    self = [super init];
    tempModel_ = [[User_DataModal alloc]init];
    //self.navigationController.navigationBarHidden = YES;
    [MyCommon getUUID];
    _showBackBtn = YES;
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //增加键盘事件的通知 
    }
    return self;
}
-(BOOL)fd_prefersNavigationBarHidden{
    return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self setFd_prefersNavigationBarHidden:YES];
    if([Manager shareMgr].showLoginBackBtn)
    {
        backBtn.hidden = NO;
        [noLoginBtn_ setHidden:YES];
    }
    else
    {
        backBtn.hidden = YES;
        [noLoginBtn_ setHidden:NO];
    }
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //    时时输入监听
    [usernameTf_ addTarget:self action:@selector(updateLogInButton) forControlEvents:UIControlEventEditingChanged];
    [pwdTf_ addTarget:self action:@selector(updateLogInButton) forControlEvents:UIControlEventEditingChanged];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"icon_nav_bar_f05f5f.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc]init];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0xe13e3e);
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self setFd_prefersNavigationBarHidden:NO];
    [super viewWillDisappear:animated];
    backBtn.hidden = YES;
    [Manager shareMgr].showLoginBackBtn  = NO;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}


#pragma mark--初始化UI
- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self setNavTitle:@"登录"];
    
//设置placeholder
    [self addNotify];
    [self loginAndPwdTxtSetting];
    if (ScreenHeight == 480) {
        _loginLogoToTop.constant = 44;
        _userNameToTop.constant = 24;
    }
    else{
        _loginLogoToTop.constant = 74;
        _userNameToTop.constant = 44;
    }
    
    pwdTf_.tintColor = UIColorFromRGB(0x00aeff);
    usernameTf_.tintColor = UIColorFromRGB(0x00aeff);
    
    
//三方登录UI
    [self configThirdLoginUI];

    loginBtn_.layer.cornerRadius = 3.0;
    loginBtn_.layer.borderWidth = 0.5;
    loginBtn_.layer.borderColor =[UIColor colorWithRed:227/255.0 green:15.0/255.0 blue:25.0/255.0 alpha:1.0].CGColor;
    regBtn_.backgroundColor = [UIColor whiteColor];
    loginBtn_.backgroundColor = UIColorFromRGB(0xf85656);

    pwdRemberLb_.userInteractionEnabled = YES;
    [MyCommon addTapGesture:pwdRemberLb_ target:self numberOfTap:1 sel:@selector(singleTap:)];
    
    usernameTf_.delegate = self;
    pwdTf_.delegate = self;
    
    NSString *flag = [[NSUserDefaults standardUserDefaults] valueForKey:Config_Key_RemberPwd];
    if( !flag ){
        bPwdRember_ = YES;
    }else{
        bPwdRember_ = [flag boolValue];
        
        if( bPwdRember_ ){
            [pwdRemberBtn_ setBackgroundImage:[UIImage imageNamed:@"rememberPSW2@2x"] forState:UIControlStateNormal];
        }else{
            [pwdRemberBtn_ setBackgroundImage:[UIImage imageNamed:@"rememberPSW@2x"] forState:UIControlStateNormal];
        }
    }
    NSString *userName = [CommonConfig getDBValueByKey:Config_Key_User];
    if (userName && ![userName isEqualToString:@"(null)"]) {
        usernameTf_.text = userName;
    }
    if( bPwdRember_ )
        pwdTf_.text = [CommonConfig getDBValueByKey:Config_Key_Pwd];
    
    
    
    if (!backBtn) {
        backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(7, 8, 44, 44);
        [backBtn setImage:[UIImage imageNamed:@"login_close@2x.png"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:backBtn];
    }
}

//三方登录UI
-(void)configThirdLoginUI{
    //现在默认有扣扣和新浪
    qqLoginFlag_ = YES;//[QQApiInterface isQQInstalled];
    weChatLoginFlag_ = [WXApi isWXAppInstalled];
    
    UIView *thirdBgView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 140, ScreenWidth, 56)];
    [self.view addSubview:thirdBgView];
    qqLoginBtn_ = [UIButton buttonWithType:UIButtonTypeCustom];
    weChatLoginBtn_ = [UIButton buttonWithType:UIButtonTypeCustom];
    sinaLoginBtn_ = [UIButton buttonWithType:UIButtonTypeCustom];
    
    NSArray *btnThirdArr;
    int shareCount = 0;
    //判断有几种第三方登录
    if (weChatLoginFlag_) {
        shareCount = 3;
        weChatLoginBtn_.hidden = NO;
        btnThirdArr = @[qqLoginBtn_,weChatLoginBtn_,sinaLoginBtn_];
    }else if (!weChatLoginFlag_){
        shareCount = 2;
        weChatLoginBtn_.hidden = YES;
        btnThirdArr = @[qqLoginBtn_,sinaLoginBtn_];
    }
    for (int i = 0; i < btnThirdArr.count; i++) {
        //设定按钮和间隔大小相等
        CGFloat btnWidth = ScreenWidth / (btnThirdArr.count * 2 + 1);
        UIButton *btn = (UIButton *)btnThirdArr[i];
        btn.frame = CGRectMake(0, 0, 52, 52);
        btn.center = CGPointMake(btnWidth/2 + btnWidth * (i * 2 + 1), 26);
    }
    
    [weChatLoginBtn_ setImage:[UIImage imageNamed:@"login_weixin@2x.png"] forState:UIControlStateNormal];
    [weChatLoginBtn_ setImage:[UIImage imageNamed:@"login_weixin_click@2x" ] forState:UIControlStateHighlighted];
    [qqLoginBtn_ setImage:[UIImage imageNamed:@"login_qq@2x.png"] forState:UIControlStateNormal];
    [qqLoginBtn_ setImage:[UIImage imageNamed:@"login_qq_click@2x" ] forState:UIControlStateHighlighted];
    [sinaLoginBtn_ setImage:[UIImage imageNamed:@"login_weibo@2x.png"] forState:UIControlStateNormal];
    [sinaLoginBtn_ setImage:[UIImage imageNamed:@"login_weibo_click@2x" ] forState:UIControlStateHighlighted];
    
    [qqLoginBtn_ addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
    [weChatLoginBtn_ addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
    [sinaLoginBtn_ addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
    [thirdBgView addSubview:qqLoginBtn_];
    [thirdBgView addSubview:weChatLoginBtn_];
    [thirdBgView addSubview:sinaLoginBtn_];
}


-(void)updateView
{
    NSString *flag = [[NSUserDefaults standardUserDefaults] valueForKey:Config_Key_RemberPwd];
    if( !flag ){
        bPwdRember_ = YES;
    }else{
        bPwdRember_ = [flag boolValue];
        
        if( bPwdRember_ ){
            [pwdRemberBtn_ setBackgroundImage:[UIImage imageNamed:@"rememberPSW2@2x"] forState:UIControlStateNormal];
        }else{
            [pwdRemberBtn_ setBackgroundImage:[UIImage imageNamed:@"rememberPSW@2x"] forState:UIControlStateNormal];
        }
    }
    
    usernameTf_.text = [CommonConfig getDBValueByKey:Config_Key_User];
    pwdTf_.text = @"";
}

//登录
-(void) login:(int)status
{
    if (!sendDataModal) {
        if( [usernameTf_.text length] == 0 ){
            [BaseUIViewController showAlertView:nil msg:@"用户名不能为空" btnTitle:@"确定"];
            [loginBtn_ setUserInteractionEnabled:YES];
            [usernameTf_ becomeFirstResponder];
            
            return;
        }else if( [pwdTf_.text length] == 0 ){
            [BaseUIViewController showAlertView:nil msg:@"密码不能为空" btnTitle:@"确定"];
            [loginBtn_ setUserInteractionEnabled:YES];
            [pwdTf_ becomeFirstResponder];
            return;
        }
    }
    [usernameTf_ resignFirstResponder];
    [pwdTf_ resignFirstResponder];
    status_ = status;
    [self beginLoad:nil exParam:nil];
}

//注册
-(void) reg
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    if (IOS8) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    }
    RegWelcomeCtl * regWelcomeCtl = [[RegWelcomeCtl alloc] init];
    NSString *userName = [usernameTf_.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([userName isMobileNumValid]) {
        regWelcomeCtl.phone = userName;
    }
    regWelcomeCtl.successDelegate = self;
    [self.navigationController pushViewController:regWelcomeCtl animated:YES];
}

-(void)refreshDelegateWithPhone:(NSString *)phone passWord:(NSString *)passWord{
    usernameTf_.text = phone;
    pwdTf_.text = passWord;
    [self login:0];
}

#pragma mark--网络请求
#pragma mark - NetWork
-(void) getDataFunction:(RequestCon *)con
{
    //[con getAccessToken:@"iphone" pwd:@"123" time:[NSDate timeIntervalSinceReferenceDate]];
    [Manager shareMgr].isThridLogin_ = NO;
    if (!_validUserNameCon) {
        _validUserNameCon = [self getNewRequestCon:NO];
    }
    [_validUserNameCon doValidUserName:usernameTf_.text];
    
    //[[Manager shareMgr] getCity];
}

//error get data
-(void) errorGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type
{
    [super errorGetData:requestCon code:code type:type];
    [loginBtn_ setUserInteractionEnabled:YES];
    if (code == No_Internet_Error && type == Request_ValidUserName) {
        [BaseUIViewController showAlertView:nil msg:@"登录失败，请检查网络是否正常" btnTitle:@"确定"];
        return;
    }
}


-(void) finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    //__weak typeof(self) weakSelf = self;

    if (dataArr.count == 0) {
        return;
    }

    switch ( type ) {
        case Request_Login:
        {
            
            User_DataModal *dataModal = [dataArr objectAtIndex:0];
            
            if( [dataModal.code_ isEqualToString:Success_Code] ){
                NSString * userId = [CommonConfig getDBValueByKey:Config_Key_UserID];
                if (!userId || ![userId isEqualToString:dataModal.userId_]) {
                    [Manager shareMgr].bAccountChanged_ = YES;
                }
                
                
                
                //将配置写入数据库中
                NSString * verifyStr = [LoginCtl verifyLogin:dataModal.userId_ checkCode:CheckCode_Login];
                
                [CommonConfig setDBValueByKey:Config_Key_RemberPwd value:@"1"];
                [CommonConfig setDBValueByKey:Config_Key_VerifyUserID value:verifyStr];
                [CommonConfig setDBValueByKey:Config_Key_User value:usernameTf_.text];
                [CommonConfig setDBValueByKey:Config_Key_Pwd value:pwdTf_.text];
                [CommonConfig setDBValueByKey:Config_Key_CheckLogin value:@"1"];
                [CommonConfig setDBValueByKey:Config_Key_UserID value:dataModal.userId_];
                [CommonConfig setDBValueByKey:Config_Key_UserName value:dataModal.name_];
                [CommonConfig setDBValueByKey:Config_Key_UserImg value:dataModal.img_];
                [CommonConfig setDBValueByKey:Config_Key_UserPrnd value:dataModal.prnd_];
                [CommonConfig setDBValueByKey:Config_Key_UserSex value:dataModal.sex_];
                [CommonConfig setDBValueByKey:@"groupCreaterCnt" value:[NSString stringWithFormat:@"%ld",(long)dataModal.groupsCreateCnt_]];
                [CommonConfig setDBValueByKey:@"schoolName" value:dataModal.school_];
                [CommonConfig setDBValueByKey:@"nickName" value:dataModal.nickname_];
                [CommonConfig setDBValueByKey:@"zye" value:dataModal.zye_];
                [CommonConfig setDBValueByKey:@"hka" value:dataModal.hka_];
                [CommonConfig setDBValueByKey:@"jobNow" value:dataModal.job_];   //职位
                [CommonConfig setDBValueByKey:@"tradeName" value:dataModal.tradeName]; //行业名
                [CommonConfig setDBValueByKey:@"tradeId" value:dataModal.tradeId];//行业ID
                [CommonConfig setDBValueByKey:@"intentionJob" value:dataModal.tradeId];//意向职位
                [CommonConfig setDBValueByKey:@"shouji" value:dataModal.mobile_];
                [CommonConfig setDBValueByKey:@"followCnt" value:[NSString stringWithFormat:@"%ld",(long)dataModal.followCnt_]];
                if (dataModal.isExpert_) {
                    [CommonConfig setDBValueByKey:@"isExpert" value:[NSString stringWithFormat:@"%d",1]];
                }else{
                    [CommonConfig setDBValueByKey:@"isExpert" value:[NSString stringWithFormat:@"%d",0]];
                }
                [CommonConfig setDBValueByKey:@"rctype" value:dataModal.role_];
                
                userDataModal_ = [dataArr objectAtIndex:0];
                userDataModal_.uname_ = usernameTf_.text;
                
                //设置一下登录信息
                [Manager setUserInfo:userDataModal_];
                
                
                //保存第三方登录标识
                if ([Manager shareMgr].isThridLogin_) {
                    [CommonConfig setDBValueByKey:@"isThridLogin" value:dataModal.userId_];
                    if ((!dataModal.tradeId || [dataModal.tradeId isEqualToString:@"1000"] || [dataModal.tradeId isEqualToString:@""] ||[dataModal.tradeId isEqualToString:@"0"]) && ([dataModal.tradeName isEqualToString:@""] || !dataModal.tradeName || [dataModal.tradeName isEqualToString:@"一览"])) {//第三方登录提示用户完善行业／职业信息  1000表示默认
                    
//                         信息未完善时候使用
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"showTip"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                    #if 0
                        NSString *thirdlogin = [NSString stringWithFormat:@"%@_isNeedShow",[CommonConfig getDBValueByKey:Config_Key_UserID]];
                        NSInteger isShow = [[NSUserDefaults standardUserDefaults] integerForKey:thirdlogin];
                        isShow++;
                        [[NSUserDefaults standardUserDefaults] setInteger:isShow forKey:thirdlogin];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    #endif
                    }
                    NSString * isThirdLoginNum = getUserDefaults(@"isThirdComplete");
                    if([isThirdLoginNum isEqualToString:@"2"] && [dataModal.is_bindshouji isEqualToString:@"1"] ){
                        [self bindingPhone:dataModal];
                    }
                    else{
                        [self loginRequest];
                        [BaseUIViewController showAutoDismissAlertView:@"登录成功" msg:nil seconds:1.0];

                    }
                }else{
                    [CommonConfig setDBValueByKey:@"isThridLogin" value:@""];
                    [self loginRequest];
                    [BaseUIViewController showAutoDismissAlertView:@"登录成功" msg:nil seconds:1.0];

                }

                if( !bPwdRember_ ){
                    pwdTf_.text = @"";
                }
                
//                //保存第三方登录标识
//                if ([Manager shareMgr].isThridLogin_) {
//                    [CommonConfig setDBValueByKey:@"isThridLogin" value:dataModal.userId_];
//                }else{
//                    [CommonConfig setDBValueByKey:@"isThridLogin" value:@""];
//                }
//                
//                if( !bPwdRember_ ){
//                    pwdTf_.text = @"";
//                }
                //#warning test
                //                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"showTip"];
                //                [[NSUserDefaults standardUserDefaults] synchronize];

                //请求社群数量
                [Manager getRequestCanCreatGroupCountWith:[Manager getUserInfo].userId_];
                
                [[Manager shareMgr] requestToken];
//                if (!groupsCon_) {
//                    groupsCon_ = [self getNewRequestCon:NO];
//                }
//                [groupsCon_ getGroupsCount:[Manager getUserInfo].userId_];
                
                //获取简历信息
                Login_DataModal *loginModal = [[Login_DataModal alloc] init];
                loginModal.personId_ = dataModal.userId_;
                loginModal.updateTime_ = [Common getCurrentDateTime];
                loginModal.iname_ = dataModal.name_;
                loginModal.pic_ = dataModal.img_;
                loginModal.prnd_ = dataModal.prnd_;
                loginModal.uname_ = dataModal.uname_;
                [PreRequestCon setLoginDataModal:loginModal];
                
                
                //极光
                //                [APService setTags:[NSSet setWithObjects:userDataModal_.userId_,nil] alias:userDataModal_.userId_ callbackSelector:@selector(tagsAliasCallback:tags:alias:) target:self];
                
    
                [ELJPush bindAlias:userDataModal_.userId_];
                
                [delegate_ reLogin];
                [Manager shareMgr].haveLogin = YES;
                
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGINSUCCESS" object:self];
                if (status_ == 181) {
                    [[Manager shareMgr] haveReLogin:181];
                }
                else if (status_ == 180){
                    [[Manager shareMgr] haveReLogin:180];
                }
                else if (status_ == 190){
                    [[Manager shareMgr] haveReLogin:190];
                }
                else if(status_ == 200){
                    [[Manager shareMgr] haveReLogin:200];
                }
                else{
                    [[Manager shareMgr] haveReLogin:1];
                }
//                [BaseUIViewController showAutoDismissAlertView:@"登录成功" msg:nil seconds:1.0];
                [self requestNewsLists];
            }else{
                [BaseUIViewController showAutoDismissFailView:nil msg:@"密码错误"];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"openWebSocket" object:nil];
            
        }
            break;
        case Request_SetSubscribeConfig:
        {
            Status_DataModal * datamodal = [dataArr objectAtIndex:0];
            if( ![datamodal.status_ isEqualToString:Success_Status] )
            {
                //NSString *errorMsg = [NSString stringWithFormat:@"推送功能设置失败,您的推送功能可能暂无法使用\n失败详情:%@",datamodal.des_];
                //[BaseUIViewController showAlertView:errorMsg msg:nil btnTitle:@"确定"];
                
            }
        }
            break;
        case Request_DetectBinding:
        {
            Status_DataModal *model = [dataArr objectAtIndex:0];
            [[NSUserDefaults standardUserDefaults] setObject:model.is_binding forKey:@"isThirdComplete"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if ([model.status_ isEqualToString:@"FAIL"]) {
                //账号不存在，先去获取用户信息
                if (requestCon == qqDetectBindingCon_) {
                    if (!bulidPersonCon_) {
                        bulidPersonCon_ = [self getNewRequestCon:NO];
                    }
                    [bulidPersonCon_ bulidPersonWithConnectSource:@"qq" openId:tempModel_.identity_ userName:tempModel_.nickname_ nickName:tempModel_.nickname_ sex:tempModel_.sex_  picSmall:tempModel_.img_ picMiddle:tempModel_.img_ picOriginal:tempModel_.img_];
                }else if(requestCon == sinaDetectBindingCon_){
                    if (!bulidPersonCon_) {
                        bulidPersonCon_ = [self getNewRequestCon:NO];
                    }
                    [bulidPersonCon_ bulidPersonWithConnectSource:@"sina_weibo" openId:tempModel_.identity_ userName:tempModel_.nickname_ nickName:tempModel_.nickname_ sex:tempModel_.sex_ picSmall:tempModel_.img_ picMiddle:tempModel_.img_ picOriginal:tempModel_.img_];
                }else if (requestCon == wxDetectBindingCon_){
                    if (!bulidPersonCon_) {
                        bulidPersonCon_ = [self getNewRequestCon:NO];
                    }
                    [bulidPersonCon_ bulidPersonWithConnectSource:@"wechat" openId:tempModel_.identity_ userName:tempModel_.nickname_ nickName:tempModel_.nickname_ sex:tempModel_.sex_ picSmall:tempModel_.img_ picMiddle:tempModel_.img_ picOriginal:tempModel_.img_];
                }
            }else if([model.status_ isEqualToString:@"OK"]){
                NSMutableArray *userArray = [model.exObjArr_ mutableCopy];
                if (!loginCon_) {
                    loginCon_ = [self getNewRequestCon:NO];
                }
                //第三方
                [Manager shareMgr].isThridLogin_ = YES;
                [loginCon_ doLogin:[userArray objectAtIndex:0] pwd:[userArray objectAtIndex:1]];
            }
        }
            break;
        case Request_BuildPerson:
        {
//            isThirdFirstLogin = YES;
            
            Status_DataModal *model = [dataArr objectAtIndex:0];
            NSMutableArray *userArray = [model.exObjArr_ mutableCopy];
            if (!loginCon_) {
                loginCon_ = [self getNewRequestCon:NO];
            }
            //第三方
            [Manager shareMgr].isThridLogin_ = YES;
            [loginCon_ doLogin:[userArray objectAtIndex:0] pwd:[userArray objectAtIndex:1]];
        }
            break;
        case Request_GetGroupsCount:
        {
            NSDictionary *dic = [dataArr objectAtIndex:0];
//            NSString *totalCnt = [dic objectForKey:@"totalCnt"];
//            NSString *createCnt = [dic objectForKey:@"createCnt"];
            NSString *remainCnt = [dic objectForKey:@"remainCnt"];
            if (remainCnt && ![remainCnt isEqualToString:@""]) {
                [Manager shareMgr].groupCount_ = remainCnt;
            }else{
                [Manager shareMgr].groupCount_ = @"";
            }
            [CommonConfig setDBValueByKey:@"groupsCount" value:[Manager shareMgr].groupCount_];
        }
            break;
        case Request_ValidUserName://验证用户名
        {
            Status_DataModal *model = [dataArr objectAtIndex:0];
            if ([model.status_ isEqualToString:Success_Status]) {
                [requestCon_ doLogin:usernameTf_.text pwd:pwdTf_.text];
            }else{
                [self showChooseAlertView:20 title:@"" msg:@"当前账号暂未注册，是否注册" okBtnTitle:@"取消" cancelBtnTitle:@"注册"];
            }
            [loginBtn_ setUserInteractionEnabled:YES];
            
        }
            break;
        default:
            break;
    }
}


#pragma mark--请求消息列表
-(void)requestNewsLists{
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    //[conditionDic setObject:@"pageList" forKey:@"allList"];
    [conditionDic setObject:@"1" forKey:@"init"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionDicStr = [jsonWriter stringWithObject:conditionDic];
    NSString * bodyMsg = [NSString stringWithFormat:@"personId=%@&conditionArr=%@",[Manager getUserInfo].userId_,conditionDicStr];
    NSString *op = @"message_app_busi";
    NSString *function = @"getMessageList";
    [ELRequest newPostbodyMsg:bodyMsg op:op func:function tokenType:AccessTokenTypeFour userName:@"message" pwd:@"message889900" modelType:[Manager shareMgr].accessTokenFourModal serviceURL:NewSeviceURL version:New_Request_Version requestVersion:YES progressFlag:NO progressMsg:nil success:^(NSURLSessionDataTask *operation, id result) {
        NSDictionary *dic = result;
        NSArray *typeArr = @[@"sys_msg",@"group_msg",@"comment_msg",@"article_msg",@"follow_msg",@"praise_msg",@"yuetan_msg",@"dashang_msg",@"private_msg",@"oa_msg",@"group_chat_msg",@"spec_private_msg"];
        
        id arr = [dic objectForKey:@"data"];
        NSMutableArray *allDatas = [NSMutableArray array];
        if ([arr isKindOfClass:[NSArray class]]) {
            if ([arr count] > 0) {
                for (NSDictionary *subDic in arr) {
                    if ([subDic[@"title"] isKindOfClass:[NSString class]] && [subDic[@"content"] isKindOfClass:[NSString class]]) {
                        if (!([subDic[@"title"] length] > 0 || [subDic[@"content"] length] > 0)) {
                            continue;
                        }
                    }
                    else{
                        continue;
                    }
                    
                    ELNewNewsListVO *newInfoVO = [ELNewNewsListVO new];
                    [newInfoVO setValuesForKeysWithDictionary:subDic];
                    ELNewNewsInfoVO *infovo = newInfoVO.info;
                    if (infovo.newsInfoId.length > 0) {
                        newInfoVO.infoId = infovo.newsInfoId;
                    }
                    else{
                        newInfoVO.infoId = @"";
                    }
                    if (infovo.action.length > 0) {
                        newInfoVO.action = infovo.action;
                    }
                    else{
                        newInfoVO.action = @"";
                    }
                    if (infovo.all_cnt) {
                        newInfoVO.all_cnt = infovo.all_cnt;
                    }
                    else{
                        newInfoVO.all_cnt = @(10000);
                    }
                    newInfoVO.personId = [Manager getUserInfo].userId_;
                    if ([typeArr containsObject:newInfoVO.type]) {
                        [allDatas addObject:newInfoVO];
                    }

                }
            }
        }
        
        
        ELNewsListDAO *DAO = [ELNewsListDAO new];
        if (allDatas.count > 0) {
            for (ELNewNewsListVO *vo in allDatas) {
                if ([vo.info isKindOfClass:[NSObject class]]) {
                    NSDictionary *dic = [vo.info dictionaryFromModel];
                    NSError *parseError = nil;
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
                    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    vo.jsonStr = jsonStr;
                }
                else{
                    vo.jsonStr = @"";
                }
            }
            [DAO updateData:allDatas];
        }
        
        NSArray *allDataBaseArr = [DAO showAll:[Manager getUserInfo].userId_];
        NSInteger allNum = 0;
        if (allDataBaseArr.count > 0) {
            for (ELNewNewsListVO *vo in allDataBaseArr) {
                NSInteger num = [vo.cnt integerValue];
                allNum += num;
            }
            kUserDefaults(@(allNum), kAllNums);
            kUserSynchronize;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"msgNewsNum" object:nil userInfo:nil];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"-----------%@",error);
    }];
}

#pragma mark--代理
//ios5 中的bug
#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isMemberOfClass:[UIButton class]]||[touch.view isMemberOfClass:[UITextField class]]) {
        //放过button和textfield点击拦截
        return NO;
    }else{
        return YES;
    }
    
}

#pragma UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //记录友盟统计模块使用数
    NSString * fun = @"";
    if ([Manager shareMgr].registeType_ == FromNotKnown) {
        fun = @"启动找回密码";
    }
    else{
        fun = @"非启动找回密码";
    }
    NSDictionary * dict = @{@"Function":fun};
    [MobClick event:@"personused" attributes:dict];
    
    switch ( buttonIndex ) {
        case 0:
        {
            if( !findPwdCtl_ ){
                findPwdCtl_ = [[FindPasswordCtl alloc] init];
            }
            
            [self.navigationController pushViewController:findPwdCtl_ animated:YES];
            [findPwdCtl_ beginLoad:nil exParam:nil];
        }
            break;
            
        case 1:
        {
            if (!findPhonePwdCtl_) {
                findPhonePwdCtl_ = [[FindPwdCtl alloc] init];
            }
            [self.navigationController pushViewController:findPhonePwdCtl_ animated:YES];
            [findPhonePwdCtl_ beginLoad:nil exParam:nil];
        }
            
            break;
        default:
            break;
    }
}

//未注册时候点击注册
-(void) alertViewCancel:(UIAlertView *)alertView index:(int)index type:(int)type{
    if (type == 20) {
        //[self goRegist:NO];
        [self reg];
    }
}

#pragma mark - UITextFieldDelegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if( textField == usernameTf_ ){
        [pwdTf_ becomeFirstResponder];
    }else{
        [self login:0];
        [textField resignFirstResponder];
        
    }
    
    return YES;
}

#pragma mark--通知
-(void)addNotify{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registSuccess:) name:@"RegistSuccess" object:nil];
}


#pragma mark - Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    if( !singleTapRecognizer_ )
        singleTapRecognizer_ = [MyCommon addTapGesture:self.view target:self numberOfTap:1 sel:@selector(viewSingleTap:)];
    singleTapRecognizer_.delegate = self;
    
    if (ScreenHeight == 568) {
        [UIView animateWithDuration:0.2 animations:^{
            _loginLogoToTop.constant = 54;
        }];
    }
    else if(ScreenHeight == 480){
        [UIView animateWithDuration:0.2 animations:^{
            _loginLogoToTop.constant = 24;
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [MyCommon removeTapGesture:self.view ges:singleTapRecognizer_];
    singleTapRecognizer_ = nil;
    
    if (ScreenHeight == 568) {
        [UIView animateWithDuration:0.2 animations:^{
            _loginLogoToTop.constant = 74;
        }];
    }
    else if(ScreenHeight == 480){
        [UIView animateWithDuration:0.2 animations:^{
            [UIView animateWithDuration:0.2 animations:^{
                _loginLogoToTop.constant = 44;
            }];
        }];
    }
}

//注册成功后的通知
-(void)registSuccess:(NSNotification*)notification{
    sendDataModal = [User_DataModal new];
    sendDataModal = notification.userInfo[@"key"];
    usernameTf_.text = sendDataModal.uname_;
    pwdTf_.text = sendDataModal.pwd_;
}

-(void)registNotifice
{
    if (!notificeCon_) {
        notificeCon_ = [self getNewRequestCon:NO];
    }
    NSString * userId ;
    if (![Manager getUserInfo].userId_||[[Manager getUserInfo].userId_ isEqual:[NSNull null]]) {
        userId = @"";
    }
    else
    {
        userId = [Manager getUserInfo].userId_;
    }
    [notificeCon_ setSubscribeConfig:MyClientName clientVersion:ClientVersion deviceId:[Common getUUID] deviceToken:[MyCommon getTokenStr] flagStr:@"1" startHour:@"" endHour:@"" betweenHour:@"" userId:userId];
}


#pragma mark--事件
//自己视图的单击事件
-(void) viewSingleTap:(id)sender
{
    [usernameTf_ resignFirstResponder];
    [pwdTf_ resignFirstResponder];
}

// 点击记住密码label响应事件
-(void) singleTap:(id)sender
{
    bPwdRember_ = !bPwdRember_;
    
    if( bPwdRember_ ){
        [pwdRemberBtn_ setBackgroundImage:[UIImage imageNamed:@"rememberPSW2@2x"] forState:UIControlStateNormal];
    }else{
        [pwdRemberBtn_ setBackgroundImage:[UIImage imageNamed:@"rememberPSW@2x"] forState:UIControlStateNormal];
    }
}

//监听密码输入，改变登录按钮状态
-(void)updateLogInButton{
    if (usernameTf_.text.length > 0 && pwdTf_.text.length > 0) {
        loginBtn_.enabled = YES;
        [loginBtn_ setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    }
    else{
        loginBtn_.enabled = NO;
        [loginBtn_ setTitleColor:UIColorFromRGB(0xffbebe) forState:UIControlStateNormal];
    }
}

-(void) btnResponse:(id)sender
{
    //记住密码
    if( sender == pwdRemberBtn_ ){
        
        bPwdRember_ = !bPwdRember_;
        
        if( bPwdRember_ ){
            [pwdRemberBtn_ setBackgroundImage:[UIImage imageNamed:@"rememberPSW2@2x"] forState:UIControlStateNormal];
        }else{
            [pwdRemberBtn_ setBackgroundImage:[UIImage imageNamed:@"rememberPSW@2x"] forState:UIControlStateNormal];
        }
    }
    //找回密码
    else if( sender == findPwdBtn_ ){
        
        [usernameTf_ resignFirstResponder];
        [pwdTf_ resignFirstResponder];
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"邮箱账号找回密码",@"手机账号找回密码",nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:self.view];
        
    }
    //登录
    else if( sender == loginBtn_ ){
        
        //记录友盟统计模块使用数
        NSString * fun = @"";
        if ([Manager shareMgr].registeType_ == FromNotKnown) {
            fun = @"启动登录";
        }
        else{
            fun = @"非启动登录";
        }
        NSDictionary * dict = @{@"Function":fun};
        [MobClick event:@"personused" attributes:dict];
        [loginBtn_ setUserInteractionEnabled:NO];
        [self login:0];
        
    }
    //注册
    else if( sender == regBtn_ ){
        //记录友盟统计模块使用数
        NSString * fun = @"";
        if ([Manager shareMgr].registeType_ == FromNotKnown) {
            fun = @"启动注册";
        }
        else{
            fun = @"非启动注册";
        }
        NSDictionary * dict = @{@"Function":fun};
        [MobClick event:@"personused" attributes:dict];
        
        [usernameTf_ resignFirstResponder];
        [pwdTf_ resignFirstResponder];
        
        [self reg];
    }else if (sender == sinaLoginBtn_){
        //新浪微博第三方登录
        [self sinaLoginMethod];
    }else if (sender == qqLoginBtn_){
        //QQ第三方登录
        [self qqLoginMethod];
    }else if (sender == weChatLoginBtn_){
        //微信第三方登录
        [self weChatLoginMethod];
    }
    else if (sender == backBtn)
    {
        [Manager shareMgr].showLoginBackBtn = NO;
        [NoLoginPromptCtl getNoLoginManager].loginType = LoginType_None;
        AssociationAppDelegate *delegate = (AssociationAppDelegate *)[[UIApplication sharedApplication] delegate];
        if (![Manager shareMgr].tabVC) {
            [Manager shareMgr].tabVC = [[RootTabBarViewController alloc]init];
        }
        delegate.window.rootViewController = [Manager shareMgr].tabVC;
        for (id vc in [Manager shareMgr].tabVC.viewControllers) {
            if ([vc childViewControllers].count > 1) {
                [Manager shareMgr].tabVC.tabBar.hidden = YES;
            }
        }
    }
}

//点击是否显示密码
- (IBAction)isShowPassWord:(id)sender {
    if (!pwdTf_.secureTextEntry) {
        [_isShowPassWordBtn setImage:[UIImage imageNamed:@"code_nosee@2x"] forState:UIControlStateNormal];
        pwdTf_.secureTextEntry = YES;
    }
    else{
        [_isShowPassWordBtn setImage:[UIImage imageNamed:@"code_cansee@2x"] forState:UIControlStateNormal];
        pwdTf_.secureTextEntry = NO;
    }
}

#pragma mark -- 业务逻辑
//三方登录绑定手机号码
-(void)bindingPhone:(User_DataModal *)dataVO{
    BindCtl *bindPhone = [[BindCtl alloc]init];
    bindPhone.varifyType = VarifyTypeBindPhone;
    bindPhone.inDataModal = dataVO;
    [self.navigationController pushViewController:bindPhone animated:YES];
}

//登录验证
+ (NSString*)verifyLogin:(NSString*)userId checkCode:(NSString*)code{
    //先对随机生成数进行MD5
    NSString * str = [MD5 getMD5:code];
    str = [NSString stringWithFormat:@"%@%@",userId,str];
    //对拼接后的字符串进行MD5
    str = [MD5 getMD5:str];
    return str;
}

#pragma mark 登录用户名不存在，时注册
- (void)goRegist:(BOOL)isOrNo
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    if (IOS8) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    }
    RegPhoneInputCtl * regPhoneCtl = [[RegPhoneInputCtl alloc] init];
    regPhoneCtl.isThirdBanderPhoneNum = isOrNo;
    NSString *userName = [usernameTf_.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([userName isMobileNumValid]){
        regPhoneCtl.phone = userName;
    }
    [self.navigationController pushViewController:regPhoneCtl animated:YES];
}

#pragma mark--第三方登录处理
-(void)sinaLoginMethod
{
    __weak typeof(self) weakSelf = self;
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Sina currentViewController:nil completion:^(id result, NSError *error) {
        UMSocialUserInfoResponse *userinfo =result;
        [weakSelf jsonSina:userinfo];
    }];
}

-(void)jsonSina:(UMSocialUserInfoResponse *)userinfo{
    tempModel_.nickname_ =  userinfo.name;
    tempModel_.img_ = userinfo.iconurl;
    tempModel_.sex_ = userinfo.gender;
    tempModel_.identity_ =  userinfo.uid;
    //验证用户是否绑定
    sinaDetectBindingCon_ = [self getNewRequestCon:NO];
    [sinaDetectBindingCon_ detectBindingWithConnectSource:@"sina_weibo" openId:tempModel_.identity_];

}

//QQ第三方登录
-(void)qqLoginMethod
{
    __weak typeof(self) weakSelf = self;
     [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:nil completion:^(id result, NSError *error) {
     UMSocialUserInfoResponse *userinfo =result;
     [weakSelf jsonQQ:userinfo];
     }];
}

-(void)jsonQQ:(UMSocialUserInfoResponse *)userinfo{
    tempModel_.nickname_ =  userinfo.name;
    tempModel_.img_ = userinfo.iconurl;
    tempModel_.sex_ = userinfo.gender;
    tempModel_.identity_ = [NSString stringWithFormat:@"%@",userinfo.openid];
    //验证用户是否绑定
    qqDetectBindingCon_ = [self getNewRequestCon:NO];
    [qqDetectBindingCon_ detectBindingWithConnectSource:@"qq" openId:tempModel_.identity_];
}

//微信第三方登录
- (void)weChatLoginMethod
{
    __weak typeof(self) weakSelf = self;
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        UMSocialUserInfoResponse *userinfo =result;
        [weakSelf jsonWeChat:userinfo];
    }];
}

-(void)jsonWeChat:(UMSocialUserInfoResponse *)userinfo{
    NSDictionary *dic = userinfo.originalResponse;
    NSString *nickName = [dic objectForKey:@"nickname"];
    NSString *imgUrlStr = [dic objectForKey:@"headimgurl"];
    NSString *gender = [dic objectForKey:@"sex"];
    NSString *unionid = [dic objectForKey:@"unionid"];
    tempModel_.nickname_ = nickName;
    tempModel_.img_ = imgUrlStr;
    tempModel_.sex_ = gender;
    tempModel_.identity_ = unionid;
    
    wxDetectBindingCon_ = [self getNewRequestCon:NO];
    [wxDetectBindingCon_ detectBindingWithConnectSource:@"wechat" openId:unionid];
}

-(IBAction)visit:(id)sender
{
    //记录友盟统计模块使用数
    NSString * fun = @"";
    if ([Manager shareMgr].registeType_ == FromNotKnown) {
        fun = @"启动随便看看";
    }
    else{
        fun = @"非启动随便看看";
    }
    NSDictionary * dict = @{@"Function":fun};
    [MobClick event:@"personused" attributes:dict];

    AssociationAppDelegate *delegate = (AssociationAppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([Manager shareMgr].tabVC) {
        [Manager shareMgr].tabVC = nil;
    }
    [Manager shareMgr].tabVC = [[RootTabBarViewController alloc]init];
    [Manager shareMgr].isFirstLoading = NO;
    delegate.window.rootViewController = [Manager shareMgr].tabVC;
    [Manager shareMgr].tabVC.selectedIndex = 0;
    
    [Manager shareMgr].haveLogin = NO;
    [Manager shareMgr].noVisit_ = YES;
    [Manager haveShowLogo:YES];
    [[Manager shareMgr] visitNoLogin];
    
}

//RegistOKDelegate
-(void)registerPhoneOK:(User_DataModal *)user userName:(NSString *)name pwd:(NSString *)pwd
{
    //[self.navigationController setNavigationBarHidden:YES animated:NO];
    usernameTf_.text = name;
    pwdTf_.text = pwd;
}

//设置placeholder
-(void)loginAndPwdTxtSetting{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = UIColorFromRGB(0xe0e0e0);
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    NSAttributedString *userPlaceholder = [[NSAttributedString alloc] initWithString:@"手机/邮箱/用户名" attributes:attrs];
    usernameTf_.attributedPlaceholder = userPlaceholder;
    NSAttributedString *pwdPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:attrs];
    pwdTf_.attributedPlaceholder = pwdPlaceholder;
}


-(void)initPushSettings
{
    if (!initPushCon_) {
        initPushCon_ = [self getNewRequestCon:NO];
    }
    NSString * userId ;
    if (![Manager getUserInfo].userId_||[[Manager getUserInfo].userId_ isEqual:[NSNull null]]) {
        userId = @"";
    }
    else
    {
        userId = [Manager getUserInfo].userId_;
    }
    [initPushCon_ initPushSettings:userId];
}

#pragma mark--login
//登录
-(void)loginRequest{
    AssociationAppDelegate *delegate = (AssociationAppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([Manager shareMgr].isNeedRefresh || [Manager shareMgr].isFirstLoading) {
        [Manager shareMgr].tabVC = [[RootTabBarViewController alloc]init];
        [Manager shareMgr].isNeedRefresh = NO;
    }
    if (![Manager shareMgr].tabVC) {
        [Manager shareMgr].tabVC = [[RootTabBarViewController alloc] init];
    }
    delegate.window.rootViewController = [Manager shareMgr].tabVC;
    for (id vc in [Manager shareMgr].tabVC.viewControllers) {
        if ([vc childViewControllers].count > 1) {
            [Manager shareMgr].tabVC.tabBar.hidden = YES;
        }
    }
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:Config_Key_RemberPwd];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// JSON格式的字符串转换成字典
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
