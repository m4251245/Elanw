//
//  FreshCtl_Cell.h
//  Association
//
//  Created by 一览iOS on 14-3-13.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewCareerTalkDataModal;

@interface FreshCtl_Cell : UITableViewCell

@property(nonatomic,weak) IBOutlet UILabel * dateLb_;
@property(nonatomic,weak) IBOutlet UILabel * weekdayLb_;
@property(nonatomic,weak) IBOutlet UILabel * titleLb_;
@property(nonatomic,weak) IBOutlet UILabel * timeLb_;
@property(nonatomic,weak) IBOutlet UILabel * schoolLb_;
@property(nonatomic,weak) IBOutlet UILabel * colorLb_;
@property(nonatomic,weak) IBOutlet UIView  * dateView_;
@property (weak, nonatomic) IBOutlet UIImageView *bgColor;


- (void)initCell;

- (void)setDataModel:(NewCareerTalkDataModal *)model;

@end
