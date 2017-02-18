//
//  ResumeStatusCell.h
//  Association
//
//  Created by 一览iOS on 14-6-25.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResumeStatusCell : UITableViewCell

@property(nonatomic,weak)IBOutlet   UILabel     *statusLb_;
@property(nonatomic,weak)IBOutlet   UIButton    *statusMarkBtn_;
@property (weak, nonatomic) IBOutlet UILabel *linkLb;

@end
