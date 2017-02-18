//
//  GroupsMessage_Cell.m
//  jobClient
//
//  Created by YL1001 on 14/10/30.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "GroupsMessage_Cell.h"
#import "GroupInvite_DataModal.h"

@implementation GroupsMessage_Cell

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
    
    self.myBtn_.layer.cornerRadius = 2.0;
    self.bgView_.layer.borderColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0].CGColor;
    self.bgView_.layer.borderWidth = 0.5;
    self.markNewImg_.layer.cornerRadius = 5.0;
    self.markNewImg_.layer.masksToBounds = YES;
    self.userImg_.layer.cornerRadius = 3.0;
    self.userImg_.layer.masksToBounds = YES;
    
    [self.nameLb_ setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:13]];
    [self.nameLb_ setTextColor:DARKBLACKCOLOR];
    [self.statusLb_ setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:13]];
    [self.statusLb_ setTextColor:GRAYCOLOR];
    [self.groupsNameLb_ setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:13]];
    [self.groupsNameLb_ setTextColor:BLACKCOLOR];
    [self.timeLb_ setFont:NINEFONT_TIME];
    [self.timeLb_ setTextColor:LIGHTGRAYCOLOR];
    [self.reasonLb setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:13]];
    [self.reasonLb setTextColor:GRAYCOLOR];

}

- (void)setDataModel:(GroupInvite_DataModal *)dataModel
{
    _dataModel = dataModel;
    
    self.nameLb_.text = dataModel.requestInfo_.iname_;
    self.timeLb_.text = dataModel.idatetime_;
    self.groupsNameLb_.text = dataModel.groupInfo_.name_;
    [self.userBtn_ addTarget:self action:@selector(userBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (!dataModel.requestInfo_.isExpert_) {
        self.expertImg_.alpha = 0.0;
        self.nameLeftToUimg.constant = 8;
    }
    else
    {
        self.expertImg_.alpha = 1.0;
        self.nameLeftToUimg.constant = 18;
    }
    
    CGRect  statusRect = self.statusLb_.frame;
    if ([dataModel.type_ isEqualToString:@"201"] ) {
        //受邀加入某社群
        self.statusLb_.text = [NSString stringWithFormat:@"邀请您加入："];
    }
    if ([dataModel.type_ isEqualToString:@"202"]) {
        self.statusLb_.text = [NSString stringWithFormat:@"申请加入："];
    }
    [self.statusLb_ setFrame:statusRect];
    
    
    if ([dataModel.resultStatus_ isEqualToString:@"agree"]) {
        [self.myBtn_ setTitle:@"已同意" forState:UIControlStateSelected];
        [self.myBtn_ setSelected:YES];
        [self.myBtn_ setBackgroundColor:[UIColor clearColor]];
    }
    else if([dataModel.resultStatus_ isEqualToString:@"ignore"]){
        [self.myBtn_ setTitle:@"已忽略" forState:UIControlStateSelected];
        [self.myBtn_ setSelected:YES];
        [self.myBtn_ setBackgroundColor:[UIColor clearColor]];
    }
    else
    {
        [self.myBtn_ setTitle:@"同意" forState:UIControlStateSelected];
        [self.myBtn_ setSelected:NO];
        [self.myBtn_ setBackgroundColor:[UIColor colorWithRed:196.0/255.0 green:0.0/255.0 blue:8.0/255.0 alpha:1.0]];
        [self.myBtn_ addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (dataModel.bRead_) {
        self.markNewImg_.alpha = 0.0;
    }
    else{
        self.markNewImg_.alpha = 1.0;
    }
    
    [self.userImg_ sd_setImageWithURL:[NSURL URLWithString:dataModel.requestInfo_.img_] placeholderImage:[UIImage imageNamed:@"bg__xinwen"]];
    
    if (dataModel.reason.length > 0) {
        [self.reasonLb setHidden:NO];
        [self.reasonLb setText:dataModel.reason];
    }
    else{
        self.reasonLb.text = @"";
    }
}

-(void)updateView
{
    _dataModel.resultStatus_ = @"agree";
    [self.myBtn_ setTitle:@"已同意" forState:UIControlStateSelected];
    [self.myBtn_ setSelected:YES];
    [self.myBtn_ setBackgroundColor:[UIColor clearColor]];
}

- (void)userBtnClick:(UIButton *)sender
{
    ELPersonCenterCtl *personCtl = [[ELPersonCenterCtl alloc] init];
    [[MyCommon viewController:self.superview].navigationController pushViewController:personCtl animated:NO];
    [personCtl beginLoad:_dataModel.requestInfo_.id_ exParam:nil];
    
}

- (void)btnClick:(UIButton *)sender
{
    NSString *dealtypeStr = @"agree";
    if ([_dataModel.type_ isEqualToString:@"201"]) {
        //处理邀请
        [self handleGroupInvitation:dealtypeStr];
    }
    else if([_dataModel.type_ isEqualToString:@"202"]){
        //处理申请
        [self handleGroupApply:dealtypeStr];
    }
    
    [self updateView];
}

- (void)handleGroupInvitation:(NSString *)dealtypeStr
{
    NSString * bodyMsg = [NSString stringWithFormat:@"group_id=%@&request_person_id=%@&respone_person_id=%@&dealtype=%@&logs_id=%@", _dataModel.groupInfo_.id_, _dataModel.createrId_, [Manager getUserInfo].userId_, dealtypeStr, _dataModel.id_];

    NSString * function = @"doResponeInvite";
    NSString * op = @"groups_person";

    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:NO success:^(NSURLSessionDataTask *operation, id result) {
        
        NSDictionary *dic = result;
        
        Status_DataModal * dataModal = [[Status_DataModal alloc] init];
        dataModal.status_ = [dic objectForKey:@"status"];
        dataModal.code_ = [dic objectForKey:@"code"];
        dataModal.des_ = [dic objectForKey:@"status_desc"];
        dataModal.exObj_ = [dic objectForKey:@"info"];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

- (void)handleGroupApply:(NSString *)dealTypeStr
{
    NSString * bodyMsg = [NSString stringWithFormat:@"group_id=%@&request_person_id=%@&respone_person_id=%@&dealtype=%@&logs_id=%@", _dataModel.groupInfo_.id_, _dataModel.createrId_, [Manager getUserInfo].userId_, dealTypeStr, _dataModel.id_];
    NSString * function = @"doResponeJoin";
    NSString * op = @"groups_person";
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:NO success:^(NSURLSessionDataTask *operation, id result) {
        
        NSDictionary *dic = result;
        
        Status_DataModal * dataModal = [[Status_DataModal alloc] init];
        dataModal.status_ = [dic objectForKey:@"status"];
        dataModal.code_ = [dic objectForKey:@"code"];
        dataModal.des_ = [dic objectForKey:@"status_desc"];
        dataModal.exObj_ = [dic objectForKey:@"info"];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
