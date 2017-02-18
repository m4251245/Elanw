//
//  ExpertAnswerCtl_Cell.h
//  Association
//
//  Created by 一览iOS on 14-3-6.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpertAnswerCtl_Cell : UITableViewCell

@property(nonatomic,weak) IBOutlet UILabel * nameLb_;
@property(nonatomic,weak) IBOutlet UILabel * questionLb_;
@property(nonatomic,weak) IBOutlet UILabel * answerLb_;
@property(nonatomic,weak) IBOutlet UIImageView * imgView_;
@property(nonatomic,weak) IBOutlet UIView  * bigView_;

@end
