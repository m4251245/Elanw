//
//  YLTheTopicCell.h
//  jobClient
//
//  Created by 一览iOS on 15/6/19.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article_DataModal.h"
@class ELSalaryModel;

@protocol YLTheTopicCellDeletage <NSObject>

-(void)changeBtnModal:(YLVoteDataModal *)modal indexPath:(NSIndexPath *)path;

@end

@interface YLTheTopicCell : UITableViewCell

@property(weak,nonatomic) id <YLTheTopicCellDeletage> cellDelegate;

@property (weak, nonatomic) IBOutlet UILabel *joinCountLb;

@property (weak, nonatomic) IBOutlet UILabel *joinTitleLb;

@property (weak, nonatomic) IBOutlet UIView *shareVIew;

@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imageLine;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLableHeight;

@property(strong,nonatomic) NSMutableArray *arrListData;

@property(strong,nonatomic) UIView *contentViewOne;

-(void)giveDateModal:(ELSalaryModel *)modal;

@end
