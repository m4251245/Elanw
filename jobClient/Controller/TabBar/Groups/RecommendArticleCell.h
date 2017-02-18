//
//  RecommendArticleCell.h
//  jobClient
//
//  Created by 一览iOS on 14-11-27.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendArticleCell : UITableViewCell

@property(nonatomic,weak) IBOutlet   UIImageView    *picImgv_;
@property(nonatomic,weak) IBOutlet   UILabel        *titleLb_;
@property(nonatomic,weak) IBOutlet   UILabel        *contentLb_;
@property(nonatomic,weak) IBOutlet   UIView         *bgView_;
//@property(nonatomic,weak) IBOutlet   UIButton       *recommendListBtn_;
//@property(nonatomic,weak) IBOutlet   UIView         *topView_;
//@property(nonatomic,weak) IBOutlet   UILabel         *topLb_;
@property(nonatomic,weak) IBOutlet   UIButton         *deleteBtn_;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bagViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLeftWidth;
@property (weak, nonatomic) IBOutlet UIImageView *attentionImage;

- (void)initCellWithTitle:(NSString *)title_ personImg:(NSString *)img_ content:(NSString *)content_ indexPath:(NSIndexPath *)indexPath_;

@end
