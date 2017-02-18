//
//  ArticleFavoritListCell.h
//  jobClient
//
//  Created by 一览ios on 14/12/13.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Article_DataModal;

@interface ArticleFavoritListCell : UITableViewCell

@property (weak,nonatomic ) IBOutlet    UILabel  *titleLb;

@property (weak, nonatomic) IBOutlet    UILabel  *summaryLb;

@property (weak, nonatomic) IBOutlet    UILabel  *typeNameLb;

- (void)setArticle:(Article_DataModal *)article;

- (void)setAttr;

@end
