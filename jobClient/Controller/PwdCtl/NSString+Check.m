//
//  NSString+Check.m
//  Association
//
//  Created by 一览iOS on 14-6-19.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "NSString+Check.h"

@implementation NSString (Check)

//手机号码判断
- (BOOL)isMobileNumValid
{
    NSString * PHS = @"1[3|4|5|7|8|9][0-9]{9}";
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    BOOL result = [regextestct evaluateWithObject:self];
    return result;
}

//固定电话判断
- (BOOL)checkNumber{
    
    NSString *strNum = @"^(0\\d{2,3}-{0,1}\\d{7,8})$";
    
    NSPredicate *checktest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strNum];
    return [checktest evaluateWithObject:self];
}

/**
 *  空字符串处理
 */
-(BOOL)isNull
{
    // 判断是否为空串
    if ([self isEqual:[NSNull null]]) {
        return YES;
    }
    else if ([self isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    else if (self == nil){
        return YES;
    }
    else if ([self isEqualToString:@""]){
        return YES;
    }
    return NO;
}

+ (NSString *)changeNullOrNil:(NSString *)string;
{
    if ([string isEqual:[NSNull null]] || string == nil) {
        return @"0";
    }else{
        return string;
    }
}

+ (NSString *)changeNull:(NSString *)string
{
    if ([string isEqual:[NSNull null]] || string == nil) {
        return @"";
    }
    return string;
}

+ (NSString *)httpToHttps:(NSString *)string
{
    return string;
    
    if ([string isKindOfClass:[NSString class]]) {
        NSString *resultStr;
        //只替换开头
        if ([string hasPrefix:@"http"] && ![string hasPrefix:@"https"]) {
            resultStr = [string substringWithRange:NSMakeRange(4, string.length-4)];
            resultStr = [NSString stringWithFormat:@"https%@",resultStr];
            
            return resultStr;
        }
        return string;
    }
    return @"";
}

+ (BOOL)domainNameConstantString:(NSString *)urlStr
{
    for (NSString *string in [Manager shareMgr].getUrlArr) {
        if ([urlStr containsString:string]) {
            return YES;
        }
    }
    return NO;
}

@end
