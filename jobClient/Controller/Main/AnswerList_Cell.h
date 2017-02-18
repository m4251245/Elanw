//
//  AnswerList_Cell.h
//  jobClient
//
//  Created by YL1001 on 14/10/30.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerList_Cell : UITableViewCell

//@property(nonatomic,weak) IBOutlet UIImageView * userImg_;
//@property(nonatomic,weak) IBOutlet UILabel     * nameLb_;
//@property(nonatomic,weak) IBOutlet UIButton    * userBtn_;
//@property(nonatomic,weak) IBOutlet UILabel     * answerLb_;
//@property(nonatomic,weak) IBOutlet UIButton    * answerBtn_;

@property(nonatomic,weak) IBOutlet UIView      * contentView_;
@property(nonatomic,weak) IBOutlet UILabel     * questionLb_;

@property(nonatomic,weak) IBOutlet UIView      * answerView_;
@property (strong, nonatomic) IBOutlet UILabel *myAnswerLb_;
@property (strong, nonatomic) IBOutlet UILabel *answerLb_;
@property (strong, nonatomic) IBOutlet UILabel *answerCnt_;
@property(nonatomic,weak) IBOutlet UILabel     * timeLb_;
@property (strong, nonatomic) IBOutlet UILabel *noAnswerLb_;

@end
