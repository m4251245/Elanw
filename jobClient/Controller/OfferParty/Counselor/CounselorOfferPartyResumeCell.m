//
//  CounselorOfferPartyResumeCell.m
//  jobClient
//
//  Created by YL1001 on 16/9/18.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "CounselorOfferPartyResumeCell.h"

@implementation CounselorOfferPartyResumeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _resetPasswordBtn.layer.cornerRadius = 3.0;
    _resetPasswordBtn.layer.masksToBounds = YES;
    
    _statusLb.layer.borderWidth = 0.5;
    _statusLb.layer.borderColor = UIColorFromRGB(0xe13e3e).CGColor;
    _statusLb.backgroundColor = [UIColor clearColor];
    
    _statusLb.layer.cornerRadius = 2;
    _statusLb.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setUserModel:(User_DataModal *)userModel
{
    [self.userImg sd_setImageWithURL:[NSURL URLWithString:userModel.img_] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
    self.userNameLb.text = userModel.uname_;
    NSString *city = userModel.regionCity_;
    NSString *workAge = userModel.gzNum_;
    NSString *eduName = userModel.eduName_;
    
    NSString *sex = userModel.sex_;
    [self.sexBtn setTitle:[NSString stringWithFormat:@" %@", userModel.age_] forState:UIControlStateNormal];
    if ([sex isEqualToString:@"男"]) {
        [self.sexBtn setBackgroundImage:[UIImage imageNamed:@"icon_boy2.png"] forState:UIControlStateNormal];
        
    }else if ([sex isEqualToString:@"女"]){
        [self.sexBtn setBackgroundImage:[UIImage imageNamed:@"icon_girl2.png"] forState:UIControlStateNormal];
        
    }else{
        [self.sexBtn setBackgroundImage:[[UIImage alloc]init] forState:UIControlStateNormal];
    }
    self.statusLb.hidden = NO;
    
    NSDictionary *nameAttr = @{NSFontAttributeName:THIRTEENFONT_CONTENT, NSForegroundColorAttributeName:[UIColor blackColor]};
    NSDictionary *lineAttr = @{NSFontAttributeName:THIRTEENFONT_CONTENT, NSForegroundColorAttributeName:[UIColor lightGrayColor]};
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]init];
    if (city.length > 0) {
        [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:city attributes:nameAttr]];
    }
    if (workAge.length > 0)
    {
        if (attrString.length > 0)
        {
            [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:@" | " attributes:lineAttr]];
        }
        [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@年工作经验", workAge] attributes:nameAttr]];
    }
    
    if (eduName.length > 0)
    {
        if (attrString.length > 0)
        {
            [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:@" | " attributes:lineAttr]];
        }
        [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@", eduName] attributes:nameAttr]];
    }
    self.summaryLb.attributedText = attrString;
    
    if (userModel.job_.length > 0) {
        self.positionLb.text =[NSString stringWithFormat:@"应聘: %@", userModel.job_];
    }else{
        self.positionLb.text = @"";
    }
    
    if (userModel.tuijianName.length > 0) {
        self.timeLb.text = [NSString stringWithFormat:@"经纪人: %@",userModel.tuijianName];
    }
    else
    {
        self.timeLb.text = @"前台报名";
    }
    
    if (_resumelistType == OPResumeListTypeAllResume || _resumelistType == OPResumeListTypeConfirmToAttend) {
        if (userModel.joinstate == 1) {
            self.statusLb.text = @"已到场";
            self.statusLbWidth.constant = 40;
        }else if (userModel.joinstate == 2) {
            self.statusLb.text = @"未到场";
            self.statusLbWidth.constant = 40;
        }else if (userModel.joinstate == 3) {
            self.statusLb.text = @"初次确认";
            self.statusLbWidth.constant = 48;
        }else if (userModel.joinstate == 4){
            self.statusLb.text = @"最终确认";
            self.statusLbWidth.constant = 48;
        }else if (userModel.joinstate == 5){
            self.statusLb.text = @"确认不到场";
            self.statusLbWidth.constant = 60;
        }else{
            if (userModel.isNewmail_) {
                self.statusLb.text = @"未阅";
                self.statusLbWidth.constant = 29;
            }else{
                self.statusLb.hidden = YES;
                self.statusLb.text = @"";
            }
        }
    }
    else if (_resumelistType == OPResumeListTypeHasPresent)
    {
        self.statusLb.hidden = NO;
        if(userModel.resumeType == OPResumeTypeToInterview){
            self.statusLb.text = @"等候面试";
            self.statusLbWidth.constant = 48;
        }else if(userModel.resumeType == OPResumeTypeInterviewed){
            self.statusLb.text = @"面试合格";
            self.statusLbWidth.constant = 48;
        }else if(userModel.resumeType == OPResumeTypeLeaved){
            self.statusLb.text = @"已离场";
            self.statusLbWidth.constant = 40;
        }else if (userModel.resumeType == OPResumeTypeNoConfirFit){
            self.statusLb.text = @"不通过初选";
            self.statusLbWidth.constant = 60;
        }else{
            self.statusLb.hidden = YES;
        }
    }
    else
    {
        if (userModel.isNewmail_) {
            self.statusLb.text = @"未阅";
            self.statusLbWidth.constant = 29;
        }else{
            self.statusLb.hidden = YES;
            self.statusLb.text = @"";
        }
    }

}

@end
