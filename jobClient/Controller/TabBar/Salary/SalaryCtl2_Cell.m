//
//  SalaryCtl2_Cell.m
//  jobClient
//
//  Created by 一览ios on 15/4/24.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "SalaryCtl2_Cell.h"
#import "Article_DataModal.h"
#import "MLEmojiLabel.h"
#import "SalaryListFrame.h"
#import "MyConfig.h"

#define kEmojiTagId 1006

@implementation SalaryCtl2_Cell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setArticleModel:(Article_DataModal *)articleModel
{
    SalaryListFrame *cellFrame = articleModel.cellFrame;
    if (articleModel.isJing_) {
        _jingHuaLb.hidden = NO;
//        _jingHuaLb.frame = cellFrame.jingHuaLbFrame;
        _jingHuaLb.text = [NSString stringWithFormat:@"%@", articleModel.isJing_];
    }else{
        _jingHuaLb.hidden = YES;
    }
    MLEmojiLabel *emojiLabel = (MLEmojiLabel *)[self.contentView viewWithTag:kEmojiTagId];
    if (!emojiLabel) {
        emojiLabel = [self emojiLabel:articleModel.content_ numberOfLines:5 textColor:UIColorFromRGB(0x333333)];
        emojiLabel.tag = kEmojiTagId;
        [self.contentView addSubview:emojiLabel];
    }
    emojiLabel.frame = cellFrame.contentLbFrame;
    emojiLabel.emojiText = articleModel.content_;
//    _toolBar.frame = cellFrame.toolBarFrame;
//    _lineImgv.frame = cellFrame.lineFrame;
    [_likeBtn setTitle:[NSString stringWithFormat:@"%ld", (long)articleModel.likeCount_] forState:UIControlStateNormal];
    [_commentBtn setTitle:[NSString stringWithFormat:@"%ld", (long)articleModel.commentCount_] forState:UIControlStateNormal];
    //赞过
    if (articleModel.isLike_) {
        [_likeBtn setImage:[UIImage imageNamed:@"addLikeSeleted.png"] forState:UIControlStateNormal];
        [_likeBtn setTitleColor:FONEREDCOLOR forState:UIControlStateNormal];
    }else{
        [_likeBtn setImage:[UIImage imageNamed:@"addLikeNormal.png"] forState:UIControlStateNormal];
        [_likeBtn setTitleColor:GRAYCOLOR forState:UIControlStateNormal];
    }
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
    emojiLabel.lineSpacing = 10.0;
    emojiLabel.textAlignment = NSTextAlignmentCenter;
    emojiLabel.isNeedAtAndPoundSign = YES;
    emojiLabel.customEmojiRegex = Custom_Emoji_Regex;
    emojiLabel.customEmojiPlistName = @"emoticons.plist";
    [emojiLabel setEmojiText:text];
    return emojiLabel;
}
@end
