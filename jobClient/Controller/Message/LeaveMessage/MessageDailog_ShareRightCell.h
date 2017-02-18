//
//  MessageDailog_ShareLeftCell.h
//  jobClient
//
//  Created by 一览ios on 15/5/12.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//  留言 显示分享对方的信息

#import <UIKit/UIKit.h>
@class LeaveMessage_DataModel;

@interface MessageDailog_ShareRightCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UIButton *userBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UIButton *personBtn;
@property (weak, nonatomic) IBOutlet UILabel *personNameLb;
@property (weak, nonatomic) IBOutlet UILabel *personJobLb;
@property (weak, nonatomic) IBOutlet UIButton *bgBtn;
@property (weak, nonatomic) IBOutlet UILabel *salaryLb;
@property (weak, nonatomic) IBOutlet UILabel *articleCnt;

@property (strong, nonatomic) LeaveMessage_DataModel *messageModel;

@end
