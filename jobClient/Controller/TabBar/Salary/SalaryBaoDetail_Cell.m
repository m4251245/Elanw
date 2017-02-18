//
//  SalaryBaoDetail_Cell.m
//  jobClient
//
//  Created by 一览ios on 15/4/27.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//薪指入口 曝工资

#import "SalaryBaoDetail_Cell.h"
#import "ELUserModel.h"

@implementation SalaryBaoDetail_Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 3.0f);
    _progressView.transform = transform;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSalaryResultModel:(ELSalaryResultModel *)salaryResultModel
{
    _progressView.frame = CGRectMake(_progressView.frame.origin.x, _progressView.frame.origin.y, ScreenWidth - 36, _progressView.frame.size.height);
    
    _jobWidth.constant = self.frame.size.width / 2;
    _schoolLabWidth.constant = self.frame.size.width / 2;
    
    _titleLb.text = [MyCommon translateHTML:salaryResultModel.des_];
    _beatLb.text = [NSString stringWithFormat:@"%@%%", salaryResultModel.percent];
    _progressView.progress = [salaryResultModel.percent floatValue]/100;
    ELUserModel *userModel = salaryResultModel.userInfo;
    _jobLb.text = [MyCommon translateHTML:userModel.job];
    _salaryLb.text = [MyCommon translateHTML:userModel.yuex];
    _schoolLb.text = [MyCommon translateHTML:userModel.school];
    if (!userModel.edu) {
       userModel.edu = @"";
    }
     _educationLevelLb.text = [MyCommon translateHTML:userModel.edu];
    _workAgeLb.text = [MyCommon translateHTML:[NSString stringWithFormat:@"%@年工作经验", userModel.gznum]];
    
    CGFloat totalWidth = _progressView.frame.size.width;
    CGFloat progressWidth =  totalWidth * _progressView.progress;
    
    CGFloat salaryViewWidth = CGRectGetWidth(_salaryView.frame);
    
    if (salaryViewWidth + progressWidth> _progressView.bounds.size.width) {
        _salaryViewLeftToProgress.constant = progressWidth - _salaryView.frame.size.width + 5;
        _arrowImgv.image = [UIImage imageNamed:@"icon_salary_right.png"];
    }else{
        _salaryViewLeftToProgress.constant =progressWidth - 3;
        _arrowImgv.image = [UIImage imageNamed:@"icon_salary_left.png"];
    }
}

@end
