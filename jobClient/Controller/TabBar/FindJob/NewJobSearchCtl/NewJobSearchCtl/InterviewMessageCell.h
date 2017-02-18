//
//  InterviewMessageCell.h
//  Association
//
//  Created by 一览iOS on 14-6-24.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InterviewMessageCell : UITableViewCell

@property(nonatomic,weak)IBOutlet   UILabel     *companyNameLb_;
@property(nonatomic,weak)IBOutlet   UILabel     *interviewTimeLb_;
@property(nonatomic,weak)IBOutlet   UILabel     *isReadLb_;
@property (weak, nonatomic) IBOutlet UIImageView *isReadImg;

@end
