//
//  SalaryIrrigationComment_Cell.m
//  jobClient
//
//  Created by 一览ios on 14/11/27.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "SalaryIrrigationComment_Cell.h"
#import "MyConfig.h"

@implementation SalaryIrrigationComment_Cell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSubviewAttr
{
    [self.likeBtn_ setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [self.likeBtn_ setImage:[UIImage imageNamed:@"ico_zan_down2.png"] forState:UIControlStateSelected];
    
    self.answerLb.font = TWEELVEFONT_COMMENT;
//    self.replyAnswerLb_.frame = CGRectMake(53, 37, ScreenWidth-70, <#CGFloat height#>);
    self.replyAnswerLb_.font = TWEELVEFONT_COMMENT;
    //设置头像圆角
    CALayer *layer = self.picBtn_.layer;
    [layer setMasksToBounds:YES];
    //[layer setBorderWidth:1.0];
    [layer setCornerRadius:4.0];
    
}

@end
