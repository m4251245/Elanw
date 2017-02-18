//
//  QuestionList_Cell.h
//  jobClient
//
//  Created by YL1001 on 14/10/30.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionList_Cell : UITableViewCell

@property(nonatomic,weak) IBOutlet UIView   * contentView_;
@property(nonatomic,weak) IBOutlet UILabel * questionLb_;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *questionLableRightWidth;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property(nonatomic,weak) IBOutlet UIView  * answerView_;
@property(nonatomic,weak) IBOutlet UILabel  * answerNameLb_;
@property(nonatomic,weak) IBOutlet UILabel  * atimeLb_;
@property (strong, nonatomic) IBOutlet UILabel *allAnswerCnt_;
@property (strong, nonatomic) IBOutlet UILabel *addAnswerLb_;
@property (strong, nonatomic) IBOutlet UILabel *noAnswerLb_;



//@property(nonatomic,weak) IBOutlet UILabel  * answerLb_;
//@property(nonatomic,weak) IBOutlet UIButton * moreBtn_;
//@property(nonatomic,weak) IBOutlet UIImageView * userImg_;
//@property(nonatomic,weak) IBOutlet UILabel * qtimeLb_;
//@property(nonatomic,weak) IBOutlet UIButton * userBtn_;


@end
