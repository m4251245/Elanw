//
//  RecommendArticleCell.m
//  jobClient
//
//  Created by 一览iOS on 14-11-27.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "RecommendArticleCell.h"
#import "MyConfig.h"
#import "NSString+Size.h"
#import "UIImageView+WebCache.h"

@implementation RecommendArticleCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initCellWithTitle:(NSString *)title_ personImg:(NSString *)img_ content:(NSString *)content_ indexPath:(NSIndexPath *)indexPath_;
{
    self.bgView_.layer.borderWidth = 0.5;
    self.bgView_.layer.borderColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0].CGColor;
    self.picImgv_.layer.cornerRadius = 2.0;
    self.picImgv_.layer.masksToBounds = YES;
    [self.titleLb_ setFont:SEVENTEENFONT_FRISTTITLE];
    [self.titleLb_ setTextColor:BLACKCOLOR];
    [self.contentLb_ setFont:FIFTEENFONT_TITLE];
    [self.contentLb_ setTextColor:GRAYCOLOR];

    _bagViewTop.constant = -1;
    [self.picImgv_ sd_setImageWithURL:[NSURL URLWithString:img_] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
    [self.titleLb_ setText:title_];
    NSMutableAttributedString *str = [[Manager shareMgr] getEmojiStringWithString:content_ withImageSize:CGSizeMake(18,18)];
    [self.contentLb_ setAttributedText:str];
    self.contentLb_.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleLb_.lineBreakMode = NSLineBreakByTruncatingTail;
}

@end
