//
//  GXSArticleLIst_Cell.h
//  jobClient
//
//  Created by YL1001 on 14-9-25.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GXSArticleLIst_Cell : UITableViewCell

@property(nonatomic,weak) IBOutlet  UIImageView     *   userImg_;
@property(nonatomic,weak) IBOutlet  UILabel         *   titleLb_;
@property(nonatomic,weak) IBOutlet  UILabel         *   contentLb_;
@property(nonatomic,weak) IBOutlet  UIButton        *   likeBtn_;
@property(nonatomic,weak) IBOutlet  UIButton        *   commentBtn_;
@property(nonatomic,weak) IBOutlet  UIButton        *   shareBtn_;
@property(nonatomic,weak) IBOutlet  UIButton        *   addCommentBtn_;
@property(nonatomic,weak) IBOutlet  UIView          *   contentView_;

@end
