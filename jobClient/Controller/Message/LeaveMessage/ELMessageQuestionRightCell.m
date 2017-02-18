//
//  ELMessageQuestionRightCell.m
//  jobClient
//
//  Created by YL1001 on 15/9/22.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELMessageQuestionRightCell.h"

@implementation ELMessageQuestionRightCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    UIImage *bgImage = [UIImage imageNamed:@"icon_dailog1.png"];
    [_backBtn setBackgroundImage:[bgImage stretchableImageWithLeftCapWidth:bgImage.size.width*0.6 topCapHeight:bgImage.size.height*0.8] forState:UIControlStateNormal];
    [self sendSubviewToBack:_backBtn];
    
    _quizzerView.layer.borderWidth = 1;
    _quizzerView.layer.borderColor = UIColorFromRGB(0xE6E6E6).CGColor;
    
    _answerView.layer.borderWidth = 1;
    _answerView.layer.borderColor = UIColorFromRGB(0xE6E6E6).CGColor;
    
    _userBtn.layer.cornerRadius = 4.0f;
    _userBtn.layer.masksToBounds = YES;
    
    CALayer *layer = _TimeLb.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 4.f;
    
}

- (void)giveDataModal:(LeaveMessage_DataModel *)modal
{

    _titleLb.text = [NSString stringWithFormat:@"我向%@发起的约谈",modal.aspDiscuss.dis_personName];
    
    [_userBtn sd_setImageWithURL:[NSURL URLWithString:modal.personPic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bg__xinwen"]];
    _questionTitleLb.text = modal.aspDiscuss.course_title;
    
    if (!modal.aspDiscuss.course_price) {
        modal.aspDiscuss.course_price = @"0";
    }
    _costLb.text = [NSString stringWithFormat:@"%@ 元/次",modal.aspDiscuss.course_price];
    
    [_quizzerImg sd_setImageWithURL:[NSURL URLWithString:modal.aspDiscuss.user_pic] placeholderImage:[UIImage imageNamed:@"bg__xinwen"]];
    _quizzerName.text = modal.aspDiscuss.user_name;
    _quizzerJob.text = modal.aspDiscuss.user_zw;
    
    [_answerImg sd_setImageWithURL:[NSURL URLWithString:modal.aspDiscuss.dis_pic] placeholderImage:[UIImage imageNamed:@"bg__xinwen"]];
    _answerName.text = modal.aspDiscuss.dis_personName;
    _answerJob.text = modal.aspDiscuss.dis_zw;
    
    if (!modal.date) {
        _TimeLb.hidden = YES;
    }else{
        _TimeLb.hidden = NO;
        _TimeLb.text = modal.date;
    }
    

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
