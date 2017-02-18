//
//  ELCommentStarCell.h
//  jobClient
//
//  Created by 一览iOS on 15/11/3.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Expert_DataModal.h"

@interface ELCommentStarCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (strong, nonatomic) IBOutlet UILabel *sourceLb; /**<评价来源 */

@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UIImageView *lineImage;
@property (weak, nonatomic) IBOutlet UIView *starView;


-(void)giveDataModal:(Expert_DataModal *)model;

@end
