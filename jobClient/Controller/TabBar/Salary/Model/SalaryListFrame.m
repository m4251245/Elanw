//
//  SalaryListFrame.m
//  jobClient
//
//  Created by 一览ios on 15/4/24.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "SalaryListFrame.h"
#import "Article_DataModal.h"
#import "MLEmojiLabel.h"
#import "MyConfig.h"
#import "ELSalaryModel.h"

@implementation SalaryListFrame

- (void)setArticleModel:(ELSalaryModel *)articleModel
{
    NSString *jingHua = articleModel.is_jing;
    if (jingHua) {
        _jingHuaLbFrame = CGRectMake((320-kContentWidth)/2, kMarginTop, 320, 20);
    }
    MLEmojiLabel *emoji = [self emojiLabel:articleModel.content numberOfLines:5 textColor:UIColorFromRGB(0x333333)];
    emoji.frame = CGRectMake(0, 0, kContentWidth, 0);
    [emoji sizeToFit];
    CGFloat emojiY ;
    if (jingHua) {
        emojiY =CGRectGetMaxY(_jingHuaLbFrame) +kJingHuaMarginBottom;
    }else{
        emojiY = kMarginTop;
    }
    _contentLbFrame = CGRectMake( (320-kContentWidth)/2, emojiY, kContentWidth, emoji.frame.size.height);
    CGFloat toolBarY = CGRectGetMaxY(_contentLbFrame) + kToolBarMarginTop;
    _toolBarFrame = CGRectMake(0, toolBarY, 320, kToolBarHeight);
    _height = CGRectGetMaxY(_toolBarFrame) + kToolBarMarginBottom;
    _lineFrame = CGRectMake(-10, _height-1, 340, 1);
}

-(MLEmojiLabel *)emojiLabel:(NSString *)text numberOfLines:(int)num textColor:(UIColor *)color
{
    MLEmojiLabel * emojiLabel;
    emojiLabel = [[MLEmojiLabel alloc]init];
    emojiLabel.numberOfLines = num;
    emojiLabel.font = FIFTEENFONT_TITLE;
    emojiLabel.lineBreakMode = NSLineBreakByCharWrapping;
    if (color) {
        emojiLabel.textColor = color;
    }
    emojiLabel.backgroundColor = [UIColor clearColor];
    emojiLabel.textAlignment = NSTextAlignmentCenter;
    emojiLabel.lineSpacing = 10.0;
    emojiLabel.isNeedAtAndPoundSign = YES;
    emojiLabel.customEmojiRegex = Custom_Emoji_Regex;
    emojiLabel.customEmojiPlistName = @"emoticons.plist";
    [emojiLabel setEmojiText:text];
    return emojiLabel;
}

@end
