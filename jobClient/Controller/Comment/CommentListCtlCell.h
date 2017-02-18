//
//  CommentListCtlCell.h
//  jobClient
//
//  Created by 一览ios on 14/11/20.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//


#import <UIKit/UIKit.h>
@class Comment_DataModal;
@class ELGroupCommentModel;
@class ELButtonView;

@interface CommentListCtlCell : UITableViewCell
//头像
@property (weak, nonatomic) IBOutlet UIButton *picBtn_;

//用户名
@property (weak, nonatomic) IBOutlet UILabel *nameLb_;

//创建日期
@property (weak, nonatomic) IBOutlet UILabel *dateLb_;
//赞
@property (weak, nonatomic) IBOutlet UIButton *likeBtn_;
@property (strong, nonatomic) ELButtonView *commentLb;
@property (weak, nonatomic) IBOutlet UILabel *parentLb;
@property (weak, nonatomic) IBOutlet UIButton *exceptionalBtn;

@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLb;

//没有评论内容 父评论引用显示的图片
@property (weak, nonatomic) IBOutlet UIImageView *noCommentPic;

@property(nonatomic,strong) ELGroupCommentModel *dataModal;



@end
