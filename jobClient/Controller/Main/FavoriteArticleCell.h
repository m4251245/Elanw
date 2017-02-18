//
//  FavoriteArticleCell.h
//  jobClient
//
//  Created by 一览ios on 15/8/14.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoriteArticleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *photoImgv;

@property (weak, nonatomic) IBOutlet UILabel *titleLb;

@property (weak, nonatomic) IBOutlet UILabel *contentLb;

@property (weak, nonatomic) IBOutlet UILabel *timeLb;

@end
