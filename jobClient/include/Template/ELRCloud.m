//
//  ELRCloud.m
//  jobClient
//
//  Created by 一览ios on 16/9/19.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELRCloud.h"
#import <RongIMKit/RongIMKit.h>
#import "RCDataBaseManager.h"

@implementation ELRCloud

+ (void)setUpRCIM
{
    [[RCIM sharedRCIM] initWithAppKey:@"vnroth0krv7do"];
    //开启用户信息和群组信息的持久化
    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
    //设置接收消息代理
    
    
//    [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(46, 46);
    
    //开启输入状态监听
    [RCIM sharedRCIM].enableTypingStatus = YES;
    
    //开启发送已读回执
//    [RCIM sharedRCIM].enabledReadReceiptConversationTypeList = @[@(ConversationType_PRIVATE)];
    //设置显示未注册的消息
    [RCIM sharedRCIM].showUnkownMessage = YES;
    [RCIM sharedRCIM].showUnkownMessageNotificaiton = YES;
}

+ (void)getRCtoken:(NSString *)userId
{
    NSMutableString *bodyMsg = [NSMutableString stringWithFormat:@"person_id=%@",userId];
    [ELRequest postbodyMsg:bodyMsg op:@"person_busi" func:@"get_rongcloud_token" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)result;
            if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
                NSString *token = [dic objectForKey:@"token"];
                [DEFAULTS setObject:token forKey:@"token"];
                [DEFAULTS synchronize];
                
                //                  [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
                [self connectRCloud:token];
                
            }
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

+ (void)connectRCloud:(NSString *)token
{
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        
        //        [RCDHTTPTOOL getUserInfoByUserID:userId completion:^(RCUserInfo *user) {
        //            [DEFAULTS setObject:user.userId forKey:@"userId"];
        //            [DEFAULTS setObject:user.portraitUri forKey:@"portraitUri"];
        //            [DEFAULTS setObject:user.name forKey:@"userNickName"];
        //            [DEFAULTS synchronize];
        //
        //        }];
        RCUserInfo *user = [[RCUserInfo alloc] initWithUserId:[DEFAULTS objectForKey:@"userId"] name:[DEFAULTS objectForKey:@"userNickName"] portrait:[DEFAULTS objectForKey:@"portraitUri"]];
        
        [[RCDataBaseManager shareInstance] insertUserToDB:user];
        [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:userId];
        [RCIM sharedRCIM].currentUserInfo = user;
        
    } error:^(RCConnectErrorCode status) {
        
    } tokenIncorrect:^{
        
    }];
    
}

+ (void)refreshRCloud:(RCUserInfo *)user withUserId:(NSString *)userid
{
    [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:userid];
}
@end
