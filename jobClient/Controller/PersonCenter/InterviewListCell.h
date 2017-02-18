//
//  InterviewListCell.h
//  jobClient
//
//  Created by 一览iOS on 14-11-5.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InterviewListCell : UITableViewCell

@property(nonatomic,weak) IBOutlet    UILabel         *questionLb_;
@property(nonatomic,weak) IBOutlet    UILabel         *answerLb_;
@property(nonatomic,weak) IBOutlet    UIImageView     *rightImgv_;
@property(nonatomic,weak) IBOutlet    UIView          *bgView_;
@property(nonatomic,weak) IBOutlet    UIButton        *answerBtn_;

@end
