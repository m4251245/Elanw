//
//  NSString+Size.m
//  jobClient
//
//  Created by 一览iOS on 16/5/17.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

-(CGSize)sizeNewWithFont:(UIFont *)font constrainedToSize:(CGSize)size{
    NSDictionary *attributes = @{NSFontAttributeName: font};
    CGRect rect = [self boundingRectWithSize:size
                                     options:NSStringDrawingTruncatesLastVisibleLine |
                   NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading
                                           attributes:attributes
                                              context:nil];
//    CGSize rect = [self sizeWithFont:font constrainedToSize:size];
    return rect.size;
}

-(CGSize)sizeNewWithFont:(UIFont *)font{
    CGSize textSize = [self sizeWithAttributes:@{ NSFontAttributeName :font}];
    return textSize;
}

- (CGSize)sizeNewWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode{
   return [self sizeNewWithFont:font constrainedToSize:size];
}

- (CGSize)sizeNewWithFont:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode{
    return [self sizeNewWithFont:font constrainedToSize:CGSizeMake(width,10000000)];
}

-(NSMutableAttributedString *)getHtmlAttString{
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[self dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    return attrStr;
}

-(NSMutableAttributedString *)getHtmlAttStringWithFont:(UIFont *)font color:(UIColor *)color{
    NSMutableAttributedString * attrStr = [self getHtmlAttString];
    if (font){
        [attrStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,attrStr.length)];
    }
    if (color){
        [attrStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0,attrStr.length)];
    }
    return attrStr;
}

//反转
-(NSMutableString*)Reverse
{
    const char *str = [self UTF8String];
    NSUInteger length = [self length];
    char *pReverse = (char*)malloc(length+1);//动态分配空间
    strcpy(pReverse, str);
    for(int i=0; i<length/2; i++)
    {
        char c = pReverse[i];
        pReverse[i] = pReverse[length-i-1];
        pReverse[length-i-1] = c;
    }
    NSMutableString *pstr = [NSMutableString stringWithUTF8String:pReverse];
    free(pReverse);
    return pstr;
}

-(NSDate *)dateFormStringFormat:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_cn"]];
    [formatter setDateFormat:format];
    return [formatter dateFromString:self];
}

-(NSDate *)dateFormStringCurrentLocaleFormat:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_cn"]];
//    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:format];
    return [formatter dateFromString:self];
}

-(NSDate *)dateFormStringFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_cn"]];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:format];
    return [formatter dateFromString:self];
}

@end
