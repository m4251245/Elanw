//
//  ELUserDefault.m
//  jobClient
//
//  Created by 一览ios on 16/4/13.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELUserDefault.h"

@implementation ELUserDefault
NSString *const kUserLoginStatus = @"kUserLoginStatus";
NSString *const kHomeTimeUserDefault = @"kHomeTimeUserDefault";
NSString *const kShowTip = @"kShowTip";
NSString *const kGroupHeadisPlay = @"kGroupHeadisPlay";
NSString *const kShowNewHead = @"kShowNewHead";
NSString *const kCompanyAddress = @"kCompanyAddress";
NSString *const kRecommendContent = @"kRecommendContent";
NSString *const kTabViewType = @"kTabViewType";
NSString *const kBindPhone = @"kBindPhone";

//@end
//@implementation ELUserDefault
+(void)setUserLoginStatus:(BOOL)status
{
    [[NSUserDefaults standardUserDefaults] setBool:status forKey:kUserLoginStatus];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)getUserLoginStatus
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:kUserLoginStatus] boolValue];
}

+(void)setHomeTimeUserDefault:(NSString *)time
{
    [[NSUserDefaults standardUserDefaults] setObject:time forKey:kHomeTimeUserDefault];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//获取home时间戳
+(NSString *)getHomeTimeUserDefault
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kHomeTimeUserDefault];
}

+(void)setPerfectInformation:(BOOL)showTip
{
    [[NSUserDefaults standardUserDefaults] setBool:showTip forKey:kShowTip];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)getPerfectInfomation
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kShowTip];
}

+(void)setGroupHeadisPlay:(NSString *)time
{
    [[NSUserDefaults standardUserDefaults] setObject:time forKey:kGroupHeadisPlay];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)getGroupHeadisPlay
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kGroupHeadisPlay];
}

+(void)setShowNewHead:(NSString *)time
{
    [[NSUserDefaults standardUserDefaults] setObject:time forKey:kShowNewHead];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)getShowNewHead
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kShowNewHead];
}


+ (void)setCompanyAddress:(NSString *)address
{
    [[NSUserDefaults standardUserDefaults] setObject:address forKey:kCompanyAddress];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getCompanyAddress
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kCompanyAddress];
}

+ (void)setRecommendContent:(NSString *)content
{
    [[NSUserDefaults standardUserDefaults] setObject:content forKey:kRecommendContent];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getRecommendContent
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kRecommendContent];
}

+ (void)setBindPhoneStatus:(BOOL)status
{
    [[NSUserDefaults standardUserDefaults] setBool:status forKey:kBindPhone];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)getBindPhoneStatus
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kBindPhone];
}

@end
