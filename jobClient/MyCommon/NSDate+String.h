//
//  NSDate+String.h
//  jobClient
//
//  Created by 一览iOS on 16/10/18.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (String)

-(NSString *)stringWithFormat:(NSString *)format;
-(NSString *)stringWithFormatDefault;
-(NSString *)stringWithFormatCurrent:(NSString *)format;
-(NSString *)stringWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone behavior:(NSDateFormatterBehavior)behavior;

@end
