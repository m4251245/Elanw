//
//  NSString+Check.h
//  Association
//
//  Created by 一览iOS on 14-6-19.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Check)

//手机号校验
- (BOOL)isMobileNumValid;
//固定电话校验
- (BOOL)checkNumber;

//空字符串处理
-(BOOL)isNull;
//空字符串换成0
+ (NSString *)changeNullOrNil:(NSString *)string;
//将Null to @""
+ (NSString *)changeNull:(NSString *)string;
//将http协议改为https
+ (NSString *)httpToHttps:(NSString *)string;
//判断是否是域名白名单
+ (BOOL)domainNameConstantString:(NSString *)urlStr;

@end
