//
//  WorkApplyRecordCell.m
//  Association
//
//  Created by 一览iOS on 14-6-23.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "WorkApplyRecordCell.h"
#import "MyConfig.h"
#import "ResumeStatusStepCtl.h"

#import "NewApplyRecordDataModel.h"
@implementation WorkApplyRecordCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    ZWlabel_.font = [UIFont fontWithName:@"Helvetica " size:15];
}

/*
- (void)initCellWith:(WorkApplyDataModel *)workApplyModel indexPath:(NSIndexPath *)indexPath
{
    [titleLb_ setFont:FIFTEENFONT_TITLE];
    [companyNameLb_ setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:13]];
    [applayTime_ setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:10]];
    [_statusBtn.titleLabel setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:13]];
    [titleLb_ setTextColor:BLACKCOLOR];
    [companyNameLb_ setTextColor:GRAYCOLOR];
    [applayTime_ setTextColor:GRAYCOLOR];
    [_statusBtn setTitleColor:GRAYCOLOR forState:UIControlStateNormal];
//    [salaryLb_ setFont:FIFTEENFONT_TITLE];
    
    [titleLb_ setText:workApplyModel.jobName_];
    [companyNameLb_ setText:workApplyModel.companyName_];
//    [salaryLb_ setText:workApplyModel.salary];
    //    [_statusBtn setTag:indexPath.row +1000];
    
    CGSize salaryRect = [workApplyModel.salary sizeWithFont:FIFTEENFONT_TITLE constrainedToSize:CGSizeMake(300, 21)];
    salaryRect.width +=2;
    CGSize jobRect = [workApplyModel.jobName_ sizeWithFont:FIFTEENFONT_TITLE constrainedToSize:CGSizeMake(300, 21)];
    jobRect.width +=2;
    if (292-jobRect.width < salaryRect.width) {
        jobRect.width = 292-salaryRect.width;
    }
    
    [titleLb_ setFrame:CGRectMake(20, 4, jobRect.width, 21)];
//    [salaryLb_ setFrame:CGRectMake(titleLb_.frame.origin.x + titleLb_.frame.size.width, 4, salaryRect.width, 21)];
    
    int status = [workApplyModel.resumeStatus intValue];
    switch (status) {
        case 1:
        {
            [_statusBtn setTitle:@"被查看" forState:UIControlStateNormal];
            [applayTime_ setText:workApplyModel.readTime_];
        }
            break;
        case 2:
        {
            [_statusBtn setTitle:@"HR感兴趣" forState:UIControlStateNormal];
            [applayTime_ setText:workApplyModel.collectTime_];
        }
            break;
        case 3:
        {
            [_statusBtn setTitle:@"通知面试" forState:UIControlStateNormal];
            [applayTime_ setText:workApplyModel.mailTime_];
        }
            break;
        case 4:
        {
            [_statusBtn setTitle:@"不匹配" forState:UIControlStateNormal];
            [applayTime_ setText:workApplyModel.unqualTime_];
        }
            break;
        default:
        {
            [_statusBtn setTitle:@"投递成功" forState:UIControlStateNormal];
            [applayTime_ setText:workApplyModel.sendTime_];
        }
            break;
    }
    
    //    if (workApplyModel.isSelected) {
    //        ResumeStatusStepCtl *stepViewCtl = [[ResumeStatusStepCtl alloc]init];
    //        UIView *stepView = [stepViewCtl returnStepView:workApplyModel];
    //
    //        CGRect stepRect = stepView.frame;
    //        stepRect.origin.y = 70;
    //        stepRect.origin.x = 20;
    //        [stepView setFrame:stepRect];
    //        [self addSubview:stepView];
    //        [self setFrame:CGRectMake(0, 0, 320, stepRect.origin.y+stepRect.size.height)];
    //
    //        CGRect lineViewRect = lineView_.frame;
    //        lineViewRect.origin.y = self.frame.size.height-1;
    //        [lineView_ setFrame:lineViewRect];
    //        [self bringSubviewToFront:lineView_];
    //    }else{
    //        [self setFrame:CGRectMake(0, 0, 320, 70)];
    //        [lineView_ setFrame:CGRectMake(0, 69, 320, 1)];
    //    }
    
}
*/

- (void)initCellWith:(NewApplyRecordDataModel *)workApplyModel
{
    [ZWlabel_ setTextColor:UIColorFromRGB(0x333333)];
    [companyNameLb_ setTextColor:UIColorFromRGB(0x888888)];
    [applyTime_ setTextColor:UIColorFromRGB(0x999999)];
    
    [ZWlabel_ setText:workApplyModel.jtzw];
    [companyNameLb_ setText:workApplyModel.cname];
    
    NSInteger status = [workApplyModel.pstatus intValue];
    if (workApplyModel.lastviewtime == nil) {
        [applyTime_ setText:workApplyModel.sendtime];
    }
    else
    {
        [applyTime_ setText:workApplyModel.lastviewtime];
    }
    
    switch (status)
    {
        case 1:
        {
//            [statusLb_ setText:@"HR查看过"];
            _statusImg.image = [UIImage imageNamed:@"apply_02"];

        }
            break;
        case 2:
        {
//            [statusLb_ setText:@"HR收藏"];
            _statusImg.image = [UIImage imageNamed:@"apply_05"];

        }
            break;
        case 3:
        {
//            [statusLb_ setText:@"面试通知"];
            _statusImg.image = [UIImage imageNamed:@"apply_03"];

        }
            break;
        default:
        {
//            [statusLb_ setText:@"投递成功"];
            _statusImg.image = [UIImage imageNamed:@"apply_01"];
//            [applyTime_ setText:workApplyModel.sendTime_];
        }
            break;
    }
    
    if (workApplyModel.title)
    {
//        _backVIewImage.frame = CGRectMake(8,5,304,135);
        _messageVIew.hidden = NO;
        [_gwImage sd_setImageWithURL:[NSURL URLWithString:workApplyModel.bsp_pic] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
        _gwImage.clipsToBounds = YES;
        _gwImage.layer.cornerRadius = 20.0f;
    }
    else
    {
//        _backVIewImage.frame = CGRectMake(8,5,304,77);
        _messageVIew.hidden = YES;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
