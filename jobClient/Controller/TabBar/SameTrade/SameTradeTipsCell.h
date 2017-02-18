//
//  SameTradeTipsCell.h
//  jobClient
//
//  Created by 一览iOS on 14-10-24.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SameTradeTipsCell : UITableViewCell

@property(nonatomic,weak) IBOutlet  UIView          *backgroundView_;
@property(nonatomic,weak) IBOutlet  UIImageView     *markImgv_;
@property(nonatomic,weak) IBOutlet  UILabel         *titleLb_;
@property(nonatomic,weak) IBOutlet  UIImageView     *voiceImgv_;
@property(nonatomic,weak) IBOutlet  UILabel         *contentLb_;
@property(nonatomic,weak) IBOutlet  UILabel         *tipsCountLb_;
@property(nonatomic,weak) IBOutlet  UIView          *friendView_;

@property(nonatomic,strong) id dataModel;

@end
