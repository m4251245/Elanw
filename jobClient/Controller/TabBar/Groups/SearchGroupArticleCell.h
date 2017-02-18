//
//  SearchGroupArticleCell.h
//  jobClient
//
//  Created by 一览ios on 14-12-19.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchGroupArticleCell : UITableViewCell

@property(nonatomic,weak) IBOutlet UILabel      *titleLb;
@property(nonatomic,weak) IBOutlet UILabel      *contentLb;
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UIImageView *lineImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLableTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineImageLeftW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleImageLeftW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLableLeftW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewTopW;

@end
