//
//  GroupArticle_Cell.h
//  Association
//
//  Created by YL1001 on 14-6-30.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupArticle_Cell : UITableViewCell

@property(nonatomic,weak) IBOutlet UIImageView  * userImg_;
@property(nonatomic,weak) IBOutlet UILabel      * titleLb_;
@property(nonatomic,weak) IBOutlet UILabel      * timeLb_;
@property(nonatomic,weak) IBOutlet UILabel      * contentLb_;
@property(nonatomic,weak) IBOutlet UILabel      * cCntLb_;
@property(nonatomic,weak) IBOutlet UIView       * commentView_;
@property(nonatomic,weak) IBOutlet UILabel      * zhiyeNameLb_;
@property(nonatomic,weak) IBOutlet UIImageView  * commentImg_;

@property(nonatomic,weak) IBOutlet  UIButton    *   likeBtn_;
@property(nonatomic,weak) IBOutlet  UIButton    *   shareBtn_;
@property(nonatomic,weak) IBOutlet  UIButton    *   commentBtn_;
@property(nonatomic,weak) IBOutlet  UIButton    *   commentCntBtn_;
@property(nonatomic,weak) IBOutlet  UIButton    *   addCommentBtn_;
@property(nonatomic,weak) IBOutlet  UIView      *   contentView_;

@end
