//
//  SystemNotification_Cell.h
//  jobClient
//
//  Created by YL1001 on 14/10/31.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SystemNotification_Cell : UITableViewCell

@property(nonatomic,weak) IBOutlet UIImageView  * userImg_;
@property(nonatomic,weak) IBOutlet UIImageView  * expertImg_;
@property(nonatomic,weak) IBOutlet UILabel      * contentLb_;
@property(nonatomic,weak) IBOutlet UILabel      * timeLb_;
@property(nonatomic,weak) IBOutlet UIView       * bgView_;

@property (weak, nonatomic) IBOutlet UILabel *detailLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conLabLeftToImg;

@end
