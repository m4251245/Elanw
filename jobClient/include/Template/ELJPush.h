//
//  ELJPush.h
//  jobClient
//
//  Created by 一览ios on 16/8/6.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JPUSHService.h"

@interface ELJPush : NSObject
//初始化
+ (void)setupWithOption:(NSDictionary *)launchOptions;

+ (void)registerDeviceToken:(NSData *)deviceToken;

+ (void)handleRemoteNotification:(NSDictionary *)userInfo completion:(void (^)(UIBackgroundFetchResult))completion;
//绑定别名
+ (void)bindAlias:(NSString *)alias;

+ (void)receiveNotification;
/*
 * 
 alias
 nil 此次调用不设置此值。
 空字符串 （@""）表示取消之前的设置。
 每次调用设置有效的别名，覆盖之前的设置。
 有效的别名组成：字母（区分大小写）、数字、下划线、汉字。
 限制：alias 命名长度限制为 40 字节。（判断长度需采用UTF-8编码）
 
 tags
 nil 此次调用不设置此值。
 空集合（[NSSet set]）表示取消之前的设置。
 集合成员类型要求为NSString类型
 每次调用至少设置一个 tag，覆盖之前的设置，不是新增。
 有效的标签组成：字母（区分大小写）、数字、下划线、汉字。
 限制：每个 tag 命名长度限制为 40 字节，最多支持设置 1000 个 tag，但总长度不得超过7K字节。（判断长度需采用UTF-8编码）
 单个设备最多支持设置 1000 个 tag。App 全局 tag 数量无限制。
 
 callbackSelector
 nil 此次调用不需要 Callback。
 用于回调返回对应的参数 alias, tags。并返回对应的状态码：0为成功，其他返回码请参考错误码定义。
 回调函数请参考SDK 实现。
 
 theTarget
 参数值为实现了callbackSelector的实例对象。
 nil 此次调用不需要 Callback。
 */
+ (void)setTags:(NSSet *)tags alias:(NSString *)alias callbackSelector:(SEL)cbSelector object:(id)theTarget;

@end
