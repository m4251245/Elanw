//
//  MessageCtl_Cell.h
//  Association
//
//  Created by 一览iOS on 14-4-14.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCtl_Cell : UITableViewCell

@property(nonatomic,weak) IBOutlet UIImageView * imgView_;
@property(nonatomic,weak) IBOutlet UILabel     * nameLb_;
@property(nonatomic,weak) IBOutlet UILabel     * contentLb_;
@property(nonatomic,weak) IBOutlet UIImageView * markNewImg_;
@property(nonatomic,weak) IBOutlet UILabel     * timeLb_;



@end
