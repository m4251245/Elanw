//
//  companySearchCell.m
//  jobClient
//
//  Created by 一览iOS on 15-1-27.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "CHRResumeCell.h"

@implementation CHRResumeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _imageBackView.clipsToBounds = YES;
    CALayer *layer = _imageBackView.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 4.f;
    
    _statusLb.layer.borderWidth = 0.5;
    _statusLb.layer.borderColor = UIColorFromRGB(0xe13e3e).CGColor;
    _statusLb.backgroundColor = [UIColor clearColor];
    
    _statusLb.layer.cornerRadius = 2;
    _statusLb.layer.masksToBounds = YES;
    
    _recomendReporterBtn.layer.borderWidth = 0.5;
    _recomendReporterBtn.layer.borderColor = UIColorFromRGB(0xbbbbbb).CGColor;
    _recomendReporterBtn.layer.cornerRadius = 3.0;
    _recomendReporterBtn.layer.masksToBounds = YES;
    
    _resetPasswordBtn.layer.cornerRadius = 3.0;
    _resetPasswordBtn.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)setUserModel:(User_DataModal *)userModel
{
    [self.userImg sd_setImageWithURL:[NSURL URLWithString:userModel.img_] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"] options:SDWebImageAllowInvalidSSLCertificates];
    self.userNameLb.text = userModel.uname_;
    NSString *city = userModel.regionCity_;
    NSString *workAge = userModel.gzNum_;
    NSString *eduName = userModel.eduName_;
    
    NSString *sex = userModel.sex_;
    
    
    if(userModel.age_.length < 4){
        if([userModel.age_ isEqualToString:@"暂无"]){
            [self.sexBtn setTitle:@"无" forState:UIControlStateNormal];
        }
        else{
            [self.sexBtn setTitle:userModel.age_ forState:UIControlStateNormal];
        }
    }
    else{
        [self.sexBtn setTitle:@"无" forState:UIControlStateNormal];
    }
    
    if ([sex isEqualToString:@"男"]) {
        [self.sexBtn setBackgroundImage:[UIImage imageNamed:@"icon_boy2.png"] forState:UIControlStateNormal];
        
    }else if ([sex isEqualToString:@"女"]){
        [self.sexBtn setBackgroundImage:[UIImage imageNamed:@"icon_girl2.png"] forState:UIControlStateNormal];
        
    }else{
        [self.sexBtn setBackgroundImage:[[UIImage alloc]init] forState:UIControlStateNormal];
    }
    self.statusLb.hidden = NO;
    
    if (userModel.isNewmail_) {
        self.statusLb.text = @"未阅";
        self.statuLbWidth.constant = 29;
    }else{
        self.statusLb.hidden = YES;
        self.statusLb.text = @"";
    }
    [self.statusLb sizeToFit];
    
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
        self.jobLb.text =[NSString stringWithFormat:@"应聘: %@", userModel.job_];
    }else{
        self.jobLb.text = @"";
    }
    
    if (_offerListFlag == YES && userModel.sendtime_.length > 10) {
        self.timeLb.text = [userModel.sendtime_ substringToIndex:10];
    }
    else{//将人才列表中的时间改为经纪人
        if (userModel.tuijianName.length > 0) {
            self.timeLb.text = [NSString stringWithFormat:@"经纪人: %@",userModel.tuijianName];
        }
        else
        {
            self.timeLb.text = @"前台报名";
        }
    }

}

@end
