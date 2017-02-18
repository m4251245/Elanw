//
//  ELUserDefault.h
//  jobClient
//
//  Created by 一览ios on 16/4/13.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kLocationCityName @"location_city_name"

#define kUserDefaults(object,key) [[NSUserDefaults standardUserDefaults] setObject:object forKey:key] // 写
#define kUserSynchronize [[NSUserDefaults standardUserDefaults] synchronize] // 存
#define getUserDefaults(key) [[NSUserDefaults standardUserDefaults] objectForKey:key] // 取


#define kAllNums [NSString stringWithFormat:@"%@isAllNums",[Manager getUserInfo].userId_]//所有的消息小红点数

@interface ELUserDefault : NSObject
//保存用户登录状态
+(void)setUserLoginStatus:(BOOL)status;

//获取用户登录状态
+(BOOL)getUserLoginStatus;

//记录home时间戳
+(void)setHomeTimeUserDefault:(NSString *)time;

//获取home时间戳
+(NSString *)getHomeTimeUserDefault;

//设置三方登录是否完善信息
+(void)setPerfectInformation:(BOOL)showTip;

+(BOOL)getPerfectInfomation;

//社群头像是否弹框
+(void)setGroupHeadisPlay:(NSString *)time;

+(NSString *)getGroupHeadisPlay;

//是否显示新图标
+(void)setShowNewHead:(NSString *)time;

+(NSString *)getShowNewHead;

//公司地址
+ (void)setCompanyAddress:(NSString *)address;

+ (NSString *)getCompanyAddress;

//顾问端推荐理由
+ (void)setRecommendContent:(NSString *)content;

+ (NSString *)getRecommendContent;

//账户是否绑定手机
+ (void)setBindPhoneStatus:(BOOL)status;

+ (BOOL)getBindPhoneStatus;
@end
