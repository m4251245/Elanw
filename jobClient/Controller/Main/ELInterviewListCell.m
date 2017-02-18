//
//  ELInterviewListCell.m
//  jobClient
//
//  Created by YL1001 on 15/11/26.
//  Copyright © 2015年 YL1001. All rights reserved.
//

#import "ELInterviewListCell.h"


@implementation ELInterviewListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _timeBgView.layer.cornerRadius = 4.0f;
    _timeBgView.layer.masksToBounds = YES;
    
    _contentBgView.layer.cornerRadius = 4.0f;
    _contentBgView.layer.masksToBounds = YES;
    
    _personImg.layer.cornerRadius = 20.0f;
    _personImg.layer.masksToBounds = YES;
}

-(void)giveDataModel:(ELAspectantDiscuss_Modal *)dataModal
{
    
    NSString *dateTime = [MyCommon getShortTime:dataModal.dataTime];
    self.TimeLb.text = dateTime;
    
    _infoLb.text = dataModal.yuetan_status_desc;
    
    _personImg.hidden = NO;
    if ([dataModal.YTZ_id isEqualToString:[Manager getUserInfo].userId_]) {//约谈发起者
        
        [_personImg sd_setImageWithURL:[NSURL URLWithString:dataModal.dis_pic] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
        _titleLb.text = [NSString stringWithFormat:@"%@发起的约谈",dataModal.dis_personName];
        _personImgleading.constant = 40;
    }
    else
    {
        [_personImg sd_setImageWithURL:[NSURL URLWithString:dataModal.user_pic] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
        _titleLb.text = [NSString stringWithFormat:@"%@向我发起的约谈",dataModal.user_name];
        
        _personImgleading.constant = 8;
    }
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
