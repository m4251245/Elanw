//
//  NSDate+String.m
//  jobClient
//
//  Created by 一览iOS on 16/10/18.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "NSDate+String.h"

@implementation NSDate (String)

-(NSString *)stringWithFormatCurrent:(NSString *)format{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:format];
    [df setLocale:[NSLocale currentLocale]];
    NSString *str = [df stringFromDate:self];
    if (!str) {
        str = @"";
    }
    return str;
}

-(NSString *)stringWithFormat:(NSString *)format{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:format];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_cn"]];
    NSString *str = [df stringFromDate:self];
    if (!str) {
        str = @"";
    }
    return str;
}

-(NSString *)stringWithFormatDefault{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_cn"]];
    NSString *str = [df stringFromDate:self];
    if (!str) {
        str = @"";
    }
    return str;
}

-(NSString *)stringWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone behavior:(NSDateFormatterBehavior)behavior{
    NSDateFormatter * dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setTimeZone:timeZone];
    [dateformatter setFormatterBehavior:behavior];
    [dateformatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_cn"]];
    [dateformatter setDateFormat:format];
    return [dateformatter stringFromDate:self];
}

@end
