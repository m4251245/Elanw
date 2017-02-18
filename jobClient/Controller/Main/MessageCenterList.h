//
//  MessageCenterList.h
//  jobClient
//
//  Created by 一览ios on 15/4/23.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"

typedef void (^block)();

@interface MessageCenterList : BaseListCtl



@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;


@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UILabel *leftCountLb;
@property (weak, nonatomic) IBOutlet UILabel *rightCountLb;
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (strong, nonatomic) IBOutlet UIButton *rightBarBtn;

@property (weak, nonatomic) IBOutlet UIButton *personCenterBtn;
@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UILabel *redDotLb;
@property (strong, nonatomic) IBOutlet UIView *peopleView;

@property (nonatomic,assign) BOOL isThisCtl;

@property(nonatomic, copy) block  _redCountBlock;

- (void)changToRightModel;

-(void)setNewMessage;

-(void)refreshAddressBookRedDot;

-(void)refreshViewTwoCtl;

@property(nonatomic,assign) BOOL        isRight;   //控制消息跳转时候的model

@end
