//
//  NSString+Size.h
//  jobClient
//
//  Created by 一览iOS on 16/5/17.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Size)

-(CGSize)sizeNewWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
-(CGSize)sizeNewWithFont:(UIFont *)font;
- (CGSize)sizeNewWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (CGSize)sizeNewWithFont:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode;

-(NSMutableAttributedString *)getHtmlAttString;
-(NSMutableAttributedString *)getHtmlAttStringWithFont:(UIFont *)font color:(UIColor *)color;

-(NSDate *)dateFormStringFormat:(NSString *)format;
-(NSDate *)dateFormStringCurrentLocaleFormat:(NSString *)format;
-(NSDate *)dateFormStringFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone;

//字符串反转
-(NSMutableString*)Reverse;

@end
