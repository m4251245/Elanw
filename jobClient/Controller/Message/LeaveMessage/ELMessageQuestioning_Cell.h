//
//  ELMessageQuestioning_Cell.h
//  jobClient
//
//  Created by 一览iOS on 15/9/6.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeaveMessage_DataModel.h"

@interface ELMessageQuestioning_Cell : UITableViewCell


@property (strong, nonatomic) UIImageView *titleImage;

@property (strong, nonatomic) UIButton *bgBtnView;
@property (strong, nonatomic) UILabel *dateLb;

@property(strong,nonatomic) UIView *backView;
@property(strong,nonatomic) UILabel *titleLb;
@property(strong,nonatomic) UILabel *phoneLb;
@property(strong,nonatomic) UILabel *lableOne;
@property(strong,nonatomic) UILabel *lableTwo;
@property(strong,nonatomic) UILabel *answerLb;
@property(strong,nonatomic) UILabel *questionLb;
@property(strong,nonatomic) UIImageView *lineImgOne;
@property(strong,nonatomic) UIImageView *lineImgTwo;
@property(strong,nonatomic) UILabel *tipsLb;




-(void)giveDataModal:(LeaveMessage_DataModel *)modal;

@end
