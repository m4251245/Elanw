//
//  ELJPush.m
//  jobClient
//
//  Created by 一览ios on 16/8/6.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELJPush.h"
//企业 1c65aeabcd7760a285256a19  线上 fd0dd7b8733f1ff8a5e099dc
//static NSString *appKey = @"fd0dd7b8733f1ff8a5e099dc";
static NSString *channel = @"App Store";
#if DEBUG //0 开发证书 1生产证书
static BOOL isProduction = NO;
static NSString *appKey = @"1c65aeabcd7760a285256a19";
#else
static BOOL isProduction = YES;
static NSString *appKey = @"fd0dd7b8733f1ff8a5e099dc";
#endif
@implementation ELJPush

#pragma mark - required
//初始化
+ (void)setupWithOption:(NSDictionary *)launchOptions
{
    
   
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
      //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
}

+ (void)registerDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
  
}

+ (void)handleRemoteNotification:(NSDictionary *)userInfo completion:(void (^)(UIBackgroundFetchResult))completion {
    [JPUSHService handleRemoteNotification:userInfo];
    
    if (completion) {
        completion(UIBackgroundFetchResultNewData);
    }
   
}

+ (void)bindAlias:(NSString *)alias
{
//    [JPUSHService setAlias:alias callbackSelector:nil object:nil];
    [JPUSHService setTags:[NSSet set] alias:alias fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        //绑定或解绑成功 iResCode = 0
        [CommonConfig setDBValueByKey:@"JPUSHCode" value:[NSString stringWithFormat:@"%d",iResCode]];
        
    }];
}

#pragma mark - JPush Notification
+ (void)receiveNotification
{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJPFNetworkDidSetupNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidClose:)
                          name:kJPFNetworkDidCloseNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidRegister:)
                          name:kJPFNetworkDidRegisterNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidReceiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(serviceError:)
                          name:kJPFServiceErrorNotification
                        object:nil];
}

- (void)networkDidSetup:(NSNotification *)notification
{
    NSLog(@"已连接");
}

- (void)networkDidClose:(NSNotification *)notification
{
    NSLog(@"未连接");
}

- (void)networkDidRegister:(NSNotification *)notification
{
    NSLog(@"已注册");
}

- (void)networkDidLogin:(NSNotification *)notification
{
    NSLog(@"已登录");
}

- (void)networkDidReceiveMessage:(NSNotification *)notification
{
//    NSDictionary *userInfo = notification.userInfo;
//    NSString *title = [userInfo valueForKey:@"title"];
//    NSLog(@"%@",title);
}

- (void)serviceError:(NSNotification *)notification
{
//    NSDictionary *userInfo = notification.userInfo;
////    NSString *error = [userInfo valueForKey:@"error"];
//    NSLog(@"error--%@",error);
}

#pragma mark - optional
+ (void)setTags:(NSSet *)tags alias:(NSString *)alias callbackSelector:(SEL)cbSelector object:(id)theTarget
{
    [JPUSHService setTags:tags alias:alias callbackSelector:cbSelector object:self];
}
@end
