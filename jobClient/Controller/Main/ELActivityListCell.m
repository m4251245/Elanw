//
//  ELActivityListCell.m
//  jobClient
//
//  Created by 一览iOS on 15/9/16.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELActivityListCell.h"
#import "ELActivityModel.h"
#import "ELImgClipHelper.h"

@implementation ELActivityListCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    _backView.clipsToBounds = YES;
    _backView.layer.cornerRadius = 4.0;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.personImage = (UIImageView *)[[[ELImgClipHelper alloc]init] imgView:self.personImage withClipSize:CGSizeMake(5, 5)];
}

-(void)setMsgActivityModal:(MsgDetail_DataModal *)msgActivityModal
{
    MsgDetail_DataModal *modal = msgActivityModal;
    self.activityName.text = modal.title_;
    self.activityTime.text = modal.start_time;
    self.activityPlace.text = modal.address;
    
    [self.personImage sd_setImageWithURL:[NSURL URLWithString:modal.person_pic] placeholderImage:[UIImage imageNamed:@""]];
    self.personNameLbale.text = modal.person_name;
    self.activityLable.hidden = YES;
    if (_listType == 1){
        self.leftTimeLb.text = [NSString stringWithFormat:@"我在%@发布",[modal.idatetime substringWithRange:NSMakeRange(0,10)]];
    }else{
        self.leftTimeLb.text = [NSString stringWithFormat:@"我在%@报名",[modal.idatetime substringWithRange:NSMakeRange(0,10)]];
    }
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"已有 %ld 人报名",(long)modal.joinPeopleCount]];
    [attString addAttribute:NSForegroundColorAttributeName value:PINGLUNHONG range:NSMakeRange(2,attString.length-5)];
    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(2,attString.length-5)];
    [self.peopleCountLb setAttributedText:attString] ;
    
    self.activityStatusImage.hidden = YES;
    NSDate *lastDate = [MyCommon getDate:modal.last_time];
    NSDate *startDate = [MyCommon getDate:modal.start_time];
    NSDate *endDate = [MyCommon getDate:modal.end_time];
    NSDate *nowDate = [NSDate date];
    if ([[lastDate earlierDate:nowDate] isEqualToDate:nowDate]) {        
        self.activityStatusImage.image = [UIImage imageNamed:@"activity_baomingzhong_image"];
        self.activityStatusImage.hidden = NO;
    }else if ([[startDate earlierDate:nowDate] isEqualToDate:startDate] && [[endDate earlierDate:nowDate] isEqualToDate:nowDate]){
        self.activityStatusImage.image = [UIImage imageNamed:@"activity_jinxingzhong_image"];
        self.activityStatusImage.hidden = NO;
    }else if ([[endDate earlierDate:nowDate] isEqualToDate:endDate]){
        self.activityStatusImage.image = [UIImage imageNamed:@"activity_yijieshu_image"];
        self.activityStatusImage.hidden = NO;
    }
}

-(void)setArticleActivityModal:(Article_DataModal *)articleActivityModal
{
    Article_DataModal *modal = articleActivityModal;
    self.leftTimeLb.text = [NSString stringWithFormat:@"%@报名截止",[modal.lastJoinTime substringToIndex:16]];
    
    [self.personImage sd_setImageWithURL:[NSURL URLWithString:modal.expert_.img_] placeholderImage:[UIImage imageNamed:@""]];
    self.personNameLbale.text = modal.expert_.iname_;
    self.activityName.text = modal.activityTitle;
    self.activityTime.text = [modal.startTime substringToIndex:16];
    self.activityPlace.text = modal.activityAddress;
    self.activityLable.hidden = NO;
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"已有 %ld 人报名",(long)modal.joinPeopleCount]];
    [attString addAttribute:NSForegroundColorAttributeName value:PINGLUNHONG range:NSMakeRange(2,attString.length-5)];
    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(2,attString.length-5)];
    [self.peopleCountLb setAttributedText:attString];
    self.activityStatusImage.hidden = YES;
    NSDate *lastDate = [MyCommon getDate:modal.lastJoinTime];
    NSDate *startDate = [MyCommon getDate:modal.startTime];
    NSDate *endDate = [MyCommon getDate:modal.endTime];
    NSDate *nowDate = [NSDate date];
    if ([[lastDate earlierDate:nowDate] isEqualToDate:nowDate]) {        
        self.activityStatusImage.image = [UIImage imageNamed:@"activity_baomingzhong_image"];
        self.activityStatusImage.hidden = NO;
    }else if ([[startDate earlierDate:nowDate] isEqualToDate:startDate] && [[endDate earlierDate:nowDate] isEqualToDate:nowDate]){
        self.activityStatusImage.image = [UIImage imageNamed:@"activity_jinxingzhong_image"];
        self.activityStatusImage.hidden = NO;
    }else if ([[endDate earlierDate:nowDate] isEqualToDate:endDate]){
        self.activityStatusImage.image = [UIImage imageNamed:@"activity_yijieshu_image"];
        self.activityStatusImage.hidden = NO;
    }
}

-(void)setDataModel:(ELActivityModel *)dataModel{
    
    
    _dataModel = dataModel;
    self.activityName.text = dataModel.title;
    self.activityTime.text = dataModel.start_time;
    self.activityPlace.text = dataModel.address;
    
    [self.personImage sd_setImageWithURL:[NSURL URLWithString:dataModel.person_pic] placeholderImage:[UIImage imageNamed:@""]];
    self.personNameLbale.text = dataModel.person_iname;
    self.activityLable.hidden = YES;
    if (_listType == 1){
        self.leftTimeLb.text = [NSString stringWithFormat:@"我在%@发布",[dataModel.idatetime substringWithRange:NSMakeRange(0,10)]];
    }else{
        self.leftTimeLb.text = [NSString stringWithFormat:@"我在%@报名",[dataModel.idatetime substringWithRange:NSMakeRange(0,10)]];
    }
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"已有 %@ 人报名",dataModel.cnt]];
    [attString addAttribute:NSForegroundColorAttributeName value:PINGLUNHONG range:NSMakeRange(2,attString.length-5)];
    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(2,attString.length-5)];
    [self.peopleCountLb setAttributedText:attString] ;
    
    self.activityStatusImage.hidden = YES;
    NSDate *lastDate = [MyCommon getDate:dataModel.last_join_time];
    NSDate *startDate = [MyCommon getDate:dataModel.start_time];
    NSDate *endDate = [MyCommon getDate:dataModel.end_time];
    NSDate *nowDate = [NSDate date];
    if ([[lastDate earlierDate:nowDate] isEqualToDate:nowDate]) {        
        self.activityStatusImage.image = [UIImage imageNamed:@"activity_baomingzhong_image"];
        self.activityStatusImage.hidden = NO;
    }else if ([[startDate earlierDate:nowDate] isEqualToDate:startDate] && [[endDate earlierDate:nowDate] isEqualToDate:nowDate]){
        self.activityStatusImage.image = [UIImage imageNamed:@"activity_jinxingzhong_image"];
        self.activityStatusImage.hidden = NO;
    }else if ([[endDate earlierDate:nowDate] isEqualToDate:endDate]){
        self.activityStatusImage.image = [UIImage imageNamed:@"activity_yijieshu_image"];
        self.activityStatusImage.hidden = NO;
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
