//
//  MyPubilshCtl_Cell.h
//  Association
//
//  Created by 一览iOS on 14-1-15.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPubilshCtl_Cell : UITableViewCell


@property(nonatomic,weak) IBOutlet UILabel * titleLb_;
@property(nonatomic,weak) IBOutlet UILabel * descLb_;
@property(nonatomic,weak) IBOutlet UILabel * datetimeLb_;
@property(nonatomic,weak) IBOutlet UILabel * viewCntLb_;
@property(nonatomic,weak) IBOutlet UILabel * commengCntLb_;
@property(nonatomic,weak) IBOutlet UILabel * likeCntLb_;
@property(nonatomic,weak) IBOutlet UIView * contentView_;
@property(nonatomic,weak) IBOutlet UIImageView * articleImage_;
@property (weak, nonatomic) IBOutlet UIImageView *isNewImagev;

@end
