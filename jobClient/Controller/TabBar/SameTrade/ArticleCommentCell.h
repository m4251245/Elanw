//
//  ArticleCommentCell.h
//  jobClient
//
//  Created by 一览iOS on 14-10-24.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleCommentCell : UITableViewCell

@property(nonatomic,weak) IBOutlet UIImageView  *photoImgv_;
@property(nonatomic,weak) IBOutlet UILabel      *nameLb_;
@property(nonatomic,weak) IBOutlet UILabel      *articleContentLb_;
@property(nonatomic,weak) IBOutlet UILabel      *articleDescLb_;
@property(nonatomic,weak) IBOutlet UILabel      *articleTimeLb_;
@property(nonatomic,weak) IBOutlet UIImageView  *tipsNewImgv_;
@property(nonatomic,weak) IBOutlet UIView       *backgroundView_;

@end
