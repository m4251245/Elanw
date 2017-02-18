//
//  ELActivityPeopleCell.m
//  jobClient
//
//  Created by 一览iOS on 15/9/16.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELActivityPeopleCell.h"
#import "BaseUIViewController.h"


@implementation ELActivityPeopleCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    _backView.clipsToBounds = YES;
    _backView.layer.cornerRadius = 4.0;
    _personImage.clipsToBounds = YES;
    _personImage.layer.cornerRadius = 20.0;
    
    _agreeBtn.clipsToBounds = YES;
    _agreeBtn.layer.cornerRadius = 3.0;
    _noAgreeBtn.clipsToBounds = YES;
    _noAgreeBtn.layer.cornerRadius = 3.0;
    _noAgreeBtn.layer.borderColor = [UIColor grayColor].CGColor;
    _noAgreeBtn.layer.borderWidth = 0.5;
    
    [_agreeBtn addTarget:self action:@selector(agreeBtnRespone:) forControlEvents:UIControlEventTouchUpInside];
    [_noAgreeBtn addTarget:self action:@selector(agreeBtnRespone:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setModal:(ELActivityPeopleFrameModel *)modal{
    _modal = modal;
    self.timeLb.text = [MyCommon getWhoLikeMeListCurrentTime:[MyCommon getDate:modal.peopleModel.idatetime] currentTimeString:modal.peopleModel.idatetime];
    
    [self.personImage sd_setImageWithURL:[NSURL URLWithString:modal.peopleModel.person_pic] placeholderImage:[UIImage imageNamed:@"bg__xinwen"]];
    
    //@"gaae_name",@"gaae_contacts",@"company",@"group",@"jobs",@"email",@"remark"
    self.personName.text = modal.peopleModel.gaae_name;
    self.personJob.text = modal.peopleModel.jobs;
    if (modal.arrListData.count > 0)
    {
        for (NSInteger i = 0;i<modal.arrListData.count; i++)
        {
            UIImageView *imageView = (UIImageView *)[self viewWithTag:121+i];
            UILabel *label = (UILabel *)[self viewWithTag:221+i];
            label.numberOfLines = 1;
            if ([modal.arrListData[i] isEqualToString:@"gaae_contacts"])
            {
                imageView.image = [UIImage imageNamed:@"activityphone.png"];
                label.text = modal.peopleModel.gaae_contacts;
            }
            else if ([modal.arrListData[i] isEqualToString:@"company"])
            {
                imageView.image = [UIImage imageNamed:@"activitycompany.png"];
                label.text = modal.peopleModel.company;
            }
            else if ([modal.arrListData[i] isEqualToString:@"group"])
            {
                imageView.image = [UIImage imageNamed:@"activity_group.png"];
                label.text = modal.peopleModel.group;
            }
            else if ([modal.arrListData[i] isEqualToString:@"email"])
            {
                imageView.image = [UIImage imageNamed:@"activity_email.png"];
                label.text = modal.peopleModel.email;
            }
            else if ([modal.arrListData[i] isEqualToString:@"remark"])
            {
                CGSize size = [modal.peopleModel.remark sizeNewWithFont:label.font constrainedToSize:CGSizeMake(ScreenWidth-63,10000)];
                CGRect frame = label.frame;
                frame.origin.y = 60+24*i;
                frame.size.height = size.height + 5;
                label.frame = frame;
                
                //label.frame = CGRectMake(38,60+24*i,ScreenWidth-63,size.height + 5);
                imageView.frame = CGRectMake(20,65+24*i,12,12);
                imageView.image = [UIImage imageNamed:@"activitycontent.png"];
                label.numberOfLines = 0;
                label.text = modal.peopleModel.remark;
            }
        }
    }
//    CGRect frame = self.backView.frame;
//    frame.size.height = modal.cellHeight - 8;
//    self.backView.frame = frame;
    if (_isCreatGroup) {
        _agreeView.hidden = NO;
        if ([modal.agreeStatus isEqualToString:@"已同意"]) {
            _agreeBtn.hidden = YES;
            _noAgreeBtn.hidden = YES;
            _agreeLable.hidden = NO;
            _agreeLable.text = @"已同意";
            _agreeLable.textColor = UIColorFromRGB(0xe13e3e);
        }else if([modal.agreeStatus isEqualToString:@"已忽略"]){
            _agreeBtn.hidden = YES;
            _noAgreeBtn.hidden = YES;
            _agreeLable.hidden = NO;
            _agreeLable.text = @"已忽略";
            _agreeLable.textColor = UIColorFromRGB(0xaaaaaa);
        }else if([modal.agreeStatus isEqualToString:@"未处理"]){
            _agreeBtn.hidden = NO;
            _noAgreeBtn.hidden = NO;
            _agreeLable.hidden = YES;
        }
    }else{
        _agreeView.hidden = YES;
    }
}

-(void)agreeBtnRespone:(UIButton *)button{
    NSString *status = @"";
    NSString *content = @"";
    if (button == _agreeBtn) {
        status = @"1";
        content = @"正在同意";
    }else if(button == _noAgreeBtn){
        status = @"0";
        content = @"正在忽略";
    }
    if(status <= 0){
        return;
    }
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:status forKey:@"is_agree_add_activity"];
    [searchDic setObject:_modal.peopleModel.gaae_id forKey:@"gaae_id"];
    [searchDic setObject:[Manager getUserInfo].userId_ forKey:@"login_person_id"];
    SBJsonWriter *jsonWriterOne = [[SBJsonWriter alloc] init];
    NSString * searchDicStr = [jsonWriterOne stringWithObject:searchDic];
    NSString *bodyMsg = [NSString stringWithFormat:@"searchArr=%@",searchDicStr];
    [ELRequest postbodyMsg:bodyMsg op:@"salarycheck_all_busi" func:@"do_join_activity" requestVersion:YES progressFlag:YES progressMsg:content success:^(NSURLSessionDataTask *operation, id result) {
        NSDictionary *dic = result;
        NSString *statusOne = dic[@"status"];
        NSString *status_desc = dic[@"status_desc"];
        if ([statusOne isEqualToString:@"OK"]) {
            _agreeBtn.hidden = YES;
            _noAgreeBtn.hidden = YES;
            _agreeLable.hidden = NO;
            if (button == _agreeBtn) {
                _agreeLable.text = @"已同意";
                _agreeLable.textColor = UIColorFromRGB(0xe13e3e);
                _modal.agreeStatus = @"已同意";
                _modal.peopleModel.enroll_status = @"100";
            }else if(button == _noAgreeBtn){
                _agreeLable.text = @"已忽略";
                _agreeLable.textColor = UIColorFromRGB(0xaaaaaa);
                _modal.agreeStatus = @"已忽略";
                _modal.peopleModel.enroll_status = @"50";
            }
            [BaseUIViewController showAutoDismissSucessView:@"操作成功" msg:status_desc];
        }else{
            [BaseUIViewController showAutoDismissFailView:@"操作失败" msg:status_desc];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
       
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
