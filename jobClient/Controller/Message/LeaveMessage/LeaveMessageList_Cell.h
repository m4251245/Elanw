//
//  LeaveMessageList_Cell.h
//  jobClient
//
//  Created by 一览ios on 14/12/8.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ELNewNewsListVO;

@interface LeaveMessageList_Cell : UITableViewCell
//头像

@property (weak, nonatomic) IBOutlet UIImageView *picImg;
//专家图片

@property (weak, nonatomic) IBOutlet UIImageView *isExpertImg;

@property (weak, nonatomic) IBOutlet UIImageView *isNewImg;

//用户名
@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UILabel *dateTime;

//数字角标
@property (weak, nonatomic) IBOutlet UIButton *numRedIcon;

//性别
@property (weak, nonatomic) IBOutlet UIButton *sexAndAgeBtn;

//消息摘要
@property (weak, nonatomic) IBOutlet UILabel *msgLb;

@property (weak, nonatomic) IBOutlet UILabel *hrMarkImagev;

@property (weak, nonatomic) IBOutlet UIButton *hideUserBtn;

@property (weak, nonatomic) IBOutlet UIButton *delBtn;

@property (assign, nonatomic) BOOL inEditing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userNameLeftToImg;

- (void)setAttr;

- (void)setMessageContact:(ELNewNewsListVO *)contact;

@end
