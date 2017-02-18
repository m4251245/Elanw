//
//  JobCell.h
//  jobClient
//
//  Created by 一览ios on 15-1-8.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobCell : UITableViewCell

@property(nonatomic,weak)IBOutlet   UILabel *tipsLb_;
@property(nonatomic,weak)IBOutlet   UILabel *contentLb_;
@property(nonatomic,weak)IBOutlet   UIView  *lineview_;
@end
