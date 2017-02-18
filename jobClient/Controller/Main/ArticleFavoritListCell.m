//
//  ArticleFavoritListCell.m
//  jobClient
//
//  Created by 一览ios on 14/12/13.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "ArticleFavoritListCell.h"
#import "Article_DataModal.h"
#import "MyConfig.h"

@implementation ArticleFavoritListCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setAttr
{
    [_titleLb setFont:FIFTEENFONT_TITLE];
    [_summaryLb setFont:TWEELVEFONT_COMMENT];
}

- (void)setArticle:(Article_DataModal *)article
{
    _titleLb.text = article.title_;
    _summaryLb.text = article.summary_;
}

@end
