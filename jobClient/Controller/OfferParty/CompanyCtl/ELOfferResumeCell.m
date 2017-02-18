//
//  ELOfferResumeCell.m
//  jobClient
//
//  Created by 一览iOS on 16/5/18.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELOfferResumeCell.h"
#import "OfferPartyCompanyResumeModel.h"

@implementation ELOfferResumeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _imageBackView.clipsToBounds = YES;
    _imageBackView.layer.cornerRadius = 4.0;
    
    _expertsCommentBtn.clipsToBounds = YES;
    _expertsCommentBtn.layer.borderWidth = 0.5;
    _expertsCommentBtn.layer.borderColor = UIColorFromRGB(0xbbbbbb).CGColor;
    _expertsCommentBtn.layer.cornerRadius = 3.0;
    
    _noticeInterviewBtn.clipsToBounds = YES;
    _noticeInterviewBtn.layer.cornerRadius = 3.0;
    
    _statusLb.clipsToBounds = YES;
    _statusLb.layer.cornerRadius = 2.0;
    _statusLb.layer.borderColor = PINGLUNHONG.CGColor;
    _statusLb.layer.borderWidth = 0.5;
    
    _delayInterviewBtn.hidden = YES;//
    _delayInterviewBtn.clipsToBounds = YES;
    _delayInterviewBtn.layer.cornerRadius = 3.0;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

-(void)setDataModal:(User_DataModal *)dataModal
{
    _dataModal = dataModal;
    
    [self.userImg sd_setImageWithURL:[NSURL URLWithString:dataModal.img_] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
    self.userNameLb.text = dataModal.uname_;
    NSString *city = dataModal.regionCity_;
    NSString *workAge = dataModal.gzNum_;
    NSString *eduName = dataModal.eduName_;
    
    [self.sexBtn setTitle:dataModal.age_ forState:UIControlStateNormal];

    NSString *sex = dataModal.sex_;
    if ([sex isEqualToString:@"男"]) {
        [self.sexBtn setBackgroundImage:[UIImage imageNamed:@"icon_boy2.png"] forState:UIControlStateNormal];
        
    }else if ([sex isEqualToString:@"女"]){
        [self.sexBtn setBackgroundImage:[UIImage imageNamed:@"icon_girl2.png"] forState:UIControlStateNormal];
        
    }else{
        [self.sexBtn setBackgroundImage:[[UIImage alloc]init] forState:UIControlStateNormal];
        [self.sexBtn setTitle:@"" forState:UIControlStateNormal];
    }
    self.statusLb.hidden = NO;
    
    
    //面试状态
    if (dataModal.isNewmail_) {
        self.statusLb.text = @"未阅";
    }
    else
    {
        if ([dataModal.forType isEqualToString:@"3001"]) {
            self.statusLb.hidden = YES;
            _joinStatusImage.hidden = YES;
            _noticeInterviewBtn.hidden = YES;
            _delayInterviewBtn.hidden = YES;
            return;
        }
        if (dataModal.resumeType == OPResumeTypeWorked) {
            self.statusLb.text = @"已上岗";
            
        }
        else if (dataModal.resumeType == OPResumeTypeSendOffer) {
            self.statusLb.text = @"已发offer";
        }
        else if (dataModal.resumeType == OPResumeTypeNoConfirFit){
            self.statusLb.text = @"简历不合适";
        }
        else if (dataModal.resumeType == OPResumeTypeInterviewed) {
            self.statusLb.text = @"初面通过";
        }
        else if(dataModal.resumeType == OPResumeTypeInterviewUnqualified) {
            self.statusLb.text = @"初面不通过";
        }
        else if (dataModal.resumeType == OPResumeTypeConfirmFit) {
            self.statusLb.text = @"简历合适";
        }
        else if (dataModal.resumeType == OPResumeTypeWait) {//待确定
            self.statusLb.text = @"简历待确定";
        }
        else if (dataModal.resumeType == OPResumeTypenotOperating){//待处理
            self.statusLb.text = @"简历待处理";
        }
        else if (dataModal.resumeType == OPResumeTypeGivedUpInterview){
            self.statusLb.text = @"已放弃面试";
        }
        else if ((dataModal.resumeType == OPResumeTypenotOperating || dataModal.resumeType == OPResumeTypeWait) && [dataModal.wait_mianshi isEqualToString:@"1"] && [dataModal.add_user isEqualToString:@"0"]){
            self.statusLb.text = @"主动申请";
        }
        else if ((dataModal.resumeType == OPResumeTypenotOperating || dataModal.resumeType == OPResumeTypeWait) && [dataModal.wait_mianshi isEqualToString:@"1"] && [dataModal.add_user integerValue] > 0){
            self.statusLb.text = @"顾问推荐";
        }
        else{
            [self.statusLb setHidden:YES];
        }
        
    }
    
    //面试状态
    _joinStatusImage.hidden = YES;
    
    if ([self.fromtype isEqualToString:@"offer"]) 
    {
        if ((_resumeListType != ComResumeListTypeHasInterviewed && [dataModal.leaveState isEqualToString:@"1"]))
        {//已离场
            self.joinStatusImage.image = [UIImage imageNamed:@"offer_status_lichang"];
            
            if (dataModal.resumeType == OPResumeTypeWorked || dataModal.resumeType == OPResumeTypeSendOffer || dataModal.resumeType == OPResumeTypeInterviewed || dataModal.resumeType == OPResumeTypeInterviewUnqualified) {
                //已上岗、已发offer、初次面试合格、初次面试不合格 状态下不显示离场标签
                _joinStatusImage.hidden = YES;
            }
            else {
                _joinStatusImage.hidden = NO;
            }
        }
        else if ([dataModal.wait_mianshi isEqualToString:@"1"]) {
            if (_resumeListType == ComResumeListTypeHasPresent || _resumeListType == ComResumeListTypePrimaryElection || _resumeListType == ComResumeListTypeAllPerson) {
                self.joinStatusImage.image = [UIImage imageNamed:@"offer_status_denghoumianshi"];
                _joinStatusImage.hidden = NO;
            }
        }
        else if ([dataModal.joinState isEqualToString:@"1"] && (_resumeType != OPResumeTypePresent))
        {//已到场
            
            self.joinStatusImage.image = [UIImage imageNamed:@"offer_status_daochang"];
            _joinStatusImage.hidden = NO;
        }
    }
    else if ([self.fromtype isEqualToString:@"kpb"]){
        
        if ([dataModal.joinState isEqualToString:@"1"] && (dataModal.resumeType != OPResumeTypeWorked) && (dataModal.resumeType !=OPResumeTypePresent) && (dataModal.resumeType != OPResumeTypeSendOffer) && [dataModal.interviewState isEqualToString:@""])
        {
            self.joinStatusImage.image = [UIImage imageNamed:@"offer_status_yiyuyue"];
            _joinStatusImage.hidden = NO;
        }
        
    }
    else if ([self.fromtype isEqualToString:@"vph"])
    {
        if ((_resumeListType != ComResumeListTypeHasInterviewed && [dataModal.leaveState isEqualToString:@"1"]))
        {//已离场
            self.joinStatusImage.image = [UIImage imageNamed:@"offer_status_lichang"];
            
            if (dataModal.resumeType == OPResumeTypeWorked || dataModal.resumeType == OPResumeTypeSendOffer || dataModal.resumeType == OPResumeTypeInterviewed || dataModal.resumeType == OPResumeTypeInterviewUnqualified) {
                //已上岗、已发offer、初次面试合格、初次面试不合格 状态下不显示离场标签
                _joinStatusImage.hidden = YES;
            }
            else
            {
                _joinStatusImage.hidden = NO;
            }
        }
        else if ([dataModal.joinState isEqualToString:@"1"] && (_resumeType == OPResumeTypeAdvisersRecommend))
        {
            self.joinStatusImage.image = [UIImage imageNamed:@"offer_status_daochang"];
            _joinStatusImage.hidden = NO;
        }

    }
    
    if (dataModal.report.length > 0 && dataModal.report.integerValue == 1)
    {
        self.expertsCommentBtn.hidden = NO;
        self.interViewRightWidth.constant = 87;
        
    }
    else{
        self.expertsCommentBtn.hidden = YES;
        self.interViewRightWidth.constant = 10;
    }
    
    self.noticeInterviewBtn.hidden = YES;
    if (_resumeListType == ComResumeListTypeToInterview)
    {
        if (([self.fromtype isEqualToString:@"offer"] || [self.fromtype isEqualToString:@"vph"]) && _indexPathRow <= 4) {
             self.noticeInterviewBtn.hidden = NO;
        }
    }

    CGSize size = [self.statusLb.text sizeNewWithFont:self.statusLb.font];
    self.statusLbaleWidth.constant =  size.width + 5;
    
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
    
    if (dataModal.job_.length > 0) {
        self.jobLb.text =[NSString stringWithFormat:@"推荐职位: %@", dataModal.job_];
    }else{
        self.jobLb.text = @"";
    }
    
    if (dataModal.sendtime_.length>10) {
        self.timeLb.text = [dataModal.sendtime_ substringToIndex:10];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
