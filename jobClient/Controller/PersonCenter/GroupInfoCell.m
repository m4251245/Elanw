//
//  GroupInfoCell.m
//  jobClient
//
//  Created by 一览iOS on 14-10-30.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "GroupInfoCell.h"
#import "Groups_DataModal.h"
#import "NoLoginPromptCtl.h"

@interface GroupInfoCell()<NoLoginDelegate>

@end

@implementation GroupInfoCell

- (void)awakeFromNib
{
    // Initialization code
    [self.titleLb_ setFont:FIFTEENFONT_TITLE];
    [self.titleLb_ setTextColor:BLACKCOLOR];
    [self.dynamicLb_ setFont:FOURTEENFONT_CONTENT];
    self.aplayBtn_.layer.cornerRadius = 2.0;
    [self.aplayBtn_.titleLabel setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:10]];
    self.aplayBtn_.layer.masksToBounds = YES;
    self.aplayBtn_.layer.borderColor = [UIColor colorWithRed:226.0/255.0 green:62/255.0 blue:63/255.0 alpha:1.0].CGColor;
    [self.aplayBtn_ setTitleColor:[UIColor colorWithRed:226.0/255.0 green:62/255.0 blue:63/255.0 alpha:1.0] forState:UIControlStateNormal];
    self.aplayBtn_.layer.borderWidth = 0.5;
    [super awakeFromNib];
}

-(void)setModel:(Groups_DataModal *)model{
    _model = model;
    [self.titleLb_ setText:model.name_];
    self.menberCountLb_.text = [NSString stringWithFormat:@"成员%ld",(long)model.personCnt_];
    self.articleCountLb_.text = [NSString stringWithFormat:@"话题%ld",(long)model.articleCnt_];
    [self.photoImgv_ sd_setImageWithURL:[NSURL URLWithString:model.pic_] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
    
    if (model.firstArt_.title_ == nil) {
        [self.dynamicLb_ setText:@"暂无动态"];
    }else{
        NSString *str = [NSString stringWithFormat:@"%@ 发表:%@",model.firstArt_.personName_, model.firstArt_.title_];
        [self.dynamicLb_ setText:str];
        self.dynamicLb_.lineBreakMode = NSLineBreakByTruncatingTail;
    }

    [self.aplayBtn_ addTarget:self action:@selector(applyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    if ([model.openstatus_ isEqualToString:@"3"]){
        self.privacyImageView.hidden = NO;
    }else{
        self.privacyImageView.hidden = YES;
    }
    if (_isMyCenter)
    {
        self.aplayBtn_.hidden = YES;
    }
    else
    {
        if (model.code_ != nil)
        {
            if ([model.code_ isEqualToString:@"200"] || [model.code_ isEqualToString:@"202"]) {
                [self.aplayBtn_ setTitle:@"申请加入" forState:UIControlStateNormal];
                [self.aplayBtn_ setUserInteractionEnabled:YES];
                [self.aplayBtn_ setHidden:NO];
            }else if ([model.code_ isEqualToString:@"199"]){
                [self.aplayBtn_ setTitle:@"等待审核" forState:UIControlStateNormal];
                [self.aplayBtn_ setUserInteractionEnabled:NO];
                [self.aplayBtn_ setHidden:NO];
            }else{
                [self.aplayBtn_ setHidden:YES];
            }
        }else{
            [self.aplayBtn_ setTitle:@"申请加入" forState:UIControlStateNormal];
            [self.aplayBtn_ setUserInteractionEnabled:YES];
            [self.aplayBtn_ setHidden:NO];
        }
    }
}

- (void)applyBtnClick:(UIButton *)button
{
    if (![Manager shareMgr].haveLogin) {
        [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
        return;
    }
    NSString *bodyMsg = [NSString stringWithFormat:@"group_id=%@&request_person_id=%@",_model.id_,[Manager getUserInfo].userId_];
    NSMutableDictionary *insertDic = [[NSMutableDictionary alloc]init];
    [insertDic setObject:@"" forKey:@"reason"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *insertStr = [jsonWriter stringWithObject:insertDic];
    bodyMsg = [NSString stringWithFormat:@"group_id=%@&request_person_id=%@&insertArr=%@",_model.id_,[Manager getUserInfo].userId_,insertStr];
    
    [ELRequest postbodyMsg:bodyMsg op:@"groups_person" func:@"doRequestJoin" requestVersion:NO progressFlag:YES progressMsg:@"正在申请" success:^(NSURLSessionDataTask *operation, id result) {
        NSDictionary *dic = result;
        if ([dic isKindOfClass:[NSDictionary class]]) {
            Status_DataModal * dataModal = [[Status_DataModal alloc] init];
            
            dataModal.code_ = [dic objectForKey:@"code"];
            dataModal.status_ = [dic objectForKey:@"status"];
            dataModal.des_ = [dic objectForKey:@"status_desc"];
            dataModal.status_ = [dataModal.status_ uppercaseString];
            
            if([dataModal.status_ isEqualToString:@"OK"])
            {
                [[Manager shareMgr] showSayViewWihtType:2];
            }
            if ([dataModal.status_ isEqualToString:Success_Status]) {
                if ([dataModal.code_ isEqualToString:@"200"]) {
                    //审核中
                    [self.aplayBtn_ setTitle:@"等待审核" forState:UIControlStateNormal];
                    [self.aplayBtn_ setUserInteractionEnabled:NO];
                    [self.aplayBtn_ setHidden:NO];
                    
                    _model.groupRel_ = @"199";
                    [BaseUIViewController showAutoDismissSucessView:@"申请成功,等待审核" msg:nil];
                }else if ([dataModal.code_ isEqualToString:@"100"]){
                    [self.aplayBtn_ setHidden:YES];
                    _model.groupRel_ = @"11";
                    [BaseUIViewController showAutoDismissSucessView:@"加入成功" msg:nil];
                }
            }
            else
            {
                [BaseUIViewController showAutoDismissFailView:nil msg:dataModal.des_];
            }
        }
        

    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
    
//    if (!jionCon_) {
//        jionCon_ = [self getNewRequestCon:NO];
//    }
//    [jionCon_ joinGroup:[Manager getUserInfo].userId_ group:model.id_ content:@""];
}

-(void)loginDelegateCtl
{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
