//
//  ResumeComment_Cell.h
//  jobClient
//
//  Created by YL1001 on 15/1/27.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResumeComment_Cell : UITableViewCell

@property(nonatomic,weak) IBOutlet UILabel  * nameLb_;
@property(nonatomic,weak) IBOutlet UILabel  * timeLb_;
@property(nonatomic,weak) IBOutlet UILabel  * contentLb_;
@property(nonatomic,weak) IBOutlet UIView   * lineView_;

@end
