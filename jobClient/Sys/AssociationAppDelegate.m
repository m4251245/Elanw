 //
//  AssociationAppDelegate.m
//  Association
//
//  Created by 一览iOS on 14-1-3.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "AssociationAppDelegate.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "MyConfig.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "PayCtl.h"
#import "ELJPush.h"
#import <JSPatch/JSPatch.h>
#import "ELBaseListCtl.h"
#import "RootTabBarViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "ELFMDevice.h"
#import "ELGroupDetailCtl.h"

static NSString *const KTrackingID = @"UA-92066272-4";  //需要换成自己的跟踪ID

static NSString *const KAllowTracking = @"allowTracking";

@interface AssociationAppDelegate ()<WXApiDelegate,UNUserNotificationCenterDelegate>

// 谷歌分析 Used for sending Google Analytics traffic in the background.
@property(nonatomic, assign) BOOL okToWait;
@property(nonatomic, copy) void (^dispatchHandler)(GAIDispatchResult result);

- (void)configGoogleAnalytics;
- (void)sendHitsInBackground;

@end

//分享回调的url
NSURL *receiveURL;
//注册推送的硬件token
NSString *deviceTokenStr;


@implementation AssociationAppDelegate

@synthesize bFromNotification = _bFromNotification;
@synthesize messageType = _messageType;

- (void)registerRemoteNotification
{
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 10.0) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
    } else {
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            //IOS8，创建UIUserNotificationSettings，并设置消息的显示类类型
            UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound) categories:nil];
            
            [[UIApplication sharedApplication] registerUserNotificationSettings:notiSettings];
        }
    }
}

//应用没有加载点击通知调用
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
#pragma mark-- 谷歌分析设置
    [self configGoogleAnalytics];

    [JSPatch startWithAppKey:@"8a90698a6dc2a3dc"];
#ifdef DEBUG
    [JSPatch setupDevelopment];
#endif
    [JSPatch sync];
    
    //开启友盟统计
    UMConfigInstance.appKey = UMAPPKEY;
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    //第一次加载程序
    if(![getUserDefaults(@"firstLaunch") boolValue])
    {
        //设置显示内页功能引导
        [Manager shareMgr].showModal_ = NO;
        [Manager shareMgr].showModal2_ = YES;
        //设置显示app介绍页面
        [Manager haveShowLogo:NO];
    } else{
        //设置不显示内页功能引导
        [Manager shareMgr].showModal_ = NO;
        [Manager shareMgr].showModal2_ = NO;
        //设置不显示app介绍页面
        [Manager haveShowLogo:YES];
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    //这个方法不能放后面，会把启动页干掉
    [self.window makeKeyAndVisible];
    [[Manager shareMgr] begin:self.window];
    
    //打开调试日志
    [[UMSocialManager defaultManager] openLog:NO];
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMAPPKEY];
    // 获取友盟social版本号
    //NSLog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
    
    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx0c293be2aa3f0e7e" appSecret:@"f79eeb79ac945d39de4f04d89b32f511" redirectURL:@"http://www.umeng.com/social"];
    //设置分享到QQ互联的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1101125779" appSecret:@"aP0MWW0uPHyt5Ewp" redirectURL:@"http://www.umeng.com/social"];
    [[UMSocialQQHandler defaultManager] setSupportWebView:YES];
    //设置新浪的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"1855347614"  appSecret:@"63e822dc2a2289789b8e5d8a48500c02" redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    //用于微信支付
    [WXApi registerApp:@"wx0c293be2aa3f0e7e"];
    [Manager shareMgr].isBackstage = NO;
#pragma mark - 极光SDK实例化
//    //如果别名没有绑定成功就重新绑定
//    if (![[CommonConfig getDBValueByKey:@"JPUSHCode"] isEqualToString:@"0"] && [Manager shareMgr].haveLogin) {
//        [ELJPush bindAlias:[Manager getUserInfo].userId_];
//    }
     [ELJPush setupWithOption:launchOptions];
    if (launchOptions) {
        NSDictionary *dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        
        [Manager shareMgr].pushViewFlag = YES;
        [Manager shareMgr].isLaunch = YES;
        NSDictionary *apsDic = [dictionary objectForKey:@"aps"];
        id alertDic = [apsDic objectForKey:@"alert"];
        NSString *content;
        if (alertDic && [alertDic isKindOfClass:[NSDictionary class]]) {
            content = [alertDic objectForKey:@"loc-key"];
        }else if (alertDic && [alertDic isKindOfClass:[NSString class]]){
            content = alertDic;
        }

        [Manager shareMgr].offerPartyInterviewTuiSContent = content;
        
        NSMutableDictionary *notifierDic = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [notifierDic setValue:content forKey:@"content"];
        dictionary = notifierDic;
        NSLog(@"%@",[self dictionaryToJson:dictionary]);
        
        [[Manager shareMgr] receiveRemoteNotification:dictionary];
       
    }
    
//    [ELJPush receiveNotification];
    // [2]:注册APNS
//    [self registerRemoteNotification];
    //开启网络监听
    [self AFNReachabilityMonitoring];
    
//#pragma mark - 测试推送铃声
//    [self addLocalNotification];

    //offer派引导
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    [userdefault setBool:YES forKey:@"showOfferPartyGuide"];
    [userdefault synchronize];
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    return YES;
}

//打印奔溃信息
void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
}

#pragma mark - configGoogleAnalytics
-(void)configGoogleAnalytics{
    // Automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Set the dispatch interval for automatic dispatching.
    [GAI sharedInstance].dispatchInterval = 120.0;
    
    // Set the appropriate log level for the default logger.
    [GAI sharedInstance].logger.logLevel = kGAILogLevelVerbose;
    
    // Initialize a tracker using a Google Analytics property ID.
    [[GAI sharedInstance] trackerWithTrackingId:KTrackingID];
}


#pragma mark - configGoogleAnalytics
//-(void)configGoogleAnalytics{
//    id<GAITracker> tracker = [[GAI sharedInstance]trackerWithName:@"yl1001" trackingId:KTrackingID];  //设置追踪器
//    [GAI sharedInstance].trackUncaughtExceptions = YES;  //追踪异常事件
//    [GAI sharedInstance].dispatchInterval = 30;   //追踪数据发送间隔  设置为-1是因为采用后台发送，如果采用自动发送则需要设置发送间隔
//    
//    /********** Sampling Rate **********/
//    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
//    [tracker set:kGAIAppVersion value:version];
//    [tracker set:kGAISampleRate value:@"50.0"]; // sampling rate of 50%
//    
//    NSDictionary *allowTrackingDef = @{KAllowTracking:@(YES)};  //允许追踪
//    [[NSUserDefaults standardUserDefaults]registerDefaults:allowTrackingDef];
//    [GAI sharedInstance].optOut = ![[NSUserDefaults standardUserDefaults]boolForKey:KAllowTracking];  //设置选择退出为否
//}

//谷歌分析进入后台后发送数据方法
- (void)sendHitsInBackground {
    __block BOOL taskExpired = NO;
    __block UIBackgroundTaskIdentifier taskId =
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        taskExpired = YES;
    }];
    
    if (taskId == UIBackgroundTaskInvalid) {
        return;
    }
    __weak __typeof(self) weakSelf = self;
    self.dispatchHandler = ^(GAIDispatchResult result) {
        // Dispatch hits until we have none left, we run into a dispatch error,
        // or the background task expires.
        if (result == kGAIDispatchGood && !taskExpired) {
            [[GAI sharedInstance] dispatchWithCompletionHandler:weakSelf.dispatchHandler];
        } else {
            [[UIApplication sharedApplication] endBackgroundTask:taskId];
        }
    };
    
    [[GAI sharedInstance] dispatchWithCompletionHandler:self.dispatchHandler];
}
/*
#pragma mark 添加本地通知
-(void)addLocalNotification{
    
    //定义本地通知对象
    UILocalNotification *notification=[[UILocalNotification alloc]init];
    //设置调用时间
    notification.fireDate=[NSDate dateWithTimeIntervalSinceNow:10.0];//通知触发的时间，10s以后
    notification.repeatInterval=8;//通知重复次数
    //notification.repeatCalendar=[NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
    
    //设置通知属性
    notification.alertBody=@"最近添加了诸多有趣的特性，是否立即体验？"; //通知主体
    notification.applicationIconBadgeNumber=1;//应用程序图标右上角显示的消息数
    notification.alertAction=@"打开应用"; //待机界面的滑动动作提示
    notification.alertLaunchImage=@"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
    //notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
    notification.soundName=@"msg.caf";//通知声音（需要真机才能听到声音）
    
    //设置用户信息
    notification.userInfo=@{@"id":@1,@"user":@"Kenshin Cui"};//绑定到通知上的其他附加信息
    
    //调用通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}
*/

- (void)AFNReachabilityMonitoring
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                NSLog(@"无网络");
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                NSLog(@"WiFi网络");
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                NSLog(@"无线网络");
                break;
            }
            default:
                break;
        }
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    //记录home时间戳
    NSDate* dat = [[NSDate alloc]init];
    NSString *strDate = [dat stringWithFormatDefault];
    NSUserDefaults *homeDefaults = [[NSUserDefaults alloc]init];
    [homeDefaults setObject:strDate forKey:@"HOMETIMEUSERDEFAULT"];
    [[Manager shareMgr] markUserStatus:1];
    
}

#pragma mark - APPEnterForeground
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    
    
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"WX_PAY_SUCCESS" object:nil userInfo:@{@"errCode":@(0)}];
    
    
    if (self.backgroundTaskIdentifier != UIBackgroundTaskInvalid){
        [self endBackgroundTask];
    }
    
    
    
    //offer派引导
    RootTabBarViewController *rootVc = [Manager shareMgr].tabVC;
    if (rootVc) {
        UINavigationController *selectedVC = rootVc.selectedViewController;
        UIViewController *visiVC = selectedVC.visibleViewController;
        
        if ([visiVC isKindOfClass:[TodayFocusListCtl class]]) {
            TodayFocusListCtl *todayCtl = (TodayFocusListCtl *)visiVC;
            [todayCtl checkForOfferPartys];
        }
    }
}

#pragma mark - APPEnterBackground
- (void)applicationDidEnterBackground:(UIApplication *)application
{
#pragma mark-- 谷歌分析在进入后台后发送数据
//    [self sendHitsInBackground];

    
//    [Manager shareMgr].appState = APPEnterForMessage;
    //语音后台无限时间播放
    if ([self isMultitaskingSupported] == NO){
        return;
    }
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                    target:self
                                                  selector:@selector(timerMethod:) userInfo:nil
                                                   repeats:YES];
    self.backgroundTaskIdentifier = [application beginBackgroundTaskWithExpirationHandler:^(void) { [self endBackgroundTask];
    }];
    _bFromNotification = NO;
    //记录home时间戳
    NSDate* dat = [[NSDate alloc]init];
    NSString *strDate = [dat stringWithFormatDefault];
    NSUserDefaults *homeDefaults = [[NSUserDefaults alloc]init];
    [homeDefaults setObject:strDate forKey:@"HOMETIMEUSERDEFAULT"];
    [[Manager shareMgr] markUserStatus:0];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void) endBackgroundTask{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    __weak AssociationAppDelegate *weakSelf = self;
    dispatch_async(mainQueue, ^(void) {
        AssociationAppDelegate *strongSelf = weakSelf;
        if (strongSelf != nil){
            [strongSelf.myTimer invalidate];
            [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskIdentifier];
            strongSelf.backgroundTaskIdentifier = UIBackgroundTaskInvalid; }
    });
}

- (BOOL) isMultitaskingSupported{
    BOOL result = NO;
    if ([[UIDevice currentDevice]
         respondsToSelector:@selector(isMultitaskingSupported)]){ result = [[UIDevice currentDevice] isMultitaskingSupported];
    }
    return result;
}

- (void) timerMethod:(NSTimer *)paramSender{
    NSTimeInterval backgroundTimeRemaining =
    [[UIApplication sharedApplication] backgroundTimeRemaining];
    if (backgroundTimeRemaining == DBL_MAX){ NSLog(@"Background Time Remaining = Undetermined");
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
#pragma mark-- 谷歌分析 设置谷歌分析的选择退出属性
//    [GAI sharedInstance].optOut = ![[NSUserDefaults standardUserDefaults]boolForKey:KAllowTracking];
    
//    [application setApplicationIconBadgeNumber:0];
//    [application cancelAllLocalNotifications];

//    [Manager shareMgr].appState = APPEnterAPPCon;
    __block int timeout=1;//倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[MyCommon getEnterBackgroundStatus] isEqualToString:@"1"]) {
                    [MyCommon setEnterBackgroundStatus:@"0"];
                }
            });
        }else{
            timeout--;
        }
    });
    dispatch_resume(_timer);
    [UIApplication sharedApplication].applicationIconBadgeNumber= 0;
    [Manager shareMgr].messageCnt_ = 0;
    [[Manager shareMgr] openApp3GPushCtl];
    //[[Manager shareMgr] getCity];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [MyCommon setEnterBackgroundStatus:@"1"];
    [[Manager shareMgr] markUserStatus:1];
    BOOL showTip = [[NSUserDefaults standardUserDefaults] boolForKey:@"showTip"];
    if (showTip) {//第三方登录完善信息关闭程序时
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"showTip"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[Manager shareMgr] loginOut];
        [Manager shareMgr].haveLogin = NO;
    }
}


-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceTokenStr = [token stringByReplacingOccurrencesOfString:@" " withString:@""] ;
    // 注册deviceToke
    [ELJPush registerDeviceToken:deviceToken];
    //将tokenStr写入本地文件中
    [MyCommon haveGetToken:deviceTokenStr];
    //收到tokenStr，设置一下
    [[Manager shareMgr] registNotificeCon:deviceTokenStr user:nil clientName:MyClientName startHour:0 endHour:24 clientVersion:ClientVersion betweenHour:6];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError: %@", error);
}

#pragma mark - AAP后台运行此函数会被调用
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService handleRemoteNotification:userInfo];
    //友盟统计点击数
    [Manager shareMgr].pushViewFlag = YES;

    //选中的推送内容
    NSDictionary *apsDic = [userInfo objectForKey:@"aps"];
    id alertDic = [apsDic objectForKey:@"alert"];
    NSString *content;
    if (alertDic && [alertDic isKindOfClass:[NSDictionary class]]) {
        content = [alertDic objectForKey:@"loc-key"];
    }else if (alertDic && [alertDic isKindOfClass:[NSString class]]){
        content = alertDic;
    }
    //    NSString *content = userInfo[@"aps"][@"alert"][@"loc-key"];
    [Manager shareMgr].offerPartyInterviewTuiSContent = content;
    
    
    NSLog(@"%@",[self dictionaryToJson:userInfo]);
    NSDictionary * dict = @{@"Function":@"点击通知"};
    [MobClick event:@"notificationOnClick" attributes:dict];
    _bFromNotification = YES;
    
    NSMutableDictionary *notifierDic = [NSMutableDictionary dictionaryWithDictionary:userInfo];
    [notifierDic setValue:content forKey:@"content"];
    userInfo = notifierDic;
    NSLog(@"%@",[self dictionaryToJson:userInfo]);
    
    [[Manager shareMgr] receiveRemoteNotification:userInfo];
}

//#ifdef __IPHONE_7_0
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    //友盟统计点击数
    [JPUSHService handleRemoteNotification:userInfo];
    
#pragma mark-- 谷歌分析在进入后台后发送数据
//    [self sendHitsInBackground];
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        return;
    }
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
        
    [Manager shareMgr].pushViewFlag = YES;
    
    //选中的推送内容
    NSDictionary *apsDic = [userInfo objectForKey:@"aps"];
     id alertDic = [apsDic objectForKey:@"alert"];
    NSString *content;
    if (alertDic && [alertDic isKindOfClass:[NSDictionary class]]) {
        content = [alertDic objectForKey:@"loc-key"];
    }else if (alertDic && [alertDic isKindOfClass:[NSString class]]){
        content = alertDic;
    }
//    NSString *content = userInfo[@"aps"][@"alert"][@"loc-key"];
    [Manager shareMgr].offerPartyInterviewTuiSContent = content;
    
    
    NSLog(@"%@",[self dictionaryToJson:userInfo]);
    NSDictionary * dict = @{@"Function":@"点击通知"};
    [MobClick event:@"notificationOnClick" attributes:dict];
    _bFromNotification = YES;
    completionHandler(UIBackgroundFetchResultNewData);
    
//    [userInfo setValue:content forKey:@"content"];
    
    NSMutableDictionary *notifierDic = [NSMutableDictionary dictionaryWithDictionary:userInfo];
    [notifierDic setValue:content forKey:@"content"];
    userInfo = notifierDic;
    NSLog(@"%@",[self dictionaryToJson:userInfo]);
    
    [[Manager shareMgr] receiveRemoteNotification:userInfo];
}
//#endif
 - (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [[UMSocialManager defaultManager] handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"%@----%@---%@", url.host,url.absoluteString,url.relativeString);
    /**
     url.scheme 不能用yl1001，yl1001用于支付
     */
    if ([url.host isEqualToString:@"safepay"] && [url.scheme isEqualToString:@"job1001"]) {//授权登录
        
    }else if([url.host isEqualToString:@"safepay"]) {//alipay支付
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            
        }];
        return YES;
    }else if ([url.host isEqualToString:@"pay"]) {//微信支付
        return [WXApi handleOpenURL:url delegate:self];
    }else if ([url.host isEqualToString:@"percenter"])
    {
        NSDictionary *queryDic = [PayCtl parseQueryString:url.query];
        NSString *userId = queryDic[@"pid"];
        ELPersonCenterCtl *ctl = [[ELPersonCenterCtl alloc] init];
//        [self.navigationController pushViewController:ctl animated:YES];
        [ctl beginLoad:userId exParam:nil];
    }else if ([url.host isEqualToString:@"group"])//社群，打开社群详情
    {
        NSDictionary *queryDic = [PayCtl parseQueryString:url.query];
        NSString *groupId = queryDic[@"gip"];
        ELGroupDetailCtl *detailCtl = [[ELGroupDetailCtl alloc]init];
        Groups_DataModal *dataModal = [[Groups_DataModal alloc] init];
        dataModal.id_ = groupId;
//        [self.navigationController pushViewController:detailCtl animated:YES];
        [detailCtl beginLoad:dataModal exParam:nil];
    }else if ([url.absoluteString containsString:@"yl1001jobClient"]){
        [Manager shareMgr].openAppUrl = url.absoluteString;
    }
    else {
        return  [[UMSocialManager defaultManager] handleOpenURL:url];
    }

    return YES;
}

#pragma mark 微信支付返回的结果
- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[PayResp class]]) {
        NSString *strTitle = [NSString stringWithFormat:@"支付结果"];
        NSString *strMsg = nil;
        if (resp.errCode == 0) {
            strMsg = @"支付成功";
        }else if (resp.errCode == -1) {
            strMsg = @"支付异常，请查看订单详情";
        }else if (resp.errCode == -2) {
            strMsg = @"支付被取消";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
                                                            message:strMsg
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        if ([Manager shareMgr].payType == PayTypeReward) {
            if (resp.errCode != 0) {
                [alert show];
            }
        }
        else
        {
            [alert show];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"WX_PAY_SUCCESS" object:nil userInfo:@{@"errCode":@(resp.errCode)}];
       
    }
}

-  (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
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

#pragma mark - Status bar touch tracking
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    CGPoint location = [[[event allTouches] anyObject] locationInView:[self window]];
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    if (CGRectContainsPoint(statusBarFrame, location)) {
        [self statusBarTouchedAction];
    }
}

- (void)statusBarTouchedAction
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"statusBarTouchedAction" object:nil];
}

@end