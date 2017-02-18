//
//  PushCustomCell.h
//  Association
//
//  Created by 一览iOS on 14-5-10.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface PushCustomCell : UITableViewCell


@property(nonatomic,retain) IBOutlet UILabel *pushName_;
@property(strong,retain) IBOutlet UISwitch *pushCellSwitch_;
@property(nonatomic,weak) IBOutlet UIView   *lineView_;
@end
