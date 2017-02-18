//
//  LineSpaceHelper.m
//  jobClient
//
//  Created by 一览ios on 16/5/19.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "LineSpaceHelper.h"

@implementation LineSpaceHelper

+(NSAttributedString *)dealStrWithLineSpace:(NSString *)str{
    NSMutableAttributedString * bString = [[NSMutableAttributedString alloc]initWithString:str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];//调整行间距
    [bString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, str.length)];
    return bString;
}

+(NSAttributedString *)dealTitleColor:(NSString *)str{
    NSMutableAttributedString * bString = [[NSMutableAttributedString alloc]initWithString:str];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:4];//调整行间距
    [bString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x333333) range:NSMakeRange(0, 5)];
    return bString;
}

@end
