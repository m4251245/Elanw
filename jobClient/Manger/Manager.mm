//
//  Manager.m
//  MBA
//
//  Created by sysweal on 13-11-9.
//  Copyright (c) 2013年 job1001. All rights reserved.
//

#import "Manager.h"
#import "AssociationAppDelegate.h"
#import "TodayFocusListCtl.h"
#import "NoLoginCtl.h"
#import "ConsultantHRDataModel.h"
#import "YLSayPageCtlViewController.h"
#import "YLFriendListCtl.h"
#import "MessageRefreshCtl.h"
#import "SysTemSetCtl.h"
#import "ELPersonCenterCtl.h"
#import "ELMyRewardRecordListCtl.h"
#import "ELInterViewListCtl.h"
#import "ELOfferPartyMessageCtl.h"
#import "ELBaseNavigationController.h"
#import "CHROfferPartyDetailCtl.h"
#import "NoLoginPromptCtl.h"
#import "ELGroupDetailCtl.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "InterviewMessageListCtl.h"
#import "NewCareerTalkDataModal.h"
#import "ELOAWebCtl.h"
#import "OfferPartyTalentsModel.h"
#import "NoLoginPromptCtl.h"
#import "RootTabBarViewController.h"
#import "RootNavigationController.h"
#import "LoginCtl.h"
#import "TabBarView.h"
#import "MyResumeController.h"
#import "ELJobSearchCondictionChangeCtl.h"
#import "ELWebSocketManager.h"

#import "ELNewsListDAO.h"
#import "ELNewNewsInfoVO.h"
#import "ELNewNewsListVO.h"
#import "CareerTailDetailCtl.h"
#import "JobFairDetailCtl.h"
#import "MyOfferPartyIndexCtl.h"
#import "YLExpertListCtl.h"
#import "ResumeVisitorListCtl.h"
#import "CHRIndexCtl.h"
//Manager实例
static Manager *manager = nil;


//登录的信息
User_DataModal *userDataModal;

Expert_DataModal * pushExpert_;

Groups_DataModal * pushGroup_;

ZWDetail_DataModal * pushCompany_;

ConsultantHRDataModel *consultHRModel;

NSString         * pushUrl_;

BOOL  showNewsAlert_;


@interface Manager () <NoLoginDelegate, UIWebViewDelegate,UIAlertViewDelegate>
{
    YLSayPageCtlViewController * sayPageCtl;
    ELRequest    *elRequest;
    RequestCon   *newCon;
    UIImageView *adImageView;
    NSMutableDictionary *emojiDic;
    BOOL showAdLoadFinish;
    GetAccessStatusBlock accessCancelBlock;
}
@end

PreCondictionListCtl        *preCondictionListCtl;
CondictionPlaceCtl          *condictionPlaceCtl;
CondictionPlaceSchoolCtl    *condictionPlaceSchoolCtl;
CondictionZWCtl             *condictionZWCtl;
CondictionTradeCtlOld          *condictionTradeCtl;
CondictionTradeCtl          *hrCondictionTradeCtl;
BOOL showLogoFlag_;

@implementation Manager

@synthesize loginCtl_,centerNav_,noLoginCtl_,haveLogin,nologinCtl_,noVisit_,showModal_,showModal2_,salaryCommpeteCtl_,messageCnt_,answerDetailCtl_,regionListCtl_,modalCtl_,tabType_,pushAnsweredData_,pushNewsData_,pushQuestionData_,articleDetailCtl_,pushExpertArticleData_,pushAssArticleData_,subscribedJobsCtl_,pushGroupsData_,registeType_,regionName_,bLRegion_,groupCreateCtl_,findJobCtl_,bAccountChanged_,sysNotificationCtl_,myGroupCtl_,recGroupsCtl_,isFromMessage_,version_,workApplyRecordListCtl_,tabVC;

//获取公用的管理类
+(Manager*) shareMgr
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        manager = [[Manager alloc] init];
    });
    return manager;
}

//发送注册推送请求
-(void)registNotificeCon:(NSString *)deviceToken  user:(NSString*)userId clientName:(NSString*)clientName startHour:(int)startHour  endHour:(int)endHour clientVersion:(NSString*)clientVersion betweenHour:(int)betweenHour
{
    if( !manager.loginCtl_ ){
        manager.loginCtl_ = [[LoginCtl alloc] init];
        [manager.loginCtl_ viewWillAppear:YES];
        
    }
    [manager.loginCtl_ registNotifice];
}

-(void)configToken:(AccessTokenType)tokenType userName:(NSString *)user pwd:(NSString *)pwd modelType:(AccessToken_DataModal *)model
baseUrl:(NSString *)baseUrl{
    if (!model) {
        model = [[AccessToken_DataModal alloc] init];
    }
    [model getDataModalWithUserDefaultType:tokenType];
    if (tokenType == AccessTokenTypeOne) {
        if ([model accessToken_] && ![[model accessToken_] isEqualToString:@""]) {
            _accessTokenModal = model;
        }
    }
    [[ELRequest sharedELRequest] requestWithUserName:user pwd:pwd baseUrl:baseUrl block:^(NSDictionary *dic) {
        NSString *secret = [dic objectForKey:@"secret"];
        AccessToken_DataModal *dataModal = nil;
        if (secret && ![secret isEqualToString:@""]) {
            dataModal = [[AccessToken_DataModal alloc] init];
            dataModal.sercet_ = [dic objectForKey:@"secret"];
            dataModal.accessToken_ = [dic objectForKey:@"access_token"];
        }
//        dataModal.sercet_ = [dic objectForKey:@"secret"];
//        dataModal.accessToken_ = [dic objectForKey:@"access_token"];
        switch (tokenType) {
            case AccessTokenTypeOne:
            {
                _accessTokenModal = dataModal;
                [self requestAdOne];
            }
                break;
            case AccessTokenTypeTwo:
                _accessTokenNewModal = dataModal;
                break;
            case AccessTokenTypeThree:
                _accessTokenThreeModal = dataModal;
                break;
            case AccessTokenTypeFour:
                _accessTokenFourModal = dataModal;
                break;
            default:
                break;
        }
        
        [dataModal saveDataModalWithUserDefaultType:tokenType];
    }];
    
}

-(void)requestToken{
#pragma mark - 请求第一种token
    [self configToken:AccessTokenTypeOne userName:WebService_User pwd:WebService_Pwd modelType:_accessTokenModal baseUrl:SeviceURL];
#pragma mark - 请求第二种token
    [self configToken:AccessTokenTypeTwo userName:@"jjr" pwd:@"jjr889900" modelType:_accessTokenNewModal baseUrl:NewSeviceURL];
#pragma mark - 请求第三种token
    [self configToken:AccessTokenTypeThree userName:@"recommend" pwd:@"recommend123" modelType:_accessTokenThreeModal baseUrl:NewSeviceURL];
#pragma mark - 请求第四种token
    [self configToken:AccessTokenTypeFour userName:@"message" pwd:@"message889900" modelType:_accessTokenFourModal baseUrl:NewSeviceURL];
}

#pragma mark - 开始请求和加载页面
-(void) begin:(UIWindow *)window
{
    [self requestToken];
    
    [[Manager shareMgr] getCity];
    //将需要copy的文件copy到沙盒中
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [Common getSandBoxPath:DB_FileName];
    if(![fileManager fileExistsAtPath:filePath]){
        //不存在，则拷入手机中
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[mainBundle resourcePath],DB_FileName]];
        [data writeToFile:[Common getSandBoxPath:DB_FileName] atomically:YES];
    }
    //简历和找工作
    //将需要copy的文件copy到沙盒中
    filePath = [Common getSandBoxPath:Job_DB_FileName];
    if( ![fileManager fileExistsAtPath:filePath] ){
        //不存在，则拷入手机中
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[mainBundle resourcePath],Job_DB_FileName]];
        [data writeToFile:[Common getSandBoxPath:Job_DB_FileName] atomically:YES];
    }
    
    
    filePath = [Common getSandBoxPath:@"data.db"];
    if( ![fileManager fileExistsAtPath:filePath] ){
        //不存在，则拷入手机中
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[mainBundle resourcePath],@"data.db"]];
        NSLog(@"db url = %@",[Common getSandBoxPath:@"data.db"]);
        [data writeToFile:[Common getSandBoxPath:@"data.db"] atomically:YES];
    }
    
    NSNumber * first = getUserDefaults(@"firstLaunch");
    if([first boolValue]){
        if([Manager checkLogin]){
            [Manager shareMgr].isFirstLoading = NO;
            if (!tabVC) {
                tabVC = [[RootTabBarViewController alloc]init];
            }
            self.tabBarView = tabVC.tabBarView;
            [window setRootViewController:tabVC];
            tabVC.selectedIndex = 0;
        }
        else{
            [Manager shareMgr].haveLogin = NO;
            [Manager shareMgr].isFirstLoading = YES;
            loginCtl_ = [[LoginCtl alloc]init];
            RootNavigationController *nav = [[RootNavigationController alloc]initWithRootViewController:loginCtl_];
            loginCtl_.navigationController.navigationBarHidden = YES;
            [window setRootViewController:nav];
        }
    }
    else{
        [Manager shareMgr].isFirstLoading = YES;
        loginCtl_ = [[LoginCtl alloc]init];
        RootNavigationController *nav = [[RootNavigationController alloc]initWithRootViewController:loginCtl_];
        loginCtl_.navigationController.navigationBarHidden = YES;
        [window setRootViewController:nav];
//        kUserDefaults(@(YES), @"firstLaunch");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        kUserSynchronize;
    }
    kUserDefaults(@(0), @"allNewsNumber");
    kUserSynchronize;
    preCondictionListCtl = [[PreCondictionListCtl alloc] init];
    condictionPlaceCtl = [[CondictionPlaceCtl alloc] init];
    condictionPlaceSchoolCtl = [[CondictionPlaceSchoolCtl alloc] init];
    condictionZWCtl = [[CondictionZWCtl alloc] init];
    condictionTradeCtl = [[CondictionTradeCtlOld alloc] init];
    hrCondictionTradeCtl = [[CondictionTradeCtl alloc] init];
    if (![MyCommon getVersionShowLogo:ClientVersion]) {
        //显示app介绍页面
        //[self showADView];
        _adView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        NSString *defaultPic = @"laungh750x1334";
        if (ScreenHeight == 568) {
            defaultPic = @"laungh640x1136";
        }else if (ScreenHeight == 480){
            defaultPic = @"laungh640x960";
        }
        UIImageView *image = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        image.image = [UIImage imageNamed:defaultPic];
        [_adView addSubview:image];
        [[UIApplication sharedApplication].keyWindow addSubview:_adView];
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:_adView];
        [self showAppIntroduceWithWebView];
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC));
        dispatch_after(time, dispatch_get_main_queue(), ^{
            if (!showAdLoadFinish) {
                [_webView stopLoading];
                [_adView removeFromSuperview];
            }
        });
        [MyCommon setVersion:ClientVersion showLogo:@"1"];
    }else{
        [self showADView];
    }
    
    //检查是否已经登录
    if( ![Manager checkLogin] ){
    }
    else
    {
        [manager haveReLogin:0];
    }
    NSDate * date = [NSDate date];
    NSString * dateStr = [MyCommon getDateStr:date format:@"yyyy-MM-dd HH:mm:ss"];
    //每天检查一次更新
    if (![CommonConfig getDBValueByKey:@"CheckVersionTime"]) {
        //启动检测版本
//        static SysTemSetCtl *checkSetCtl = [[SysTemSetCtl alloc] init];
        [CommonConfig setDBValueByKey:@"CheckVersionTime" value:dateStr];
    }
    else
    {
        NSString * lastDateStr = [CommonConfig getDBValueByKey:@"CheckVersionTime"];
        NSDate * lastDate = [MyCommon getDate:lastDateStr];
        if (fabs([lastDate timeIntervalSinceNow]) > 24*60*60) {
            //启动检测版本
//            static SysTemSetCtl *checkSetCtl = [[SysTemSetCtl alloc] init];
            [CommonConfig setDBValueByKey:@"CheckVersionTime" value:dateStr];
        }
    }
    
    [[ELWebSocketManager defaultManager] openServer];
    
    
    WS(weakSelf);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (haveLogin) {
            [weakSelf requestNewsLists];
        }
    });
    
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
    [ELRequest newPostbodyMsg:bodyMsg op:op func:function tokenType:AccessTokenTypeFour userName:@"message" pwd:@"message889900" modelType:_accessTokenFourModal serviceURL:NewSeviceURL version:New_Request_Version requestVersion:YES progressFlag:NO progressMsg:nil success:^(NSURLSessionDataTask *operation, id result) {
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


#pragma EAIntroDelegate
-(void)introDidFinish
{
    //本版本弹窗引导去申请职位
    [self showChooseAlertView:888 title:@"最新活动" msg:@"“一览为桨，划向梦想”一览2015校园招聘" okBtnTitle:@"马上查看" cancelBtnTitle:@"忽略"];
}

//是否已经显示提示页
+(BOOL) haveShowLogo :(BOOL)flag
{
    showLogoFlag_ = flag;
    return flag;
}

//是否已经登录
+(BOOL) checkLogin
{
    BOOL flag;
    NSString * flagStr = [[NSUserDefaults standardUserDefaults] valueForKey:Config_Key_RemberPwd];
    if ([flagStr isEqualToString:@"1"]) {
        flag = YES;
    }
    else
        flag = NO;
    
    return flag;
}

//设置登录信息
+(void) setUserInfo:(User_DataModal *)dataModal
{
    userDataModal = dataModal;
}

//获取登录信息
+(User_DataModal *) getUserInfo
{
    return userDataModal;
}

//设置登录信息
+(void) setHrInfo:(ConsultantHRDataModel *)dataModal
{
    consultHRModel = dataModal;
}

//获取登录信息
+(ConsultantHRDataModel *) getHrInfo
{
    return consultHRModel;
}

-(id) init
{
    self = [super init];
    
    return self;
}

////发现了新版本
//-(void) findNewVersion
//{
//    bHaveNewVersoin = YES;
//    
//}

//显示导航页
-(void) showLogo:(BOOL)animated
{
    
}

//显示登录
-(void) showLogin:(BOOL)animated
{
    [Manager shareMgr].haveLogin = NO;
    AssociationAppDelegate *appDelagate = (AssociationAppDelegate *)[UIApplication sharedApplication].delegate;
//    if (!loginCtl_) {
//         loginCtl_ = [[LoginCtl alloc]init];
//    }
    LoginCtl *loginCtl = [[LoginCtl alloc] init];
    RootNavigationController *nav = [[RootNavigationController alloc]initWithRootViewController:loginCtl];
    loginCtl.navigationController.navigationBarHidden = YES;
    [loginCtl updateView];
    appDelagate.window.rootViewController = nav;
}

//随便看看
-(void)visitNoLogin
{

//    AssociationAppDelegate * delegate = (AssociationAppDelegate*)[[UIApplication sharedApplication] delegate];
//    [delegate bindAlias:[Common idfvString]];
    [ELJPush bindAlias:[Common idfvString]];

    registeType_ = FromNotKnown;
  
    //[manager.todayFocusListCtl refreshLoad:nil];
    [manager.myGroupCtl_ refreshLoad:nil];
    [manager.findJobCtl_ refreshLoad:nil];
    if (!manager.myCenterCtl) {
        manager.myCenterCtl = [[MyManagermentCenterCtl alloc] init];
    }
    [manager.myCenterCtl refreshLoad:nil];
    if([Manager shareMgr].haveLogin)
    {
        [manager.messageCenterListCtl updateCom:nil];
        [manager.messageCenterListCtl refreshViewTwoCtl];
    }
   
}

//注销了
-(void) loginOut
{
    [ELJPush bindAlias:@""];
    [Manager shareMgr].isThridLogin_ = NO;

    [Manager shareMgr].messageCountDataModal = nil;
//    [[Manager shareMgr].tabView_ setTabBarNewMessage];
    [Manager setUserInfo:nil];
    [CommonConfig setDBValueByKey:@"companyID" value:@""];
    [CommonConfig setDBValueByKey:Config_Key_RemberPwd value:@"0"];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:Config_Key_RemberPwd];
    [self showLogin:NO];
    [self markUserStatus:2];
    
    [Manager shareMgr].haveLogin = NO;
    
//    if (IOS8) {
//        NSString *groupName = @"group.jobClient.shareExtension";//上线和测试用 share
//        //        NSString *groupName = @"group.jobClient.share";//企业版用 share
//        NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:groupName];
//        [shared setBool:NO forKey:@"logined"];
//        [shared synchronize];
//    }
    
}

//重新登录了
-(void) haveReLogin:(int)status
{
    manager.haveLogin = YES;
    if ([Manager checkLogin]) {
        
        //非登录入口需走这个验证路线
        if (status == 0) {
            NSString * str = [LoginCtl verifyLogin:[CommonConfig getDBValueByKey:Config_Key_UserID] checkCode:CheckCode_Login];
            if ([CommonConfig getDBValueByKey:Config_Key_VerifyUserID]) {
                if (![str isEqualToString:[CommonConfig getDBValueByKey:Config_Key_VerifyUserID]]) {
                    //弹窗提示用户ID验证失败了
                    [self showChooseAlertView:1 title:@"温馨提示" msg:@"用户验证失败" okBtnTitle:@"重新登录" cancelBtnTitle:@"取消"];
                    return;
                }
                
            }else{
                [CommonConfig setDBValueByKey:Config_Key_VerifyUserID  value:str];
            }
            
        }
        
        
        User_DataModal * dataModal = [[User_DataModal alloc] init];
        
        dataModal.userId_ = [CommonConfig getDBValueByKey:Config_Key_UserID];
        
        //判断是否第三方登录
        NSString *userId = [CommonConfig getDBValueByKey:@"isThridLogin"];
        if ([userId isEqualToString:dataModal.userId_]) {
            self.isThridLogin_ = YES;
        }else{
            self.isThridLogin_ = NO;
        }
        //若信息之前未被保存，重新登录
        if (!dataModal.userId_ || [dataModal.userId_ isEqual:[NSNull null]] || [dataModal.userId_ isEqualToString:@""]) {
            [manager showLogin:NO];
            return;
        }
        
        
        dataModal.name_ = [CommonConfig getDBValueByKey:Config_Key_UserName];
        dataModal.userId_ = [CommonConfig getDBValueByKey:Config_Key_UserID];
        dataModal.uname_ = [CommonConfig getDBValueByKey:Config_Key_User];
        dataModal.img_ = [CommonConfig getDBValueByKey:Config_Key_UserImg];
        dataModal.sex_ = [CommonConfig getDBValueByKey:Config_Key_UserSex];
        dataModal.prnd_ = [CommonConfig getDBValueByKey:Config_Key_UserPrnd];
        dataModal.school_ = [CommonConfig getDBValueByKey:@"schoolName"];
        dataModal.nickname_ = [CommonConfig getDBValueByKey:@"nickName"];
        dataModal.zye_ = [CommonConfig getDBValueByKey:@"zye"];
        dataModal.hka_ = [CommonConfig getDBValueByKey:@"hka"];
        dataModal.tradeName    = [CommonConfig getDBValueByKey:@"tradeName"];
        dataModal.tradeId    = [CommonConfig getDBValueByKey:@"tradeId"];
        dataModal.job_ = [CommonConfig getDBValueByKey:@"jobNow"];
        dataModal.intentionJob = [CommonConfig getDBValueByKey:@"intentionJob"];
        dataModal.followCnt_ = [[CommonConfig getDBValueByKey:@"followCnt"] integerValue];
        dataModal.role_ = [CommonConfig getDBValueByKey:@"rctype"];
        dataModal.mobile_ = [CommonConfig getDBValueByKey:@"shouji"];
        [Manager shareMgr].groupCount_ = [CommonConfig getDBValueByKey:@"groupsCount"];
        if (!dataModal.role_) {
            dataModal.role_ = @"1";
        }
        dataModal.groupsCreateCnt_ = [[CommonConfig getDBValueByKey:@"groupCreaterCnt"]integerValue];
        if ([[CommonConfig getDBValueByKey:@"isExpert"] isEqualToString:@"1"]) {
            dataModal.isExpert_ =YES;
        }else{
            dataModal.isExpert_ = NO;
        }
        [Manager setUserInfo:dataModal];
        
        
        //个推
//        AssociationAppDelegate * delegate = (AssociationAppDelegate*)[[UIApplication sharedApplication] delegate];
//        [delegate bindAlias:dataModal.userId_];
        [ELJPush bindAlias:dataModal.userId_];
        
        if( !manager.loginCtl_ ){
            manager.loginCtl_ = [[LoginCtl alloc] init];  
        }
        [manager.loginCtl_ initPushSettings];
        //获取简历信息
        Login_DataModal *loginModal = [[Login_DataModal alloc] init];
        loginModal.personId_ = dataModal.userId_;
        loginModal.updateTime_ = [Common getCurrentDateTime];
        loginModal.iname_ = dataModal.name_;
        loginModal.pic_ = dataModal.img_;
        loginModal.prnd_ = dataModal.prnd_;
        loginModal.uname_ = dataModal.uname_;
        [PreRequestCon setLoginDataModal:loginModal];
 
    }
    
    if(status == 1){
        if (manager.nologinCtl_) {
            [manager.nologinCtl_.view removeFromSuperview];
        }
        if (manager.myCenterCtl) {
            [manager.myCenterCtl refreshLoad:nil];
        }
        if (manager.myGroupCtl_) {
            [manager.myGroupCtl_ refreshLoad:nil];
        }
        if (manager.myCenterCtl) {//薪水入口
            [manager.myCenterCtl refreshLoad:nil];
            [manager.myCenterCtl refreshTableView];
        }
        if (manager.messageCenterListCtl) {
            [manager.messageCenterListCtl updateCom:nil];
            [manager.messageCenterListCtl refreshViewTwoCtl];
        }
        if (manager.findJobCtl_) {
            [manager.findJobCtl_ refreshLoad:nil];
        }
    }
    
    if ([NoLoginPromptCtl getNoLoginManager].loginType > 0) {
        [[NoLoginPromptCtl getNoLoginManager] loginSuccessDelegate];
    }
    
    //请求红点
    if (!_messageRefreshCtl) {
        _messageRefreshCtl = [[MessageRefreshCtl alloc] init];
    }
    [_messageRefreshCtl requestCount];
    
}



#pragma UINavigationControllerDelegate
-(void) navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}

-(void) navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
#if 0
    if( viewController == manager.messageCenterListCtl || viewController == manager.myCenterCtl || viewController == manager.myGroupCtl_  ||viewController == manager.findJobCtl_ || viewController == manager.todayFocusListCtl){
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        CGRect rect = manager.tabView_.frame;
        rect.origin.y = [UIScreen mainScreen].bounds.size.height -rect.size.height;

        [manager.tabView_ setFrame:rect];
        [UIView commitAnimations];
        
    }else{
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        CGRect rect = manager.tabView_.frame;
        rect.origin.y = [UIScreen mainScreen].bounds.size.height;
        [manager.tabView_ setFrame:rect];
        [UIView commitAnimations];
        
    }
#endif
}


#pragma mark - 通知处理
-(void) receiveRemoteNotification:(NSDictionary *)userInfo
{
    //取出消息
    NSString *msg = [userInfo objectForKey:@"content"];
    NSString *msgType = [[userInfo objectForKey:@"extras"] objectForKey:@"type"];
    NSString * contentId = [[userInfo objectForKey:@"extras"] objectForKey:@"aid"];
    NSString * url   = [[userInfo objectForKey:@"extras"] objectForKey:@"url"];
    NSString * gid   = [[userInfo objectForKey:@"extras"] objectForKey:@"gid"];
    NSString * cid = [[userInfo objectForKey:@"extras"] objectForKey:@"cid"];
    NSString * cname = [[userInfo objectForKey:@"extras"] objectForKey:@"cname"];
    NSString * logo = [[userInfo objectForKey:@"extras"] objectForKey:@"logo"];
    NSString * aid = [[userInfo objectForKey:@"extras"] objectForKey:@"mid"];
    NSString * pid = [[userInfo objectForKey:@"extras"] objectForKey:@"pid"];
//    NSString *topUrl = [userInfo objectForKey:@"top_url"];
    NSString *OAUrl = [userInfo objectForKey:@"url"];
    //515-518
    NSString * companyId = [[userInfo objectForKey:@"extras"] objectForKey:@"company_id"];
    NSString * companyName = [[userInfo objectForKey:@"extras"] objectForKey:@"company_name"];
    NSString * companyLogo = [[userInfo objectForKey:@"extras"] objectForKey:@"company_logo"];
    NSString * personId = [[userInfo objectForKey:@"extras"] objectForKey:@"person_id"];
    NSString * kw = [[userInfo objectForKey:@"extras"] objectForKey:@"kw"];
    NSString * salary = [[userInfo objectForKey:@"extras"] objectForKey:@"salary"];
    NSString * regionId = [[userInfo objectForKey:@"extras"] objectForKey:@"zw_regionid"];
    NSString * zwid = [userInfo objectForKey:@"zwid"];
    NSString * xjhZphId = [userInfo objectForKey:@"aid"];
    
    //523
    NSString * searchRegionId = [[userInfo objectForKey:@"extras"] objectForKey:@"regionid"];
    NSString * jtzw = [[userInfo objectForKey:@"extras"] objectForKey:@"jtzw"];
    //528
    NSString *companyNameStr = userInfo[@"tit"];
    NSString * offerPartyId = [userInfo objectForKey:@"jobfair_id"];
    //2：面试结果 30：取消面试通知。 100面试通知 200面试准备
    NSString * offerState = [userInfo objectForKey:@"state"];
    //2：面试结果 30：取消面试通知。 100面试通知 200面试准备  0 //通过初选  10  //不通过初  35 //发送offer
    NSString * offerMsgType = [userInfo objectForKey:@"msgtype"];
    if (offerMsgType != nil) {
        offerMsgType = [NSString stringWithFormat:@"%@",offerMsgType];
    }
    NSString * recommendId = [userInfo objectForKey:@"tuijian_id"];
    
    
    if (!msg) {
        msg = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    }
    if (!msgType) {
        msgType = [userInfo objectForKey:@"type"];
    }
    if (!contentId) {
        contentId = [userInfo objectForKey:@"aid"];
    }
    if (!url) {
        url = [userInfo objectForKey:@"url"];
    }
    if (!gid) {
        gid = [userInfo objectForKey:@"gid"];
    }
    if (!cid) {
        cid = [userInfo objectForKey:@"cid"];
    }
    if (!cname) {
        cname = [userInfo objectForKey:@"cname"];
    }
    if (!logo) {
        logo = [userInfo objectForKey:@"logo"];
    }
    if (!aid) {
        aid = [userInfo objectForKey:@"mid"];
    }
    if (!companyId) {
        companyId = [userInfo objectForKey:@"company_id"];
    }
    if (!companyId) {
        companyId = [userInfo objectForKey:@"companyid"];
    }
    if (!companyName) {
        companyName = [userInfo objectForKey:@"company_name"];
    }
    if (!companyName) {
        companyName = [userInfo objectForKey:@"cname"];
    }
    if (!companyLogo) {
        companyLogo = [userInfo objectForKey:@"company_logo"];
    }
    if (!companyLogo) {
        companyLogo = [userInfo objectForKey:@"logo"];
    }
    if (!kw) {
        kw = [userInfo objectForKey:@"kw"];
    }
    if (!salary) {
        salary = [userInfo objectForKey:@"salary"];
    }
    if (!regionId) {
        regionId = [userInfo objectForKey:@"zw_regionid"];
    }
    if (!personId) {
        personId = [userInfo objectForKey:@"person_id"];
    }
    if (!pid) {
        pid = [userInfo objectForKey:@"pid"];
    }
    
    if (!searchRegionId) {
        searchRegionId = [userInfo objectForKey:@"regionid"];
    }
    if (!jtzw) {
        jtzw = [userInfo objectForKey:@"jtzw"];
    }
    
    if( !msg )
    {
        msg = @"您有新的推送消息.";
    }
    
    //RCloud
//    NSString *chatId = [userInfo objectForKey:@"chatId"];
//    NSString *chatTitle = [userInfo objectForKey:@"chatTitle"];
    
    //若消息类型不是字符串
    if ([msgType isKindOfClass:[NSNumber class]]) {
        NSNumber  *number = (NSNumber*)msgType;
        msgType = number.stringValue;
    }
    
    RequestCon *con = [self getNewRequestCon:NO];
    [con receiveMessageType:msgType messageId:aid];
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive && _pushViewFlag) {
        NSString * time = [MyCommon getDateStr:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss"];
        RequestCon * logCon = [self getNewRequestCon:NO];
        [logCon postMessageClickLog:[Manager getUserInfo].userId_ messageId:aid title:msg type:msgType time:time];
    }
    
    //根据不同的订阅类型做不同的处理
    int  msgTypeInt = [msgType intValue];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"push_type=%d",msgTypeInt];
    NSString * function = @"pushClicked";
    NSString * op = @"yl_app_push_callback_busi";
    //发送请求
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {

    }];
    if (_pushViewFlag){
        if ([Manager shareMgr].searchChangeCtl) {
            [[Manager shareMgr].searchChangeCtl hideView];
        }
    }

    switch (msgTypeInt) {
#pragma mark - OA消息/OA公文800 811
        case 800:
        {
            if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive && _pushViewFlag) {
                _pushViewFlag = NO;
                isFromMessage_ = YES;
                AD_dataModal *dataModal = [[AD_dataModal alloc]init];
                dataModal.url_ = OAUrl;
                dataModal.shareUrl = dataModal.url_;
                dataModal.title_ = @"我的办公OA";
                dataModal.pic_ = [Manager getUserInfo].img_;
                
                ELOAWebCtl *oaWebCtl = [[ELOAWebCtl alloc] init];
                oaWebCtl.myBlock = ^(BOOL isRefresh){
                    
                };
                oaWebCtl.isPop = YES;
                oaWebCtl.hidesBottomBarWhenPushed = YES;
                [[self receivePushWithIdx:4] pushViewController:oaWebCtl animated:NO];
                
                [oaWebCtl beginLoad:dataModal exParam:nil];
            }else{
                [manager.messageRefreshCtl requestCount];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveNewMessageFromPush" object:nil];
            }
        }
            break;
#pragma mark - Offer派顾问给企业推荐 525
        case 525:
        {
            isFromMessage_ = YES;
            if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive && _pushViewFlag) {
                CHROfferPartyDetailCtl *offerDetailCtl = [[CHROfferPartyDetailCtl alloc]init];
                offerDetailCtl.jobfair_id = offerPartyId;
                offerDetailCtl.jobfair_time = userInfo[@"jobfair_time"];
                offerDetailCtl.jobfair_name = userInfo[@"jobfair_name"];
                offerDetailCtl.fromtype = userInfo[@"fromtype"];
                offerDetailCtl.place_name = userInfo[@"place_name"];
                
                offerDetailCtl.isPop = YES;
                //企业id
                offerDetailCtl.companyId = userInfo[@"company_id"];
                //协同账号id
//                offerDetailCtl.synergy_id = userInfo[@"synergy_id"];
                [CommonConfig setDBValueByKey:@"synergy_id" value:userInfo[@"synergy_id"]];
                offerDetailCtl.hidesBottomBarWhenPushed = YES;
                [[self receivePushWithIdx:4] pushViewController:offerDetailCtl animated:NO];
                [offerDetailCtl beginLoad:nil exParam:nil];
            }else{
                [manager.messageRefreshCtl requestCount];
            }
        }
            break;
#pragma mark - Offer派人才给顾问的反馈551
        case 551:
        {
            if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive && _pushViewFlag) {
                _pushViewFlag = NO;
                isFromMessage_ = YES;
                //来自推送时跳转到下个界面
                CHROfferPartyDetailCtl *offerDetailCtl = [[CHROfferPartyDetailCtl alloc] init];
                offerDetailCtl.companyId = [userInfo objectForKey:@"company_id"];
                offerDetailCtl.add_user = [userInfo objectForKey:@"add_user"];
                offerDetailCtl.jobfair_id = [userInfo objectForKey:@"jobfair_id"];
                offerDetailCtl.jobfair_time = [userInfo objectForKey:@"company_name"];
                offerDetailCtl.jobfair_name = [userInfo objectForKey:@"jobfair_name"];
                offerDetailCtl.fromtype = [userInfo objectForKey:@"fromtype"];
                offerDetailCtl.place_name = [userInfo objectForKey:@"place_name"];
                offerDetailCtl.msgType = [userInfo objectForKey:@"msgtype"];
                offerDetailCtl.isFromMessage = YES;
                offerDetailCtl.consultantCompanyFlag = YES;
                offerDetailCtl.isPop = YES;
                offerDetailCtl.hidesBottomBarWhenPushed = YES;
                [[self receivePushWithIdx:4] pushViewController:offerDetailCtl animated:NO];
                [offerDetailCtl beginLoad:nil exParam:nil];
            }
            else
            {
                [manager.messageRefreshCtl requestCount];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveNewMessageFromPush" object:nil];
            }
        }
            break;
#pragma mark - 个人offerparty推送528
        case 528:
        {

            OfferPartyTalentsModel *model = [[OfferPartyTalentsModel alloc] init];
            model.isjoin = YES;
            model.jobfair_id = offerPartyId;
            model.jobfair_name = companyNameStr;
            model.hrId = personId;
            model.state = offerState;
            model.companyId = companyId;
            model.personId = personId;;
            model.msgType = offerMsgType;
            model.recommendId = recommendId;

            if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive && _pushViewFlag) {//程序后台运行
                if ([Manager shareMgr].haveLogin) {
                    if ([msg containsString:[Manager shareMgr].offerPartyInterviewTuiSContent]) {
                        _pushViewFlag = NO;
                        isFromMessage_ = YES;
                        
                        //30：取消面试通知 100面试通知  2：面试结果  200面试准备  0 //通过初选  10 //不通过初  35 //发送offer
                        /*
                         以后还会用到，暂时不删除
                         if ([offerMsgType isEqualToString:@"30"] || [offerMsgType isEqualToString:@"100"]) {
                         OfferPartyDetailIndexCtl *offerPartyDetailCtl = [[OfferPartyDetailIndexCtl alloc]init];
                         offerPartyDetailCtl.offerPartyModel = model;
                         
                         if ([offerMsgType isEqualToString:@"200"] || [offerMsgType isEqualToString:@"0"] || [offerMsgType isEqualToString:@"2"]) {
                         offerPartyDetailCtl.isFromNotice = NO;
                         }
                         else
                         {
                         offerPartyDetailCtl.isFromNotice = YES;
                         }
                         
                         [manager.centerNav_ pushViewController:offerPartyDetailCtl animated:YES];
                         [offerPartyDetailCtl beginLoad:nil exParam:nil];
                         }
                         else
                         {
                         ELOfferPartyMessageCtl *offerMessageCtl = [[ELOfferPartyMessageCtl alloc] init];
                         [manager.centerNav_ pushViewController:offerMessageCtl animated:YES];
                         }
                         */
                        
                        OfferPartyDetailIndexCtl *offerPartyDetailCtl = [[OfferPartyDetailIndexCtl alloc]init];
                        offerPartyDetailCtl.offerPartyModel = model;
                        
                        if ([offerMsgType isEqualToString:@"30"] || [offerMsgType isEqualToString:@"100"]) {
                            offerPartyDetailCtl.isFromNotice = YES;
                        }
                        else
                        {
                            offerPartyDetailCtl.isFromNotice = NO;
                        }
                        offerPartyDetailCtl.isFromZbar = YES;
                        offerPartyDetailCtl.isPop = YES;
                        offerPartyDetailCtl.hidesBottomBarWhenPushed = YES;
                        [[self receivePushWithIdx:0] pushViewController:offerPartyDetailCtl animated:NO];
                        [offerPartyDetailCtl beginLoad:nil exParam:nil];
                    }
                }
                
            }else{//程序前台运行
                [manager.messageRefreshCtl requestCount];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveNewMessageFromPush" object:nil];
                
                //面试通知 或取消面试通知才显示提示框
                if ([Manager shareMgr].haveLogin) {
                    if ([model.msgType isEqualToString:@"30"] || [model.msgType isEqualToString:@"100"]) {
                        if (!_offerTipsCtl) {
                            _offerTipsCtl = [[OfferPartyInterviewTipsCtl alloc] init];
                        }
                        _offerTipsCtl.view.frame = [UIScreen mainScreen].bounds;
                        _offerTipsCtl.maskView.frame = _offerTipsCtl.view.frame;
                        _offerTipsCtl.offerPartyModel = model;
                        [_offerTipsCtl getPersonInterviewState];
                        [_offerTipsCtl showViewCtl];
                    }
                }
            }
        }
            break;
#pragma mark - Offer动作(人才给企业的反馈(接受面试邀请或拒绝面试邀请))550
        case 550:
        {
            NSMutableDictionary *dictionry = [[NSMutableDictionary alloc] init];
            NSString *state = [userInfo objectForKey:@"state"];
            NSString *content = [userInfo objectForKey:@"content"];
            [dictionry setObject:state forKey:@"state"];
            [dictionry setObject:content forKey:@"content"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"offerPartyTalentState" object:dictionry];
        }
            break;
#pragma mark - 新闻推送160
        case 160:
        {
            isFromMessage_ = YES;
            if (!showNewsAlert_) {
                Article_DataModal *pushNewsData  = [[Article_DataModal alloc] init];
                pushNewsData.title_ = msg ;
                //msgType 无拼接id
                pushNewsData.id_ = contentId;
                if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive && _pushViewFlag) {
                    isFromMessage_ = YES;
                    //程序后台运行不弹窗，直接跳转
                    _pushViewFlag = NO;
                    ArticleDetailCtl *newsCtl = [[ArticleDetailCtl alloc] init];
                    newsCtl.isFromNews = YES;
                    [newsCtl beginLoad:pushNewsData exParam:nil];
                    newsCtl.hidesBottomBarWhenPushed = YES;
                    newsCtl.isEnablePop = YES;
                    [[self receivePushWithIdx:0] pushViewController:newsCtl animated:NO];
                }else{
                    [manager.messageRefreshCtl requestCount];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveNewMessageFromPush" object:nil];
                }
            }
        }
            break;
#pragma mark - 提问有回答180
        case 180:
        {
            if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive && _pushViewFlag) {
                isFromMessage_ = YES;
                //程序后台运行不弹窗，直接跳转
                _pushViewFlag = NO;
                MyAQListCtl *aqListCtl = [[MyAQListCtl alloc] init];
                aqListCtl.isPop = YES;
                aqListCtl.hidesBottomBarWhenPushed = YES;
                [[self receivePushWithIdx:4] pushViewController:aqListCtl animated:NO];
                aqListCtl.type_ = 1;
                aqListCtl.leftRight = AQleft;
            }else{
                [manager.messageRefreshCtl requestCount];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveNewMessageFromPush" object:nil];
            }
        }
            break;
#pragma mark - 被提问181
        case  181:
        {
            if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive && _pushViewFlag) {
                isFromMessage_ = YES;
                //程序后台运行不弹窗，直接跳转
//                _appState = APPEnterAPPCon;
                _pushViewFlag = NO;
                MyAQListCtl *aqlistCtl= [[MyAQListCtl alloc] init];
                aqlistCtl.type_ = 1;
                aqlistCtl.leftRight = AQright;
                aqlistCtl.showWaitAnswerList = YES;
                aqlistCtl.isPop = YES;
                aqlistCtl.hidesBottomBarWhenPushed = YES;
                [[self receivePushWithIdx:4] pushViewController:aqlistCtl animated:NO];
            }else{
                [manager.messageRefreshCtl requestCount];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveNewMessageFromPush" object:nil];
            }
        }
            break;
#pragma mark - 关注的人发表190
        case  190:
//        case  524:
//        case  529:
        {
            isFromMessage_ = YES;
            if (!pushExpertArticleData_) {
                pushExpertArticleData_ = [[Article_DataModal alloc] init];
            }
            pushExpertArticleData_.id_ = contentId;
            if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive && _pushViewFlag) {
                //程序后台运行不弹窗，直接跳转
//                _appState = APPEnterAPPCon;
                _pushViewFlag = NO;
                ArticleDetailCtl * articleCtl = [[ArticleDetailCtl alloc] init];
                articleCtl.isEnablePop = YES;
                articleCtl.hidesBottomBarWhenPushed = YES;
                [[self receivePushWithIdx:0] pushViewController:articleCtl animated:NO];
                [articleCtl beginLoad:pushExpertArticleData_ exParam:nil];
            }else{
                [manager.messageRefreshCtl requestCount];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveNewMessageFromPush" object:nil];
            }
        }
            break;
#pragma mark - 社群有新话题/话题有新评论/社群文章置顶200/251/203
        case  200:
        case  251:
        case  203:
        {
            if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive && _pushViewFlag) {
                _pushViewFlag = NO;
                isFromMessage_ = YES;
                if (!pushAssArticleData_) {
                    pushAssArticleData_ = [[Article_DataModal alloc] init];
                }
                pushAssArticleData_.id_ = contentId;
                pushAssArticleData_.articleType_ = Article_Group;
                //程序后台运行不弹窗，直接跳转
                ArticleDetailCtl * articleCtl = [[ArticleDetailCtl alloc] init];
                articleCtl.isEnablePop = YES;
                articleCtl.hidesBottomBarWhenPushed = YES;
                [[self receivePushWithIdx:0] pushViewController:articleCtl animated:NO];
                articleCtl.isFromGroup_ = YES;
                [articleCtl beginLoad:pushAssArticleData_ exParam:nil];
            }else{
                //[manager.myGroupCtl_ refreshLoad:nil];
                //[manager.messageRefreshCtl requestCount];
                [self addPerform];
            }
        }
            break;
#pragma mark - 收到社群邀请201
        case  201:
        {
            if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive && _pushViewFlag) {
                isFromMessage_ = YES;
                //程序后台运行不弹窗，直接跳转
                _pushViewFlag = NO;
                InviteListCtl *inviteListCtl = [[InviteListCtl alloc] init];
                inviteListCtl.hidesBottomBarWhenPushed = YES;
                inviteListCtl.isPop = YES;
                [[self receivePushWithIdx:0] pushViewController:inviteListCtl animated:NO];
                [inviteListCtl beginLoad:nil exParam:nil];
            }
            else{
                [manager.messageRefreshCtl requestCount];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveNewMessageFromPush" object:nil];
            }
        }
            break;
#pragma mark - 收到申请加入社群 202
        case  202:
        {
            if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive && _pushViewFlag) {
                isFromMessage_ = YES;
                //程序后台运行不弹窗，直接跳转
//                _appState = APPEnterAPPCon;
                _pushViewFlag = NO;
                if (!manager.inviteListCtl_) {
                    manager.inviteListCtl_ = [[InviteListCtl alloc] init];
                }
                manager.inviteListCtl_.hidesBottomBarWhenPushed = YES;
                manager.inviteListCtl_.isPop = YES;
                [[self receivePushWithIdx:4] pushViewController:manager.inviteListCtl_ animated:NO];
                [manager.inviteListCtl_ beginLoad:nil exParam:nil];
            }else{
                [manager.messageRefreshCtl requestCount];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveNewMessageFromPush" object:nil];
            }
        }
            break;
#pragma mark - 收到面试通知 40
        case  40:
        {
            if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive && _pushViewFlag) {
                isFromMessage_ = YES;
                //程序后台运行不弹窗，直接跳转
//                _appState = APPEnterAPPCon;
                _pushViewFlag = NO;
                InterviewMessageListCtl *interviewDetailCtl = [[InterviewMessageListCtl alloc]init];
                interviewDetailCtl.hidesBottomBarWhenPushed = YES;
                interviewDetailCtl.isPop = YES;
                [[self receivePushWithIdx:4] pushViewController:interviewDetailCtl animated:NO];
                [interviewDetailCtl beginLoad:nil exParam:nil];
                [manager.messageRefreshCtl requestCount];
            }else{
                [manager.messageRefreshCtl requestCount];
            }
        }
            break;
#pragma mark - 收到职位订阅210
        case 210:
        {
            if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive && _pushViewFlag) {
                //程序后台运行不弹窗，直接跳转
//                _appState = APPEnterAPPCon;
                _pushViewFlag = NO;
                ZWDetail_DataModal * dataModal = [[ZWDetail_DataModal alloc] init];
                dataModal.zwID_ = zwid;
                dataModal.companyID_ = companyId;
                dataModal.companyLogo_ = companyLogo;
                dataModal.companyName_ = companyName;
                //跳转到职位详情
                PositionDetailCtl *detailCtl = [[PositionDetailCtl alloc] init];
                detailCtl.hidesBottomBarWhenPushed = YES;
                detailCtl.isPop = YES;
                [[self receivePushWithIdx:2] pushViewController:detailCtl animated:NO];
                [detailCtl beginLoad:dataModal exParam:nil];
            }else{
                [manager.messageRefreshCtl requestCount];
            }
        }
            break;
#pragma mark - 发表文章有新评论250
        case 250:
        {
            if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive && _pushViewFlag) {
                isFromMessage_ = YES;
                //程序后台运行不弹窗，直接跳转
                _pushViewFlag = NO;
                ArticleDetailCtl * articleCtl = [[ArticleDetailCtl alloc] init];
                articleCtl.isEnablePop = YES;
                articleCtl.hidesBottomBarWhenPushed = YES;
                [[self receivePushWithIdx:4] pushViewController:articleCtl animated:NO];
                Article_DataModal *articleData = [[Article_DataModal alloc] init];
                articleData.id_ = contentId;
                [articleCtl beginLoad:articleData exParam:nil];
                articleCtl.bScrollToComment_ = YES;
            }else{
                [manager.messageRefreshCtl requestCount];
                [self addPerform];
            }
        }
            break;
#pragma mark - 简历被查看50
        case 50:
        {
            if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive && _pushViewFlag) {
                isFromMessage_ = YES;
                //程序后台运行不弹窗，直接跳转
                _pushViewFlag = NO;
              
                MyResumeController *resumeVC = [[MyResumeController alloc] init];
                resumeVC.hidesBottomBarWhenPushed = YES;
                [[self receivePushWithIdx:2] pushViewController:resumeVC animated:NO];
            }
        }
            break;
#pragma mark - 发表文章有新评论（整合）252
//        case 252:
//        {
//            if (_appState == APPEnterForMessage && _pushViewFlag) {
//                isFromMessage_ = YES;
//                //程序后台运行不弹窗，直接跳转
//                _appState = APPEnterAPPCon;
//                _pushViewFlag = NO;
//                ArticleDetailCtl * articleCtl = [[ArticleDetailCtl alloc] init];
//                articleCtl.hidesBottomBarWhenPushed = YES;
//                articleCtl.isEnablePop = YES;
//                [[self receivePushWithIdx:4] pushViewController:articleCtl animated:NO];
//                Article_DataModal *articleData = [[Article_DataModal alloc] init];
//                articleData.id_ = contentId;
//                [articleCtl beginLoad:articleData exParam:nil];
//                articleCtl.bScrollToComment_ = YES;
//            }else{
//                [manager.messageRefreshCtl requestCount];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveNewMessageFromPush" object:nil];
//            }
//        }
//            break;
#pragma mark - 社群文章有新评论（整合）253
//        case 253:
//        {
//            if (_appState == APPEnterForMessage && _pushViewFlag) {
//                isFromMessage_ = YES;
//                //程序后台运行不弹窗，直接跳转
//                _appState = APPEnterAPPCon;
//                _pushViewFlag = NO;
//                ArticleDetailCtl * articleCtl = [[ArticleDetailCtl alloc] init];
//                articleCtl.isEnablePop = YES;
//                articleCtl.hidesBottomBarWhenPushed = YES;
//                [[self receivePushWithIdx:1] pushViewController:articleCtl animated:NO];
//                Article_DataModal *articleData = [[Article_DataModal alloc] init];
//                articleData.id_ = contentId;
//                [articleCtl beginLoad:articleData exParam:nil];
//                articleCtl.bScrollToComment_ = YES;
//            }else{
//                [manager.messageRefreshCtl requestCount];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveNewMessageFromPush" object:nil];
//            }
//        }
//            break;
#pragma mark - 推荐行家301
        case 301:
        {
            isFromMessage_ = YES;
            if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive && _pushViewFlag) {
                //程序后台运行不弹窗，直接跳转
//                _appState = APPEnterAPPCon;
                _pushViewFlag = NO;
                ELPersonCenterCtl * detailCtl = [[ELPersonCenterCtl alloc] init];
                detailCtl.isFromManagerCenterPop = YES;
                Expert_DataModal * dataModal = [[Expert_DataModal alloc] init];
                dataModal.id_ = pid;
                pushExpert_ = dataModal;
                [detailCtl beginLoad:pid exParam:nil];
                detailCtl.hidesBottomBarWhenPushed = YES;
                [[self receivePushWithIdx:0] pushViewController:detailCtl animated:NO];
            }else{
                [manager.messageRefreshCtl requestCount];
                _showTipsViewFlag = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TIPSNEWMESAGE" object:nil];
            }
        }
            break;
#pragma mark - 推荐社群302
        case  302:
        {
            isFromMessage_ = YES;
            Groups_DataModal * groupModal = [[Groups_DataModal alloc] init];
            groupModal.id_ = gid;
            pushGroup_ = groupModal;
            if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive && _pushViewFlag) {
                //程序后台运行不弹窗，直接跳转
//                _appState = APPEnterAPPCon;
                _pushViewFlag = NO;
                ELGroupDetailCtl * groupDetailCtl = [[ELGroupDetailCtl alloc] init];
                groupDetailCtl.isGroupPop = YES;
                groupDetailCtl.hidesBottomBarWhenPushed = YES;
                [[self receivePushWithIdx:0] pushViewController:groupDetailCtl animated:NO];
                [groupDetailCtl beginLoad:groupModal exParam:nil];
            }else{
                [manager.messageRefreshCtl requestCount];
                _showTipsViewFlag = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TIPSNEWMESAGE" object:nil];
            }
        }
            break;
#pragma mark - 推荐活动303
        case  303:
        {
            isFromMessage_ = YES;
            pushUrl_ = url;
            if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive && _pushViewFlag) {
                //程序后台运行不弹窗，直接跳转
//                _appState = APPEnterAPPCon;
                _pushViewFlag = NO;
                PushUrlCtl * pushurlCtl = [[PushUrlCtl alloc] init];
                pushurlCtl.hidesBottomBarWhenPushed = YES;
                pushurlCtl.isPop = YES;
                [[self receivePushWithIdx:4] pushViewController:pushurlCtl animated:NO];
                [pushurlCtl beginLoad:pushUrl_ exParam:@"最新活动"];
            }else{
                [manager.messageRefreshCtl requestCount];
                _showTipsViewFlag = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TIPSNEWMESAGE" object:nil];
            }
        }
            break;
#pragma mark - 最新简历(企业账号)304 305
        case 304: //人才投递
        case 305: //最新人才提问305
        {
            isFromMessage_ = YES;
            //最新简历
            if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive && _pushViewFlag) {
                //程序后台运行不弹窗，直接跳转
//                _appState = APPEnterAPPCon;
                _pushViewFlag = NO;
                
                if (!manager.myCenterCtl) {
                    manager.myCenterCtl = [[MyManagermentCenterCtl alloc] init];
                }
                [manager.myCenterCtl jumpToCompany];
            }else{
                [manager.messageRefreshCtl requestCount];
            }
        }
            break;
#pragma mark - HR回答306
        case 306:
        {
            isFromMessage_ = YES;
            ZWDetail_DataModal *pushCompany =[[ZWDetail_DataModal alloc] init];
            pushCompany.companyID_ = cid;
            pushCompany.companyName_ = cname;
            pushCompany.companyLogo_ = logo;
            //HR回答
            if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive && _pushViewFlag){
                //程序后台运行不弹窗，直接跳转
//                _appState = APPEnterAPPCon;
                _pushViewFlag = NO;
                PositionDetailCtl *positionCtl = [[PositionDetailCtl alloc]init];
                positionCtl.type_ = 2;
                positionCtl.isPop = YES;
                positionCtl.hidesBottomBarWhenPushed = YES;
                [[self receivePushWithIdx:2] pushViewController:positionCtl animated:NO];
                [positionCtl beginLoad:pushCompany exParam:nil];
            }else{
                [manager.messageRefreshCtl requestCount];
            }
        }
            break;
#pragma mark - 加入社群成功310
        case 310:
        {
            isFromMessage_ = YES;
            if (!pushGroupsData_) {
                pushGroupsData_ = [[Groups_DataModal alloc] init];
            }
            pushGroupsData_.id_ = gid;
            if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive && _pushViewFlag) {
                //程序后台运行不弹窗，直接跳转
//                _appState = APPEnterAPPCon;
                _pushViewFlag = NO;
                ELGroupDetailCtl *detailCtl_ = [[ELGroupDetailCtl alloc] init];
                detailCtl_.isGroupPop = YES;
                detailCtl_.hidesBottomBarWhenPushed = YES;
                [[self receivePushWithIdx:0] pushViewController:detailCtl_ animated:NO];
                detailCtl_.isMine = YES;
//                detailCtl_.pushFromMe_ = YES;
                [detailCtl_ beginLoad:pushGroupsData_ exParam:nil];
            }else{
                
            }
        }
            break;
#pragma mark - 新增听众350
        case  350:
        {
            isFromMessage_ = YES;
            if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive && _pushViewFlag) {
                //程序后台运行不弹窗，直接跳转
//                _appState = APPEnterAPPCon;
                _pushViewFlag = NO;
                MyAudienceListCtl *listCtl = [[MyAudienceListCtl alloc]init];
                listCtl.isPop = YES;
                [listCtl beginLoad:@"2" exParam:nil];
                listCtl.hidesBottomBarWhenPushed = YES;
                [[self receivePushWithIdx:4] pushViewController:listCtl animated:NO];
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"receiveNewsMsg" object:nil];
            });
        }
            break;
#pragma mark - 系统推送500/501/502/503/504/505/506
        case  500:
        case  501:
        case  502:
        case  503:
        case  504:
        case  505:
        case  506:
        {
            if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive && _pushViewFlag) {
                isFromMessage_ = YES;
                //程序后台运行不弹窗，直接跳转
//                _appState = APPEnterAPPCon;
                _pushViewFlag = NO;
                if (![Manager shareMgr].sysNotificationCtl_) {
                    [Manager shareMgr].sysNotificationCtl_ = [[SystemNotificationCtl alloc] init];
                }
                [Manager shareMgr].sysNotificationCtl_.isPop = YES;
                [Manager shareMgr].sysNotificationCtl_.hidesBottomBarWhenPushed = YES;
                [[self receivePushWithIdx:0] pushViewController:[Manager shareMgr].sysNotificationCtl_ animated:NO];

                [[Manager shareMgr].sysNotificationCtl_ beginLoad:nil exParam:nil];
            }else{
                [manager.messageRefreshCtl requestCount];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveNewMessageFromPush" object:nil];
            }
        }
            break;
#pragma mark - 新增通讯录一览好友526
        case 526:
        {
            isFromMessage_ = YES;
            if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive && _pushViewFlag) {
                //程序后台运行不弹窗，直接跳转
//                _appState = APPEnterAPPCon;
                _pushViewFlag = NO;
                YLFriendListCtl *friendCtl = [[YLFriendListCtl alloc] init];
                friendCtl.phoneCount = 1;
                friendCtl.isPop = YES;
                friendCtl.hidesBottomBarWhenPushed = YES;
                [[self receivePushWithIdx:3] pushViewController:friendCtl animated:NO];
                
            }else
            {
                [manager.messageRefreshCtl requestCount];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveNewMessageFromPush" object:nil];
            }
        }
            break;
#pragma mark - 留言519
        case 519:
        {
            isFromMessage_ = YES;
            //NSString *userId = [NSString stringWithFormat:@"%@",userInfo[@"send_person_id"]];
            //if (userId && userId.length > 0) {
            //    [self timeInterval:userId];
            //}
            if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive && _pushViewFlag) {
                //程序后台运行不弹窗，直接跳转
//                _appState = APPEnterAPPCon;
                _pushViewFlag = NO;
                MessageContact_DataModel *model = [[MessageContact_DataModel alloc] init];
                model.userId = userInfo[@"send_person_id"];
                model.userIname = userInfo[@"person_iname"];
                model.pic = userInfo[@"person_pic"];
                
                MessageDailogListCtl *ctl = [[MessageDailogListCtl alloc]init];
                NSString *reltype = userInfo[@"rel_type"];
                if ([reltype isEqualToString:@"1"]) {
                    ctl.recordId = userInfo[@"rel_id"];
                    ctl.productType = @"1";
                }
                ctl.hidesBottomBarWhenPushed = YES;
                ctl.isPop = YES;
                [[self receivePushWithIdx:3] pushViewController:ctl animated:NO];
                [ctl beginLoad:model exParam:nil];
            }else{
                //程序正在运行，弹窗
                [manager.messageRefreshCtl requestCount];
                //                NSDictionary *dic = [MessageDailogListCtl receiveNewPushMessage:userInfo];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveNewMessageFromPush" object:userInfo];
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"receiveNewsMsg" object:nil];
            });
        }
            break;
#pragma mark - 申请记录507/508/509/510/512/513
//        case 507:
//        case 508:
//        case 509:
//        case 510:
//        case 512:
//        case 513:
//        {
//            isFromMessage_ = YES;
//            if (_appState == APPEnterForMessage && _pushViewFlag) {
//                //程序后台运行不弹窗，直接跳转
//                _appState = APPEnterAPPCon;
//                _pushViewFlag = NO;
//                WorkApplyRecordListCtl *workApplyRecordListCtl = [[WorkApplyRecordListCtl alloc] init];
//                [workApplyRecordListCtl beginLoad:nil exParam:nil];
//                workApplyRecordListCtl.hidesBottomBarWhenPushed = YES;
//                workApplyRecordListCtl.isPop = YES;
//                [[self receivePushWithIdx:4] pushViewController:workApplyRecordListCtl animated:NO];
//            }else{
//                [manager.messageRefreshCtl requestCount];
//            }
//        }
//            break;
#pragma mark - 灌薪水文章 515
//        case 515:
//        {
//            isFromMessage_ = YES;
//            if (_appState == APPEnterForMessage && _pushViewFlag) {
//                //程序后台运行不弹窗，直接跳转
//                _appState = APPEnterAPPCon;
//                _pushViewFlag = NO;
//                Article_DataModal * dataModal = [[Article_DataModal alloc] init];
//                dataModal.id_ = contentId;
//                dataModal.bgColor_ = [UIColor whiteColor];
//                SalaryIrrigationDetailCtl *detailCtl = [[SalaryIrrigationDetailCtl alloc] init];
//                detailCtl.hidesBottomBarWhenPushed = YES;
//                detailCtl.isPop = YES;
//                [[self receivePushWithIdx:0] pushViewController:detailCtl animated:NO];
//                [detailCtl beginLoad:dataModal exParam:nil];
//            }else{
//                [manager.messageRefreshCtl requestCount];
//                _showTipsViewFlag = YES;
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveNewMessageFromPush" object:nil];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"TIPSNEWMESAGE" object:nil];
//            }
//        }
//            break;
#pragma mark - 推荐职位516
//        case 516:
//        {
//            isFromMessage_ = YES;
//            pushCompany_ =[[ZWDetail_DataModal alloc] init];
//            pushCompany_.zwID_ = contentId;
//            pushCompany_.companyID_ = companyId;
//            pushCompany_.companyName_ = companyName;
//            pushCompany_.companyLogo_ = companyLogo;
//            //HR回答
//            if (_appState == APPEnterForMessage && _pushViewFlag && _pushViewFlag) {
//                //程序后台运行不弹窗，直接跳转
//                _appState = APPEnterAPPCon;
//                _pushViewFlag = NO;
//                PositionDetailCtl *positionCtl = [[PositionDetailCtl alloc]init];
//                positionCtl.hidesBottomBarWhenPushed = YES;
//                positionCtl.isPop = YES;
//                [[self receivePushWithIdx:2] pushViewController:positionCtl animated:NO];
//                [positionCtl beginLoad:pushCompany_ exParam:nil];
//            }else{
//                _showTipsViewFlag = YES;
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"TIPSNEWMESAGE" object:nil];
//            }
//        }
//            break;
#pragma mark - 一览文章517
//        case 517:
//        {
//            isFromMessage_ = YES;
//            if (_appState == APPEnterForMessage && _pushViewFlag) {
//                //程序后台运行不弹窗，直接跳转
//                _appState = APPEnterAPPCon;
//                _pushViewFlag = NO;
//                Article_DataModal * dataModal = [[Article_DataModal alloc] init];
//                dataModal.id_ = contentId;
//                ArticleDetailCtl * articleCtl = [[ArticleDetailCtl alloc] init];
//                articleCtl.hidesBottomBarWhenPushed = YES;
//                articleCtl.isEnablePop = YES;
//                [[self receivePushWithIdx:4] pushViewController:articleCtl animated:NO];
//                [articleCtl beginLoad:dataModal exParam:nil];
//            }else{
//                _showTipsViewFlag = YES;
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"TIPSNEWMESAGE" object:nil];
//            }
//        }
//            break;
#pragma mark - 薪资比拼结果518
//        case 518:
//        {
//            isFromMessage_ = YES;
//            if (_appState == APPEnterForMessage && _pushViewFlag) {
//                //程序后台运行不弹窗，直接跳转
//                _appState = APPEnterAPPCon;
//                _pushViewFlag = NO;
//                User_DataModal * dataModal = [[User_DataModal alloc] init];
//                dataModal.userId_ = personId;
//                dataModal.salary_ = salary;
//                dataModal.zym_ = kw;
//                dataModal.regionId_ = regionId;
//                SalaryGuideCtl * salaryGuideCtl = [[SalaryGuideCtl alloc] init];
//                salaryGuideCtl.kwFlag_ = @"1";
//                salaryGuideCtl.regionId_ = regionId;
//                salaryGuideCtl.hidesBottomBarWhenPushed = YES;
//                salaryGuideCtl.isPop = YES;
//                [[self receivePushWithIdx:0] pushViewController:salaryGuideCtl animated:NO];
//                [salaryGuideCtl beginLoad:dataModal exParam:nil];
//            }else{
//                _showTipsViewFlag = YES;
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"TIPSNEWMESAGE" object:nil];
//            }
//        }
//            break;
#pragma mark - 推广活动523
        case 523:
        {
            if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive && _pushViewFlag) {
                //程序后台运行不弹窗，直接跳转
//                _appState = APPEnterAPPCon;
                _pushViewFlag = NO;
                if (!searchRegionId||[searchRegionId isEqualToString:@""]) {
                    searchRegionId = @"440000";
                }
                if (!jtzw||[jtzw isEqual:[NSNull null]]||[jtzw isEqualToString:@""])  {
                    jtzw = @"应届生";
                }
        
                //[manager.salaryCtl_ removeSegmentView];
                if( !manager.findJobCtl_ ){
                    manager.findJobCtl_ = [[MyJobSearchCtl alloc] init];
                    manager.findJobCtl_.messageRegionId_ = searchRegionId;
                    manager.findJobCtl_.messageKw_ = jtzw;
                    manager.findJobCtl_.isFromMessage_ = YES;
                    manager.findJobCtl_.isPop = YES;
                    [[self receivePushWithIdx:0] pushViewController:manager.findJobCtl_ animated:NO];
                    manager.registeType_ = FromQZ;
                    tabType_ = 3;
                    [manager.findJobCtl_ beginLoad:nil exParam:nil];
                }else{
                    if (!manager.findJobCtl_) {
                        manager.findJobCtl_ = [[MyJobSearchCtl alloc] init];
                    }
                    manager.findJobCtl_.messageRegionId_ = searchRegionId;
                    manager.findJobCtl_.messageKw_ = jtzw;
                    manager.findJobCtl_.isFromMessage_ = YES;
                    manager.findJobCtl_.hidesBottomBarWhenPushed = YES;
                    manager.findJobCtl_.isPop = YES;
                    [[self receivePushWithIdx:0] pushViewController:manager.findJobCtl_ animated:NO];
                    manager.registeType_ = FromQZ;
                    tabType_ = 3;
                    [manager.findJobCtl_ refreshLoad:nil];
                }
            }
        }
            break;
#pragma mark - 宣讲会推送522
        case 522:
        {
            if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive && _pushViewFlag) {
                isFromMessage_ = YES;
                //程序后台运行不弹窗，直接跳转
//                _appState = APPEnterAPPCon;
                _pushViewFlag = NO;
                NewCareerTalkDataModal     *dataModel = [[NewCareerTalkDataModal alloc] init];
                dataModel.xjhId = xjhZphId;
                CareerTailDetailCtl *careerTailDetail = [[CareerTailDetailCtl alloc] init];
                [careerTailDetail beginLoad:dataModel exParam:nil];
                careerTailDetail.isPop = YES;
                careerTailDetail.hidesBottomBarWhenPushed = YES;
                [[self receivePushWithIdx:2] pushViewController:careerTailDetail animated:NO];
            }else{
                
            }
        }
            break;
#pragma mark - 招聘会推送521
        case 521:
        {
            if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive && _pushViewFlag) {
                isFromMessage_ = YES;
                //程序后台运行不弹窗，直接跳转
//                _appState = APPEnterAPPCon;
                _pushViewFlag = NO;
                NewCareerTalkDataModal *dataModel = [[NewCareerTalkDataModal alloc]init];
                dataModel.xjhId = xjhZphId;
                JobFairDetailCtl *jobFairDetail = [[JobFairDetailCtl alloc] init];
                [jobFairDetail beginLoad:dataModel exParam:nil];
                jobFairDetail.isPop = YES;
                jobFairDetail.hidesBottomBarWhenPushed = YES;
                [[self receivePushWithIdx:2] pushViewController:jobFairDetail animated:NO];
            }else{
                
            }
        }
            break;
#pragma mark - 打赏推送530
        case 530:
        {
            if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive && _pushViewFlag) {
                isFromMessage_ = YES;
                //程序后台运行不弹窗，直接跳转
//                _appState = APPEnterAPPCon;
                _pushViewFlag = NO;
                
                ELMyRewardRecordListCtl *rewardCtl= [[ELMyRewardRecordListCtl alloc] init];
                rewardCtl.personId = [Manager getUserInfo].userId_;
                rewardCtl.personImg = [Manager getUserInfo].img_;
                rewardCtl.hidesBottomBarWhenPushed = YES;
                rewardCtl.isPop = YES;
                [[self receivePushWithIdx:0] pushViewController:rewardCtl animated:NO];

                [rewardCtl beginLoad:nil exParam:nil];
            }else{
                
            }
        }
            break;
#pragma mark - 约谈推送540
        case 540:
        {
            if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive && _pushViewFlag) {
                isFromMessage_ = YES;
                //程序后台运行不弹窗，直接跳转

                _pushViewFlag = NO;
                ELInterViewListCtl *detailCtl = [[ELInterViewListCtl alloc] init];
                detailCtl.hidesBottomBarWhenPushed = YES;
                detailCtl.isPop = YES;
                [[self receivePushWithIdx:4] pushViewController:detailCtl animated:NO];
                [detailCtl beginLoad:nil exParam:nil];
                
            }else{
                
            }
        }
            break;
        case 520:
        {
            if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive && _pushViewFlag) {
                isFromMessage_ = YES;
                //程序后台运行不弹窗，直接跳转
//                _appState = APPEnterAPPCon;
                _pushViewFlag = NO;
                AnswerDetailCtl *detailCtl = [[AnswerDetailCtl alloc] init];
                detailCtl.hidesBottomBarWhenPushed = YES;
                detailCtl.isPop = YES;
                [detailCtl beginLoad:contentId exParam:nil];
                [[self receivePushWithIdx:4] pushViewController:detailCtl animated:NO];
            }
        }
            break;
#pragma mark - 群聊600
       case 600:
        {
            if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
                //程序后台运行不弹窗，直接跳转
                ELGroupDetailCtl *cvc = [[ELGroupDetailCtl alloc]init];
                cvc.hidesBottomBarWhenPushed = YES;
                cvc.isSwipe = YES;
                [[self receivePushWithIdx:3] pushViewController:cvc animated:NO];
                [cvc beginLoad:gid exParam:nil];
            }else{
                //程序正在运行，弹窗
//                [manager.messageRefreshCtl requestCount];
                //NSDictionary *dic = [MessageDailogListCtl receiveNewPushMessage:userInfo];
//                [self addPerform];
            }
        }
            break;
        case 700:
        {
            if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
                ResumeVisitorListCtl *ctl = [[ResumeVisitorListCtl alloc] init];
                ctl.hidesBottomBarWhenPushed = YES;
                [[self receivePushWithIdx:4] pushViewController:ctl animated:NO];
                [ctl beginLoad:nil exParam:nil];
            }
        }
            break;
        default:
        {
            if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive && _pushViewFlag) {
                //程序后台运行不弹窗，直接跳转
//                _appState = APPEnterAPPCon;
                _pushViewFlag = NO;
            }
        }
            break;
    }
}

-(void)addPerform{
    [self performSelector:@selector(addDelay) withObject:self afterDelay:2];
}

-(void)addDelay{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveNewMessageFromPush" object:nil];
}

-(void)alertViewChoosed:(UIAlertView *)alertView index:(int)index type:(int)type
{
    switch (type) {
        case 1:{
            //用户Id验证失败
            [self loginOut];
            self.haveLogin = NO;
        }
            break;
        case 160:
        {
            if (index == 0) {
                showNewsAlert_ = NO;
                [[Manager shareMgr].loginCtl_ dismissViewControllerAnimated:YES completion:^{}];
                
                manager.articleDetailCtl_ = [[ArticleDetailCtl alloc] init];
                
                if (manager.centerNav_.topViewController == manager.articleDetailCtl_) {
                    [manager.articleDetailCtl_ beginLoad:pushNewsData_ exParam:nil];
                }
                else{
                    if (pushNewsData_.id_){
                        [self.navigationController performSelector:@selector(pushViewController:animated:) withObject:[Manager shareMgr].articleDetailCtl_ afterDelay:0.5];
                        
                        [[Manager shareMgr].articleDetailCtl_ beginLoad:pushNewsData_ exParam:nil];
                    }
                    
                }
            }
            
        }
            break;
        case 301:
        {
            showNewsAlert_ = NO;
            //行家推荐
            ELPersonCenterCtl * detailCtl = [[ELPersonCenterCtl alloc] init];
            detailCtl.isFromManagerCenterPop = YES;
            detailCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailCtl animated:YES];
            [detailCtl beginLoad:pushExpert_.id_ exParam:nil];
        }
            break;
        case 302:
        {
            showNewsAlert_ = NO;
            //社群推荐
            ELGroupDetailCtl * groupDetailCtl = [[ELGroupDetailCtl alloc] init];
            groupDetailCtl.isGroupPop = YES;
            groupDetailCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:groupDetailCtl animated:YES];
            [groupDetailCtl beginLoad:pushGroup_ exParam:nil];
        }
            break;
        case 303:
        {
            showNewsAlert_ = NO;
            //最新活动
            PushUrlCtl * pushurlCtl = [[PushUrlCtl alloc] init];
            pushurlCtl.hidesBottomBarWhenPushed = YES;
            pushurlCtl.isPop = YES;
            [self.navigationController pushViewController:pushurlCtl animated:YES];
            [pushurlCtl beginLoad:pushUrl_ exParam:@"最新活动"];
        }
            break;
        case 306:
        {
            showNewsAlert_ = NO;
            //HR回答
            PositionDetailCtl *positionCtl = [[PositionDetailCtl alloc]init];
            positionCtl.type_ = 2;
            positionCtl.isPop = YES;
            positionCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:positionCtl animated:YES];
            [positionCtl beginLoad:pushCompany_ exParam:nil];
        }
            break;
        case 888:
        {
            ZWDetail_DataModal * dataModel =[[ZWDetail_DataModal alloc] init];
            dataModel.companyID_ = @"cm1287987635752";
            dataModel.companyName_ = @"深圳市一览网络股份有限公司";
            dataModel.companyLogo_ = @"http://img104.job1001.com/upload/logolib/img140X85_201308/__cm1287987635752_1377937419-C51BUJG.jpg";
            PositionDetailCtl *positionCtl = [[PositionDetailCtl alloc]init];
            positionCtl.type_ = 2;
            positionCtl.isPop = YES;
            positionCtl.hidesBottomBarWhenPushed = YES;
            [[self receivePushWithIdx:2] pushViewController:positionCtl animated:NO];
            [positionCtl beginLoad:dataModel exParam:nil];
        }
            break;
        default:
            break;
    }
}


-(void)alertViewCancel:(UIAlertView *)alertView index:(int)index type:(int)type
{
    switch (type) {
        case 1:
        {
            //用户Id验证失败时
            [self loginOut];
            self.haveLogin = NO;
        }
            break;
        case 160:
        {
            showNewsAlert_ = NO;
        }
            break;
            
        default:
            break;
    }
}

-(void)loginDelegateCtl
{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
    [Manager shareMgr].showLoginBackBtn = YES;
}

#pragma TabViewDelegate
-(void)getCity
{
    regionName_ = @"全国";//初始化为全国
    bLRegion_ = YES;
    if ([regionName_ isEqualToString:@"全国"]){
        [[MMLocationManager shareLocation] getCity:^(NSString *cityString) {
            regionName_ = cityString;
            kUserDefaults(cityString, kLocationCityName);
            kUserSynchronize;
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"SALARYGETREGIONSUCCESS" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"JOBSEARCHGETREGIONSUCCESS" object:nil];
        } error:^(NSError *error){
            regionName_ = @"全国";
            bLRegion_ = NO;
        }];
    }
}

-(void)initPushSet
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathname = [path objectAtIndex:0];
    if (![fileManager  fileExistsAtPath:[pathname stringByAppendingPathComponent:@"ylpushdatabase.sqlite3"]]||![[CommonConfig getDBValueByKey:Config_Key_PushSet] isEqualToString:@"1"]) {
        //        [manager.setCtl_ pushSet];
    }
}

-(void)markUserStatus:(int)status
{        //设置请求参数
    NSString * bodyMsg = @"bodyMsg = ";
    NSString * function = @"";
    NSString * op = @"person_info_api";
    if (status == 0) {
        function = @"doAppSleep";
    }
    if (status == 1) {
        function = @"doAppQuit";
    }
    if (status == 2) {
        function = @"doAppUserLogOut";
    }
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:NO success:^(NSURLSessionDataTask *operation, id result) {
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}


-(NSString *)getVersion
{
    return ClientVersion;
}

#pragma mark - 判断是否显示去评价的引导页
-(void)showSayViewWihtType:(NSInteger)type
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([user boolForKey:[NSString stringWithFormat:@"SAYPAGE%@",Request_Version]] != YES)
    {
        switch (type) {
            case 1: //第一次发表文章
            {
                NSString *str = [user objectForKey:@"PUBLISHARTICLECOUNT"];
                NSInteger count = [str integerValue];
                if (count == 1) {
                    return;
                }
                else
                {
                    [user setObject:@"1" forKey:@"PUBLISHARTICLECOUNT"];
                }
            }
                break;
            case 2:  //成功加入3个社群
            {
                NSString *str = [user objectForKey:@"ADDGROUPCOUNT"];
                NSInteger count = [str integerValue];
                if (count <= 2)
                {
                    [user setObject:[NSString stringWithFormat:@"%ld",long(count+1)] forKey:@"ADDGROUPCOUNT"];
                    if (count != 2)
                    {
                        return;
                    }
                }
                else
                {
                    return;
                }
            }
                break;
            case 3:  //申请5次职位
            {
                NSString *str = [user objectForKey:@"APPLYJOBCOUNT"];
                NSInteger count = [str integerValue];
                if (count <= 4)
                {
                    [user setObject:[NSString stringWithFormat:@"%ld",long(count+1)] forKey:@"APPLYJOBCOUNT"];
                    if (count != 4)
                    {
                        return;
                    }
                }
                else
                {
                    return;
                }
            }
                break;
            case 4:  //关注10个用户
            {
                NSString *str = [user objectForKey:@"FOLLOWCOUNT"];
                NSInteger count = [str integerValue];
                if (count <= 9)
                {
                    [user setObject:[NSString stringWithFormat:@"%ld",long(count+1)] forKey:@"FOLLOWCOUNT"];
                    if (count != 9)
                    {
                        return;
                    }
                }
                else
                {
                    return;
                }
            }
                break;
            case 5:  //比薪资两次
            {
                NSString *str = [user objectForKey:@"THANSALARYCOUNT"];
                NSInteger count = [str integerValue];
                if (count <= 1)
                {
                    [user setObject:[NSString stringWithFormat:@"%ld",long(count+1)] forKey:@"THANSALARYCOUNT"];
                    if (count != 1) {
                        return;
                    }
                }
                else
                {
                    return;
                }
            }
                break;
            default:
                break;
        }
        [self performSelector:@selector(showSayViewCtl) withObject:self afterDelay:0.5];
    }
}

-(void)showSayViewCtl
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if (!sayPageCtl) {
        sayPageCtl = [[YLSayPageCtlViewController alloc] init];
    }
    sayPageCtl.view.frame = [UIScreen mainScreen].bounds;
    [[[UIApplication sharedApplication] keyWindow] addSubview:sayPageCtl.view];
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:sayPageCtl.view];
    [user setBool:YES forKey:[NSString stringWithFormat:@"SAYPAGE%@",Request_Version]];
    [user synchronize];
}

#pragma mark 显示app介绍
- (void)showAppIntroduceWithWebView
{
    UIWebView *webView = [[UIWebView alloc]init];
    webView.scrollView.bounces = NO;
    webView.backgroundColor = [UIColor clearColor];
    webView.delegate = self;
    webView.frame = [UIScreen mainScreen].bounds;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.job1001.com/xjh/guidesapp/"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5]];
    _webView = webView;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_adView removeFromSuperview];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    showAdLoadFinish = YES;
    [_adView addSubview:_webView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.absoluteString containsString:@"/oa_guide/"]) {
        [_adView removeFromSuperview];
    }else if ([request.URL.absoluteString containsString:@"/guidesapp/"]){
        return YES;
    }
    return NO;
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    if (dataArr.count == 0) {
        return;
    }
//    switch (type) {
//        case requestBingdingStatusWith:
//        {
//            [BaseUIViewController showLoadView:NO content:nil view:nil];
//            //企业HR
//            if ([dataArr count] != 0) {
//                if ([dataArr[0] isKindOfClass:[CompanyInfo_DataModal class]])
//                {
//                    CompanyInfo_DataModal *model = dataArr[0];
//                    CHRIndexCtl * chrIndexCtl = [[CHRIndexCtl alloc] init];
//                    chrIndexCtl.companyId =  model.companyID_;
//                    
//                    //synergy_id 返回为0 所以将判断条件改为 >1
//                    if (model.synergy_id && model.synergy_id.length > 1) {
//                        chrIndexCtl.synergy_id = model.synergy_id;
//                        [CommonConfig setDBValueByKey:@"synergy_id" value:model.synergy_id];
//                    }else{
//                        [CommonConfig setDBValueByKey:@"synergy_id" value:@""];
//                    }
//                    chrIndexCtl.hidesBottomBarWhenPushed = YES;
//                    [self.navigationController pushViewController:chrIndexCtl animated:YES];
//                    [chrIndexCtl beginLoad:model.companyID_ exParam:nil];
//                    
//                }
//            }
//        }
//            break;
//        
//            
//        default:
//            break;
//    }
}

#pragma mark显示广告
-(void)showADView{
    // = [MobClick getConfigParams:@"splash_img_url"];
    CGFloat bottomHeight = 90;
    adImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,ScreenHeight)];
    NSString *defaultPic = @"laungh750x1334";
    if (ScreenHeight == 568) {
        defaultPic = @"laungh640x1136";
    }else if (ScreenHeight == 480){
        defaultPic = @"laungh640x960";
    }
    if (ScreenHeight < 667) {
        adImageView.frame = CGRectMake(0,0,320,570);
    }
    
    _adView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _adView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    image.image = [UIImage imageNamed:defaultPic];
    [_adView addSubview:image];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,ScreenHeight-bottomHeight)];
    backView.backgroundColor = [UIColor clearColor];
    backView.clipsToBounds = YES;
    [backView addSubview:adImageView];
    adImageView.center = backView.center;
    
    [_adView addSubview:backView];
    _adView.clipsToBounds = YES;

    [[UIApplication sharedApplication].keyWindow addSubview:_adView];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:_adView];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefault dataForKey:@"AD_IMAGE_DATA"];
    if (data){
        [adImageView setImage:[UIImage imageWithData:data]];
    }else{
        [_adView removeFromSuperview];
        return;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,ScreenHeight-bottomHeight)];
    view.backgroundColor = [UIColor whiteColor];
    view.alpha = 1.0;
    [_adView addSubview:view];
    [_adView bringSubviewToFront:view];

    [UIView animateWithDuration:3.0 animations:^{
        view.alpha = 0.0;
    }];
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^{
        //在指定时间后,要做的事情
        [UIView animateWithDuration:0.5 animations:^
         {
             _adView.alpha = 0.0;
         } completion:^(BOOL finished)
         {
             [_adView removeFromSuperview];
         }];
    });
}

-(void)requestAdOne
{
    [ELRequest postbodyMsg:@"" op:@"yl_adv_busi" func:@"getAppStartAdv" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        NSDictionary *dic = result;
        NSString *imgUrl = dic[@"path"];
        
        if (!imgUrl || [imgUrl isEqual:[NSNull null]]||[imgUrl isEqualToString:@""]||[imgUrl isEqualToString:@"null"]) {
            return  ;
        }
        adImageView = [[UIImageView alloc] init];
        [adImageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                NSData *data = UIImagePNGRepresentation(image);
                if (data) {
                    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                   // NSString* s1 = [[NSDate date] stringWithFormatDefault];
                   // [userDefault removeObjectForKey:@"AD_IMAGE_DATE"];
                   // [userDefault setObject:[s1 substringWithRange:NSMakeRange(0,10)] forKey:@"AD_IMAGE_DATE"];
                    [userDefault removeObjectForKey:@"AD_IMAGE_DATA"];
                    [userDefault setObject:data forKey:@"AD_IMAGE_DATA"];
                    [userDefault synchronize]; 
                }
            }
        }];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

//获取文章点赞状态
+(BOOL)getIsLikeStatus:(NSString *)articleId
{
    NSString *userId = @"";
    if ([Manager shareMgr].haveLogin) {
        userId = [Manager getUserInfo].userId_;
    }else{
        userId = @"NOLOGIN";
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic = [user objectForKey:@"ADDLIKEARTICLELIST"];
    if ([dic isKindOfClass:[NSMutableDictionary class]] && [dic count]>0){
        NSMutableDictionary *subDic = [dic objectForKey:userId];  
        if ([subDic[articleId] isEqualToString:@"1"]) { 
            return YES;
        }
    }
    return NO;
}

//删除文章或文章评论点赞记录
+(void)deleteLikeDate:(NSString *)articleId
{
    NSString *userId = @"";
    if ([Manager shareMgr].haveLogin) {
        userId = [Manager getUserInfo].userId_;
    }else{
        userId = @"NOLOGIN";
    }
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userDefault objectForKey:@"ADDLIKEARTICLELIST"];
    NSMutableDictionary *dicAll = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    if ([dicAll isKindOfClass:[NSMutableDictionary class]] && [dicAll count]>0){
        
        NSDictionary *subDic = [dicAll objectForKey:userId];
        NSMutableDictionary * mDict = [NSMutableDictionary dictionaryWithDictionary:subDic];

        if ([mDict[articleId] isEqualToString:@"1"]) {
            
            [mDict removeObjectForKey:articleId];
            
            [dicAll setObject:mDict forKey:userId];
            [userDefault setObject:dicAll forKey:@"ADDLIKEARTICLELIST"];
            [userDefault synchronize];
        }
    }
}

//清空文章点赞本地记录
+(void)clearLikeData
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *todayStr = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
    
    NSString *dayStr = [user objectForKey:@"ADDLIKEARTICLELISTDAY"];
    if (dayStr.length > 0) {
        if (![dayStr isEqualToString:todayStr])
        {
            [user removeObjectForKey:@"ADDLIKEARTICLELIST"];
            [user setObject:todayStr forKey:@"ADDLIKEARTICLELISTDAY"];
        }
    }
    else
    {
        [user setObject:todayStr forKey:@"ADDLIKEARTICLELISTDAY"];
    }
}
//添加文章点赞记录
+(void)saveAddLikeWithAticleId:(NSString *)articleId
{
    if (articleId.length <= 0) {
        return;
    }
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userDefault objectForKey:@"ADDLIKEARTICLELIST"];
    NSString *userId = @"";
    
    if ([Manager shareMgr].haveLogin) {
        userId = [Manager getUserInfo].userId_;
    }else{
        userId = @"NOLOGIN";
    }
    NSMutableDictionary *dicAll;
    
    if (dic)
    {
        dicAll = [[NSMutableDictionary alloc] initWithDictionary:dic];
        NSDictionary *subDic = [dic objectForKey:userId]; 
        NSMutableDictionary *subDicOne;
        if (subDic) {
            subDicOne = [[NSMutableDictionary alloc] initWithDictionary:subDic];
            [subDicOne setObject:@"1" forKey:articleId];
        }else{
            subDicOne = [[NSMutableDictionary alloc] init];
            [subDicOne setObject:@"1" forKey:articleId];
        }
        [dicAll setObject:subDicOne forKey:userId];
    }
    else
    {
        dicAll = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *subDic = [[NSMutableDictionary alloc] init];
        [subDic setObject:@"1" forKey:articleId];
        [dicAll setObject:subDic forKey:userId];
    }
    
    [userDefault setObject:dicAll forKey:@"ADDLIKEARTICLELIST"];
    [userDefault synchronize];
}

- (void)timeInterval:(NSString *)userId
{
    if (!userId) {
        return;
    }
    NSDictionary *dic = [NSDictionary dictionary];
    NSMutableDictionary *saveDic = [NSMutableDictionary dictionary];
    dic = [[NSUserDefaults standardUserDefaults] objectForKey:userId];
    
    NSInteger indirect = (long)[[NSDate date] timeIntervalSince1970] - [dic[@"indirectTimeInterval"] integerValue];
    if (indirect >= 2*60) {
        [saveDic setObject:[NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]] forKey:@"sendLeaveMessageTime"];
    }else{
        NSInteger timeInterval = (long)[[NSDate date] timeIntervalSince1970] - [dic[@"sendLeaveMessageTime"] integerValue];
        if (timeInterval >= 5*60) {
            
            [saveDic setObject:[NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]] forKey:@"sendLeaveMessageTime"];
        }else{
            [saveDic setObject:dic[@"sendLeaveMessageTime"] forKey:@"sendLeaveMessageTime"];
        }
    }
    [saveDic setObject:[NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]] forKey:@"indirectTimeInterval"];
    NSDictionary *tempDic = [NSDictionary dictionaryWithDictionary:saveDic];
    [[NSUserDefaults standardUserDefaults] setObject:tempDic forKey:userId];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)pushWithCtl:(id)ctl{
    [tabVC.viewControllers[tabVC.selectedIndex].childViewControllers[0].navigationController pushViewController:ctl animated:YES];
}

-(void)selectdVCWithIndex:(NSInteger)index{
    [tabVC.viewControllers[tabVC.selectedIndex].childViewControllers[0].navigationController popViewControllerAnimated:NO];
    [tabVC.tabBarView selectedBtnIdx:index];
    [tabVC showControllerIndex:index];
}

//通过NSString获取显示表情的NSMutableAttributedString
-(NSMutableAttributedString *)getEmojiStringWithString:(NSString *)str withImageSize:(CGSize)imageSize{
    if (!emojiDic) {
        emojiDic = [[NSMutableDictionary alloc] init];
        NSString *path = [[NSBundle mainBundle]pathForResource:@"emoticons.plist" ofType:nil];
        NSArray *emojiArr = [NSArray arrayWithContentsOfFile:path];
        for (NSDictionary *dic in emojiArr){
            [emojiDic setObject:dic[@"png"] forKey:dic[@"chs"]];
        }
    }
    NSRegularExpression *expression = [[NSRegularExpression alloc] initWithPattern:Custom_Emoji_Regex options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray * emojis = [expression matchesInString:str options:NSMatchingWithTransparentBounds range:NSMakeRange(0, str.length)];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str];
    for (NSInteger i = emojis.count-1; i>= 0; i--){
        NSTextCheckingResult *result = emojis[i];
        NSRange range = result.range;
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc]
                                            initWithData:nil ofType:nil];
        if (imageSize.width <= 0){
            imageSize = CGSizeMake(20,20);
        }
        textAttachment.bounds = CGRectMake(0,-4,imageSize.width,imageSize.height);
        UIImage *smileImage = [UIImage imageNamed:emojiDic[[str substringWithRange:range]]];
        textAttachment.image = smileImage ;
        NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
        [string replaceCharactersInRange:range withAttributedString:textAttachmentString];
    }
    return string;
}

//通过NSMutableAttributedString获取显示表情的NSMutableAttributedString
-(NSMutableAttributedString *)getEmojiStringWithAttString:(NSMutableAttributedString *)str withImageSize:(CGSize)imageSize{
    if (!emojiDic) {
        emojiDic = [[NSMutableDictionary alloc] init];
        NSString *path = [[NSBundle mainBundle]pathForResource:@"emoticons.plist" ofType:nil];
        NSArray *emojiArr = [NSArray arrayWithContentsOfFile:path];
        for (NSDictionary *dic in emojiArr){
            [emojiDic setObject:dic[@"png"] forKey:dic[@"chs"]];
        }
    }
    NSRegularExpression *expression = [[NSRegularExpression alloc] initWithPattern:Custom_Emoji_Regex options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray * emojis = [expression matchesInString:str.string options:NSMatchingWithTransparentBounds range:NSMakeRange(0, str.string.length)];
    NSMutableAttributedString *string = str;
    for (NSInteger i = emojis.count-1; i>= 0; i--){
        NSTextCheckingResult *result = emojis[i];
        NSRange range = result.range;
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc]
                                            initWithData:nil ofType:nil];
        if (imageSize.width <= 0){
            imageSize = CGSizeMake(20,20);
        }
        textAttachment.bounds = CGRectMake(0,-4,imageSize.width,imageSize.height);
        UIImage *smileImage = [UIImage imageNamed:emojiDic[[str.string substringWithRange:range]]];
        if (smileImage) {
            textAttachment.image = smileImage ;
            NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
            [string replaceCharactersInRange:range withAttributedString:textAttachmentString];
        }
    }
    return string;
}
#pragma mark - 请求创建社群的数量
+(void)getRequestCanCreatGroupCountWith:(NSString *)userId{
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionDicStr = [jsonWriter stringWithObject:conditionDic];
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&conditionArr=%@",userId,conditionDicStr];
    NSString * function = @"busi_getGroupCnt";
    NSString * op = @"groups";
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:NO success:^(NSURLSessionDataTask *operation, id result) {
        NSDictionary *dic = result;
        if ([dic isKindOfClass:[NSDictionary class]]) {
           // NSString *totalCnt = [dic objectForKey:@"totalCnt"];
           // NSString *createCnt = [dic objectForKey:@"createCnt"];
            NSString *remainCnt = [dic objectForKey:@"remainCnt"];
            if (remainCnt && ![remainCnt isEqualToString:@""]) {
                [Manager shareMgr].groupCount_ = remainCnt;
            }else{
                [Manager shareMgr].groupCount_ = @"";
            }
            [CommonConfig setDBValueByKey:@"groupsCount" value:[Manager shareMgr].groupCount_];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

#pragma mark 3G页面打开app跳转页面
-(void)openApp3GPushCtl{
    if (![Manager shareMgr].openAppUrl) {
        return;
    }
    NSString *urlStr = [Manager shareMgr].openAppUrl;
    urlStr = [urlStr stringByReplacingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    if ([urlStr containsString:@"://?"]) {
        NSString *string = [[urlStr componentsSeparatedByString:@"://?"] firstObject];
        urlStr = [urlStr substringFromIndex:string.length+4];
    }else{
        NSString *string = [[urlStr componentsSeparatedByString:@"://"] firstObject];
        urlStr = [urlStr substringFromIndex:string.length+3];
    }
    NSArray *arr = [urlStr componentsSeparatedByString:@"&"];
    if (arr.count > 0) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        for (NSString *string in arr) {
            NSArray *arrOne = [string componentsSeparatedByString:@"="];
            if (arrOne.count == 2) {
                [dic setObject:arrOne[1] forKey:arrOne[0]];
            }
        }
        [Manager shareMgr].openAppType = dic[@"appType"];
        if ([dic[@"appType"] isEqualToString:@"yl_app_normal_publish_detail"]) {
            
            NSString *articleId = [dic objectForKey:@"aid"];
            if([MyCommon isPureNumber:articleId]){
                if([Manager shareMgr].haveLogin){
                    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
                    dispatch_after(time, dispatch_get_main_queue(), ^{
                        ArticleDetailCtl *ctl = [[ArticleDetailCtl alloc] init];
                        ctl.hidesBottomBarWhenPushed = YES;
                        ctl.isEnablePop = YES;
                        [[Manager shareMgr] selectdVCWithIndex:0];
                        [[Manager shareMgr] pushWithCtl:ctl];
                        [ctl beginLoad:articleId exParam:nil];
                    });
                }else{
                    [Manager shareMgr].openAppArticleId = articleId;
                }
            }
        }else if ([dic[@"appType"] isEqualToString:@"yl_app_job_zw"]){
            ZWDetail_DataModal *zwVO = [ZWDetail_DataModal new];
            zwVO.zwID_ = [dic objectForKey:@"zwid"];
            zwVO.zwName_ = [[dic objectForKey:@"zwname"] URLDecodedForString];
            zwVO.companyID_ = [dic objectForKey:@"company_id"];
            zwVO.companyLogo_ = [[dic objectForKey:@"company_logo"] URLDecodedForString];
            zwVO.companyName_ = [[dic objectForKey:@"company_cname"] URLDecodedForString];
            zwVO.salary_ = [dic objectForKey:@"salary"];
            if ([Manager shareMgr].haveLogin) {
                dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
                dispatch_after(time, dispatch_get_main_queue(), ^{
                    PositionDetailCtl *detailCtl = [[PositionDetailCtl alloc] init];
                    detailCtl.hidesBottomBarWhenPushed = YES;
                    [[Manager shareMgr] selectdVCWithIndex:2];
                    [[Manager shareMgr] pushWithCtl:detailCtl];
                    [detailCtl beginLoad:zwVO exParam:nil];
                });
            }else{
                [Manager shareMgr].openAppZwModel = zwVO;
            }
        }else if ([dic[@"appType"] isEqualToString:@"yl_app_expert"]){
            
            NSString *pid = dic[@"pid"];
            if ([Manager shareMgr].haveLogin) {
                dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
                dispatch_after(time, dispatch_get_main_queue(), ^{
                    ELPersonCenterCtl *detailCtl = [[ELPersonCenterCtl alloc] init];
                    
                    detailCtl.hidesBottomBarWhenPushed = YES;
                    [[Manager shareMgr] selectdVCWithIndex:4];
                    [[Manager shareMgr] pushWithCtl:detailCtl];
                    [detailCtl beginLoad:pid exParam:nil];
                });
            }else{
                [Manager shareMgr].openAppPersonId = pid;
            }

        }else if ([dic[@"appType"] isEqualToString:@"yl_app_group"]){
            
            NSString *gid = dic[@"gid"];
            if ([Manager shareMgr].haveLogin) {
                dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
                dispatch_after(time, dispatch_get_main_queue(), ^{
                    ELGroupDetailCtl *detailCtl = [[ELGroupDetailCtl alloc] init];
                    detailCtl.hidesBottomBarWhenPushed = YES;
                    [[Manager shareMgr] selectdVCWithIndex:0];
                    [[Manager shareMgr] pushWithCtl:detailCtl];
                    [detailCtl beginLoad:gid exParam:nil];
                });
            }else{
                [Manager shareMgr].openAppGroupId = gid;
            }
        }else if ([dic[@"appType"] isEqualToString:@"yl_app_user_publish_list"]){
            
            NSString *pid = dic[@"pid"];
            if ([Manager shareMgr].haveLogin) {
                dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
                dispatch_after(time, dispatch_get_main_queue(), ^{
                    ExpertPublishCtl *detailCtl = [[ExpertPublishCtl alloc] init];
                    if ([pid isEqualToString:[Manager getUserInfo].userId_]) {
                        detailCtl.isMyCenter = YES;
                    }else{
                        detailCtl.isMyCenter = NO;
                    }
                    detailCtl.hidesBottomBarWhenPushed = YES;
                    [[Manager shareMgr] selectdVCWithIndex:4];
                    [[Manager shareMgr] pushWithCtl:detailCtl];
                    [detailCtl beginLoad:pid exParam:nil];
                });
            }else{
                [Manager shareMgr].openAppGroupId = pid;
            }
            
        }else if ([dic[@"appType"] isEqualToString:@"yl_app_group_topic_detail"]){
            
            Article_DataModal *articleModal = [[Article_DataModal alloc] init];
            articleModal.articleType_ = Article_Group;
            articleModal.groupId_ = dic[@"gid"];
            articleModal.id_ = dic[@"aid"];
            //            articleModal.code = dataModal.code;
            articleModal.group_open_status = dic[@"group_open_status"];
            if ([Manager shareMgr].haveLogin) {
                dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
                dispatch_after(time, dispatch_get_main_queue(), ^{
                    ArticleDetailCtl *detailCtl = [[ArticleDetailCtl alloc] init];
                    detailCtl.isFromGroup_ = YES;
                    
                    detailCtl.hidesBottomBarWhenPushed = YES;
                    [[Manager shareMgr] selectdVCWithIndex:4];
                    [[Manager shareMgr] pushWithCtl:detailCtl];
                    [detailCtl beginLoad:articleModal exParam:nil];
                });
            }else{
                [Manager shareMgr].openAppArticleModal = articleModal;
            }
        }else if ([dic[@"appType"] isEqualToString:@"yl_app_guan_detail"]){
            
            ELSalaryModel *arModal = [[ELSalaryModel alloc] init];
            arModal.article_id = dic[@"aid"];
            if ([Manager shareMgr].haveLogin) {
                dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
                dispatch_after(time, dispatch_get_main_queue(), ^{
                    SalaryIrrigationDetailCtl *salaryCtl = [[SalaryIrrigationDetailCtl alloc] init];
                    salaryCtl.hidesBottomBarWhenPushed = YES;
                    [[Manager shareMgr] selectdVCWithIndex:0];
                    [[Manager shareMgr] pushWithCtl:salaryCtl];
                    [salaryCtl beginLoad:arModal exParam:nil];
                });
            }else{
                [Manager shareMgr].openAppSalaryModel = arModal;
            }
        }else if ([dic[@"appType"] isEqualToString:@"yl_app_job_company"]){
        
            ZWDetail_DataModal *zwModal = [[ZWDetail_DataModal alloc] init];
            zwModal.companyName_ = [dic[@"company_name"] URLDecodedForString];
            zwModal.companyID_ = dic[@"company_id"];
            if ([Manager shareMgr].haveLogin) {
                dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
                dispatch_after(time, dispatch_get_main_queue(), ^{
                    PositionDetailCtl *positionDetailCtl = [[PositionDetailCtl alloc] init];
                    positionDetailCtl.type_ = 2;
                    positionDetailCtl.hidesBottomBarWhenPushed = YES;
                    [[Manager shareMgr] selectdVCWithIndex:2];
                    [[Manager shareMgr] pushWithCtl:positionDetailCtl];
                    [positionDetailCtl beginLoad:zwModal exParam:nil];
                });
            }else{
                [Manager shareMgr].openAppZwModel = zwModal;
            }
        }else if ([dic[@"appType"] isEqualToString:@"yl_app_zd_question"]){
        
            NSString *question_id = dic[@"question_id"];
            if ([Manager shareMgr].haveLogin) {
                dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
                dispatch_after(time, dispatch_get_main_queue(), ^{
                    AnswerDetailCtl *answerDetailCtl = [[AnswerDetailCtl alloc] init];
                    answerDetailCtl.hidesBottomBarWhenPushed = YES;
                    [[Manager shareMgr] selectdVCWithIndex:4];
                    [[Manager shareMgr] pushWithCtl:answerDetailCtl];
                    [answerDetailCtl beginLoad:question_id exParam:nil];
                });
            }else{
                [Manager shareMgr].openAppQuestionId = question_id;
            }
        }else if ([dic[@"appType"] isEqualToString:@"yl_app_teachins_xjh"]){
        
            NewCareerTalkDataModal *xjhModal = [[NewCareerTalkDataModal alloc] init];
            xjhModal.xjhId = dic[@"teachins_id"];
            xjhModal.type = 2;
            if ([Manager shareMgr].haveLogin) {
                dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
                dispatch_after(time, dispatch_get_main_queue(), ^{
                    CareerTailDetailCtl *careerTail = [[CareerTailDetailCtl alloc] init];
                    careerTail.hidesBottomBarWhenPushed = YES;
                    [[Manager shareMgr] selectdVCWithIndex:1];
                    [[Manager shareMgr] pushWithCtl:careerTail];
                    [careerTail beginLoad:xjhModal exParam:nil];
                });
            }else{
                [Manager shareMgr].openAppTeachinsModel = xjhModal;
            }
        }else if ([dic[@"appType"] isEqualToString:@"yl_app_teachins_zph"]){
        
            NewCareerTalkDataModal *zphModal = [[NewCareerTalkDataModal alloc]init];
            zphModal.xjhId = dic[@"teachins_id"];
            zphModal.type = 1;
            if ([Manager shareMgr].haveLogin) {
                dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
                dispatch_after(time, dispatch_get_main_queue(), ^{
                    JobFairDetailCtl *detailCtl = [[JobFairDetailCtl alloc] init];
                    detailCtl.hidesBottomBarWhenPushed = YES;
                    [[Manager shareMgr] selectdVCWithIndex:1];
                    [[Manager shareMgr] pushWithCtl:detailCtl];
                    [detailCtl beginLoad:zphModal exParam:nil];
                });
            }else{
                [Manager shareMgr].openAppTeachinsModel = zphModal;
            }
        }else if ([dic[@"appType"] isEqualToString:@"yl_app_skip_vs_pay"]){
        
            if ([Manager shareMgr].haveLogin) {
                dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
                dispatch_after(time, dispatch_get_main_queue(), ^{
                    SalaryCompeteCtl *salaryCompeteCtl_ = [[SalaryCompeteCtl alloc] init];
                    salaryCompeteCtl_.type_ = 2;
                    User_DataModal *userModel = [Manager getUserInfo];
                    [salaryCompeteCtl_ beginLoad:userModel.zym_ exParam:nil];
                    salaryCompeteCtl_.hidesBottomBarWhenPushed = YES;
                    [[Manager shareMgr] pushWithCtl:salaryCompeteCtl_];
                });
            }

        }else if ([dic[@"appType"] isEqualToString:@"yl_app_skip_recomm_offer"]){
        
            if ([Manager shareMgr].haveLogin) {
                dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
                dispatch_after(time, dispatch_get_main_queue(), ^{
                    MyOfferPartyIndexCtl *ctl = [[MyOfferPartyIndexCtl alloc] init];
                    ctl.isFromHome = YES;
                    [ctl beginLoad:nil exParam:nil];
                    ctl.hidesBottomBarWhenPushed = YES;
                    [[Manager shareMgr] pushWithCtl:ctl];
                });
            }
        }else if ([dic[@"appType"] isEqualToString:@"yl_app_skip_recomm_job"]){
        
            if ([Manager shareMgr].haveLogin) {
                dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
                dispatch_after(time, dispatch_get_main_queue(), ^{
                    YLExpertListCtl *expertList = [[YLExpertListCtl alloc] init];
                    expertList.selectedTab = @"职业经纪人";
                    expertList.hidesBottomBarWhenPushed = YES;
                    [[Manager shareMgr] pushWithCtl:expertList];
                });
            }
        }else if ([dic objectForKey:@"aid"]){
            NSString *articleId = [dic objectForKey:@"aid"];
            if([MyCommon isPureNumber:articleId]){
                if([Manager shareMgr].haveLogin){
                    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
                    dispatch_after(time, dispatch_get_main_queue(), ^{
                        ArticleDetailCtl *ctl = [[ArticleDetailCtl alloc] init];
                        ctl.hidesBottomBarWhenPushed = YES;
                        ctl.isEnablePop = YES;
                        [[Manager shareMgr] selectdVCWithIndex:0];
                        [[Manager shareMgr] pushWithCtl:ctl];
                        [ctl beginLoad:articleId exParam:nil];
                    });
                }else{
                    [Manager shareMgr].openAppArticleId = articleId;
                }
            }
        }else if ([dic objectForKey:@"zwid"]){
            ZWDetail_DataModal *zwVO = [ZWDetail_DataModal new];
            zwVO.zwID_ = [dic objectForKey:@"zwid"];
            zwVO.zwName_ = [[dic objectForKey:@"zwname"] URLDecodedForString];
            zwVO.companyID_ = [dic objectForKey:@"cid"];
            zwVO.companyLogo_ = [dic objectForKey:@"company_logo"];
            zwVO.companyName_ = [[dic objectForKey:@"company_cname"] URLDecodedForString];
            zwVO.salary_ = [dic objectForKey:@"salary"];
            if ([Manager shareMgr].haveLogin) {
                dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
                dispatch_after(time, dispatch_get_main_queue(), ^{
                    PositionDetailCtl *detailCtl = [[PositionDetailCtl alloc] init];
                    detailCtl.hidesBottomBarWhenPushed = YES;
                    [[Manager shareMgr] selectdVCWithIndex:0];
                    [[Manager shareMgr] pushWithCtl:detailCtl];
                    [detailCtl beginLoad:zwVO exParam:nil];
                });
            }else{
                [Manager shareMgr].openAppZwModel = zwVO;
            }
        }
        
    }
    if ([Manager shareMgr].haveLogin) {
        [Manager shareMgr].openAppType = nil;
    }
    
    [Manager shareMgr].openAppUrl = nil;
}

//推送跳转
-(RootNavigationController *)receivePushWithIdx:(NSInteger)idx{
    AssociationAppDelegate *delegate = (AssociationAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (!tabVC) {
        tabVC = [[RootTabBarViewController alloc]init];
        delegate.window.rootViewController = tabVC;
    }
    RootNavigationController *visibleNavVC = tabVC.selectedViewController;
    UIViewController *visibleVC = visibleNavVC.visibleViewController;
    [visibleVC.navigationController popToRootViewControllerAnimated:NO];
    [tabVC.tabBarView selectedBtnIdx:NO];
    [tabVC showControllerIndex:idx];
    return tabVC.selectedViewController;
}

#pragma mark - 修改webview的UserAgent
+(void)changeWebViewUserAgent{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString* secretAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        NSLog(@"%@",secretAgent);
    NSString *newUagent = [NSString stringWithFormat:@"YL1001_APPS_IOS_IPHONE_%@;%@",Request_Version,secretAgent];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setValue:newUagent forKey:@"UserAgent"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
}

#pragma mark - 系统访问权限判断
-(BOOL)getTheCameraAccessWithCancel:(GetAccessStatusBlock)cancel{
    accessCancelBlock = cancel;
    if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] ==AVAuthorizationStatusDenied)
    {
        if(IOS8)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"无相机访问权限" message:@"请在 “设置-隐私-相机” 中进行设置" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            alert.tag = 1002;
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"无相机访问权限" message:@"请在 “设置-隐私-相机” 中进行设置" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            alert.tag = 1002;
            [alert show];
        }
        return NO;
    }
    return YES;
}

-(BOOL)getPhotoAccessStatusWithCancel:(GetAccessStatusBlock)cancel{
    accessCancelBlock = cancel;
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusDenied)
    {
        if(IOS8)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"无相册访问权限" message:@"请在 “设置-隐私-照片” 中进行设置" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            alert.tag = 1002;
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"无相册访问权限" message:@"请在 “设置-隐私-照片” 中进行设置" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            alert.tag = 1002;
            [alert show];
        }
        return NO;
    }
    return YES;
}

-(BOOL)getAddressBookAccessStatusWithCancel:(GetAccessStatusBlock)cancel{
    accessCancelBlock = cancel;
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized)
    {
        if(IOS8)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"无通讯录访问权限" message:@"请在 “设置-隐私-通讯录” 中进行设置" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            alert.tag = 1002;
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"无通讯录访问权限" message:@"请在 “设置-隐私-通讯录” 中进行设置" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            alert.tag = 1002;
            [alert show];
        }
        return NO;
    }
    return YES;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1002)
    {
        if (buttonIndex == 1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            //@"prefs:root=Privacy&path=Photos"
        }
        else if(buttonIndex == 0)
        {
            if(accessCancelBlock){
                accessCancelBlock();
            }
        }
    }else if (alertView.tag == 1000) {
        [manager.centerNav_ popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - 获取内部可访问3g的域名
-(void)requestAdUrl3GArr{
    [ELRequest postbodyMsg:@"" op:@"comm_article_busi" func:@"getClickDomainList" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        NSArray *arr = result;
        if ([arr isKindOfClass:[NSArray class]]){
            if (arr.count>0) {
                _url3gArr = [[NSArray alloc] initWithArray:arr];
            }
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
    }];
}

-(NSArray *)getUrlArr{
    if (!_url3gArr){
        _url3gArr = @[@"cdagong.com", @"com1001.com", @"crm1001.com", @"dl086.com", @"dqjob88.com", @"elanw.com", @"epjob88.cn", @"epjob88.com", @"fcjob88.com", @"glasshr.com", @"hbjob88.com", @"jdjob88.com", @"jgjob88.com", @"jljob88.com", @"job1001.cn", @"job1001.com", @"kjjob88.com", @"lan1001.com", @"lqjob88.com", @"mo-yuan.com", @"ntjob88.com", @"qp1001.cn", @"qp1001.com", @"rubberhr.com", @"sjjob88.com", @"sljob88.com", @"tmjob88.com", @"waterhr.com", @"yl1001.com", @"z6hr.com", @"zzjob88.com"];
    }
    return _url3gArr;
}

@end
