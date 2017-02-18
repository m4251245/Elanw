//
//  NSMutableAttributedString+NewClass.m
//  jobClient
//
//  Created by 一览iOS on 17/1/4.
//  Copyright © 2017年 YL1001. All rights reserved.
//

#import "NSMutableAttributedString+NewClass.h"

@implementation NSMutableAttributedString (NewClass)

-(void)setChangeKeyWord:(NSString *)keyWord color:(UIColor *)color{
    if (!keyWord || [keyWord isEqualToString:@""] || !color) {
        return;
    }
    if ([self.string rangeOfString:keyWord options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        for (NSInteger i = 0; i<=(self.string.length-keyWord.length) ;i++)
        {
            NSString *str = [self.string substringWithRange:NSMakeRange(i,keyWord.length)];
            if ([str rangeOfString:keyWord options:NSCaseInsensitiveSearch].location != NSNotFound)
            {
                [self addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(i,keyWord.length)];
            }
        }
    }
}

@end
