//
//  MessageDailog_ShareLeftCell.m
//  jobClient
//
//  Created by 一览ios on 15/5/12.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "MessageDailog_ShareRightCell.h"

#import "User_DataModal.h"
#import "JobSearch_DataModal.h"
#import "LeaveMessage_DataModel.h"
#import "Groups_DataModal.h"
#import "ShareMessageModal.h"
#import "UIButton+WebCache.h"

@implementation MessageDailog_ShareRightCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImage *bgImage = [UIImage imageNamed:@"icon_message_right.png"];
    [_bgBtn setBackgroundImage:[bgImage stretchableImageWithLeftCapWidth:bgImage.size.width*0.4 topCapHeight:bgImage.size.height*0.8] forState:UIControlStateNormal];
    [self sendSubviewToBack:_bgBtn];
    CALayer *layer = _userBtn.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 4.0;
    layer = _personBtn.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 4.0;
    layer = _timeLb.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 4.f;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

- (void)setMessageModel:(LeaveMessage_DataModel *)messageModel
{
    _articleCnt.text = @"";
    if (!messageModel.date) {
        _timeLb.hidden = YES;
    }else{
        _timeLb.hidden = NO;
    }
    if (messageModel.messageType == MessageTypeShareJob) {
        [self setJobModel:messageModel];
        return;
    }
    else if (messageModel.messageType == MessageTypeGroup)
    {
        _titleLb.text = @"社群";
       
        _timeLb.text = messageModel.date;
        Groups_DataModal *modal = messageModel.otherModel;
        _personNameLb.text = [self deleteColorString:modal.name_];
        _salaryLb.hidden = YES;
        _personJobLb.text = [NSString stringWithFormat:@"成员:%ld",(long)modal.personCnt_];
        _articleCnt.text = [NSString stringWithFormat:@"话题:%ld",(long)modal.articleCnt_];
        [_personBtn sd_setImageWithURL:[NSURL URLWithString:modal.pic_] forState:UIControlStateNormal placeholderImage:nil];
        [_userBtn sd_setImageWithURL:[NSURL URLWithString:messageModel.personPic] forState:UIControlStateNormal placeholderImage:nil];
        [self setFrameWithDataModel:messageModel];
        return;
    }
    else if(messageModel.messageType == MessageTypeShareReusme)
    {
        ShareMessageModal *sharedUser = messageModel.otherModel;
        _timeLb.text = messageModel.date;
        _personNameLb.text = sharedUser.personName;
        
        NSString *str1 = @"";
        NSString *str2 = @"";
        if (sharedUser.person_edu.length > 0) {
            str1 = [NSString stringWithFormat:@"%@|",sharedUser.person_edu];
        }
        if (sharedUser.person_gznum.length > 0) {
            if (sharedUser.person_zw.length > 0) {
                str2 = [NSString stringWithFormat:@"%@年|",sharedUser.person_gznum];
            }
            else
            {
                str2 = [NSString stringWithFormat:@"%@年",sharedUser.person_gznum];
            }
        }
        _personJobLb.text = [NSString stringWithFormat:@"%@%@%@",str1,str2,sharedUser.person_zw];
        _salaryLb.hidden = YES;
        _titleLb.text = @"简历";
        [_personBtn sd_setImageWithURL:[NSURL URLWithString:sharedUser.person_pic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bg__xinwen"]];
        [_userBtn sd_setImageWithURL:[NSURL URLWithString:messageModel.personPic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bg__xinwen"]];
        [self setFrameWithDataModel:messageModel];
        return;
    }
    User_DataModal *sharedUser = messageModel.otherModel;
    _personNameLb.text = [self deleteColorString:sharedUser.uname_];
    _timeLb.text = messageModel.date;
    _personJobLb.text = [self deleteColorString:sharedUser.zym_];
    _salaryLb.hidden = YES;
    _titleLb.text = @"名片";
    [_personBtn sd_setImageWithURL:[NSURL URLWithString:sharedUser.img_] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bg__xinwen"]];
    [_userBtn sd_setImageWithURL:[NSURL URLWithString:messageModel.personPic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bg__xinwen"]];
    [self setFrameWithDataModel:messageModel];
}

#pragma mark 职位分享
- (void)setJobModel:(LeaveMessage_DataModel *)messageModel
{
    JobSearch_DataModal *jobModel = messageModel.otherModel;
    _timeLb.text = messageModel.date;
    _personNameLb.text = [self deleteColorString:jobModel.companyName_];
    _personJobLb.text = [self deleteColorString:jobModel.zwName_];
    _salaryLb.hidden = NO;
    _titleLb.text = @"职位";
    jobModel.salary_ = [jobModel.salary_ stringByReplacingOccurrencesOfString:@"--" withString:@"-"];
    jobModel.salary_ = [jobModel.salary_ stringByReplacingOccurrencesOfString:@" 年薪" withString:@""];
    jobModel.salary_ = [jobModel.salary_ stringByReplacingOccurrencesOfString:@" 月薪" withString:@""];
    if ([jobModel.salary_ isEqualToString:@"面议"]) {
        [_salaryLb setText:jobModel.salary_];
    }else{
        [_salaryLb setText:[NSString stringWithFormat:@"￥%@",jobModel.salary_]];
    }
    
    [_personBtn sd_setImageWithURL:[NSURL URLWithString:jobModel.companyLogo_] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"positionDefaulLogo.png"]];
    [_userBtn sd_setImageWithURL:[NSURL URLWithString:messageModel.personPic] forState:UIControlStateNormal placeholderImage:nil];
    
    [self setFrameWithDataModel:messageModel];
}

- (void)setFrameWithDataModel:(LeaveMessage_DataModel *)messageModel
{
//    MessageDailogType type = messageModel.messageType;
//    if (type == MessageTypeShareUser || type == MessageTypeShareReusme) {//用户分享
//        _personNameLb.frame = CGRectMake(115, 68, 148, 21);
//        _personJobLb.frame = CGRectMake(115, 88, 148, 29);
//    }else if (type == MessageTypeShareJob){
//        _personNameLb.frame = CGRectMake(115, 66, 148, 21);
//        _salaryLb.frame = CGRectMake(115, 87, 148, 15);
//        _personJobLb.frame = CGRectMake(115, 101, 148, 21);
//    }
//    else if(type == MessageTypeGroup)
//    {
//        _personNameLb.frame = CGRectMake(115, 68, 148, 21);
//        _personJobLb.frame = CGRectMake(115, 88,74, 29);
//        _articleCnt.frame = CGRectMake(189,88,74,29);
//    }    
    MessageDailogType type = messageModel.messageType;
    if (type == MessageTypeShareUser || type == MessageTypeShareReusme) {//用户分享
        _personNameLb.frame = CGRectMake(115, 68, ScreenWidth-172, 21);
        _personJobLb.frame = CGRectMake(115, 87, ScreenWidth-172, 29);
    }
    else if (type == MessageTypeShareJob){
        _personNameLb.frame = CGRectMake(115, 66, ScreenWidth-172, 21);
        _salaryLb.frame = CGRectMake(115, 87, ScreenWidth-172, 15);
        _personJobLb.frame = CGRectMake(115, 101, ScreenWidth-172, 21);
    }
    else if(type == MessageTypeGroup)
    {
        CGFloat width = (ScreenWidth-172)/2.0;
        _personNameLb.frame = CGRectMake(115, 68, ScreenWidth-172, 21);
        _personJobLb.frame = CGRectMake(115, 87, width, 29);
        _articleCnt.frame = CGRectMake(115+width,87,width,29);
    }
}

-(NSString *)deleteColorString:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"<font color=red>" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"</font>" withString:@""];
    return string;
}

@end
