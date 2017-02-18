//
//  SalaryIrrigationComment_Cell.h
//  jobClient
//
//  Created by 一览ios on 14/11/27.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SalaryIrrigationComment_Cell : UITableViewCell
//头像
@property (weak, nonatomic) IBOutlet UIButton *picBtn_;
//楼主
@property (weak, nonatomic) IBOutlet UILabel *lZLb_;

//评论回复
@property (weak, nonatomic) IBOutlet UILabel *replyAnswerLb_;
//评论
@property (weak, nonatomic) IBOutlet UILabel *answerLb;
//楼层
@property (weak, nonatomic) IBOutlet UILabel *floorLb;
//赞按钮
@property (weak, nonatomic) IBOutlet UIButton *likeBtn_;

@property (weak,nonatomic)  IBOutlet UIImageView * lineView_;

@property (weak, nonatomic) IBOutlet UIView *lzView;


- (void)setSubviewAttr;

@end
