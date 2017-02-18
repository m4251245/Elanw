//
//  InviteListCtl_Cell.h
//  Association
//
//  Created by YL1001 on 14-5-15.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteListCtl_Cell : UITableViewCell


@property(nonatomic,weak) IBOutlet UIImageView * imgView_;
@property(nonatomic,weak) IBOutlet UILabel     * nameLb_;
@property(nonatomic,weak) IBOutlet UILabel     * contentLb_;
@property(nonatomic,weak) IBOutlet UIButton    * rejectBtn_;
@property(nonatomic,weak) IBOutlet UIButton    * acceptBtn_;
@property(nonatomic,weak) IBOutlet UILabel     * statusLb_;
@property(nonatomic,weak) IBOutlet UILabel     * timeLb_;
@end
