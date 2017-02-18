//
//  MessageDelTipsCtl.h
//  jobClient
//
//  Created by 一览ios on 15/7/1.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MsgTipsType) {
    MsgTipsTypeHideUser = 1//屏蔽用户
};

typedef void(^DelMessageBlock)(NSInteger row);

@interface MessageDelTipsCtl : UIViewController

@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (assign, nonatomic) NSInteger row;
@property(nonatomic, copy)DelMessageBlock delMessageBlock;
@property (assign, nonatomic) MsgTipsType msgTipsType;

- (IBAction)delMsgBtnClick:(id)sender;
- (IBAction)cancelDelBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *tipsBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;


@end
