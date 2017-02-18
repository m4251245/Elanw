//
//  ELRCloud.h
//  jobClient
//
//  Created by 一览ios on 16/9/19.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELRCloud : NSObject<RCIMReceiveMessageDelegate,RCIMConnectionStatusDelegate>

+ (void)setUpRCIM;

//+ (void)loginRongCloud;


+ (void)getRCtoken:(NSString *)userId;//获取token

+ (void)connectRCloud:(NSString *)token;//连接融云服务器

+ (void)refreshRCloud:(RCUserInfo *)user withUserId:(NSString *)userid;//刷新用户缓存信息

+ (void)clearUserInfoCache;
@end
