//
//  SameTradeCell.m
//  jobClient
//
//  Created by YL1001 on 15/2/4.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "SameTradeCell.h"
#import "BaseUIViewController.h"
#import "ELPersonCenterCtl.h"


@interface SameTradeCell() <NoLoginDelegate,PersonCenterCtlDelegate>

@end

@implementation SameTradeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatCell];
    }
    return self;
}

-(void)creatCell{
    _phototImgv_ = [[UIImageView alloc] initWithFrame:CGRectMake(10,15,63,63)];
    _phototImgv_.clipsToBounds = YES;
    self.phototImgv_.layer.cornerRadius = 4.5;
    self.phototImgv_.layer.masksToBounds = YES;
    self.phototImgv_.userInteractionEnabled = YES;
    [self.phototImgv_ addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapClick:)]];
    [self.contentView addSubview:_phototImgv_];
    
    self.nameLb_ = [[UILabel alloc] initWithFrame:CGRectMake(80,15,ScreenWidth-90,20)];
    self.nameLb_.font = [UIFont systemFontOfSize:16];
    self.nameLb_.textColor = UIColorFromRGB(0x212121);
    [self.contentView addSubview:self.nameLb_];
    
    self.workAgeLb_ = [[UILabel alloc] initWithFrame:CGRectMake(80,36,ScreenWidth-90,20)];
    self.workAgeLb_.font = [UIFont systemFontOfSize:16];
    self.workAgeLb_.textColor = UIColorFromRGB(0x616161);
    [self.contentView addSubview:self.workAgeLb_];

    self.dynamicLb_ = [[UILabel alloc] initWithFrame:CGRectMake(80,58,ScreenWidth-90,20)];
    self.dynamicLb_.font = [UIFont systemFontOfSize:14];
    self.dynamicLb_.textColor = UIColorFromRGB(0x9e9e9e);
    self.dynamicLb_.userInteractionEnabled = YES;
    [self.dynamicLb_ addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dynamicBtnClick:)]];
    [self.contentView addSubview:self.dynamicLb_];
    
    self.markImgv_ = [[UIImageView alloc] initWithFrame:CGRectMake(80,15,14,15)];
    self.markImgv_.image = [UIImage imageNamed:@"expertsmark"];
    [self.contentView addSubview:self.markImgv_];
    
    self.ageView = [[UIView alloc] initWithFrame:CGRectMake(0,0,40,15)];
    self.ageView.backgroundColor = UIColorFromRGB(0x8ca8f1);
    self.ageView.layer.cornerRadius = 2.0;
    self.ageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.ageView];
    
    self.ageImage = [[UIImageView alloc] initWithFrame:CGRectMake(4,3,9,9)];
    [self.ageView addSubview:self.ageImage];
    
    self.ageLb = [[UILabel alloc] initWithFrame:CGRectMake(16,0,30,15)];
    self.ageLb.textColor = [UIColor whiteColor];
    self.ageLb.font = NINEFONT_TIME;
    [self.ageView addSubview:self.ageLb];
    
    self.lineView = [[ELLineView alloc] initWithFrame:CGRectMake(10,92,ScreenWidth-10,1) WithColor:UIColorFromRGB(0xe0e0e0)];
    [self.contentView addSubview:self.lineView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setPeopleModel:(ELSameTradePeopleFrameModel *)peopleModel{
    _peopleModel = peopleModel;
    ELSameTradePeopleFrameModel *model = peopleModel;
    
    [self.phototImgv_ sd_setImageWithURL:[NSURL URLWithString:model.peopleModel.person_pic]placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
    
    CGFloat nameWidth = ScreenWidth - 90;//标识用户名的最大宽度
    CGFloat nameX = 80; //标识用户名的X
    CGFloat workX =80;
    
    if (_hideDynamic) {
        nameWidth = ScreenWidth -73;
        nameX = 63;
        workX = 63;
    }
    self.markImgv_.frame = CGRectMake(nameX,15,14,15);
    //动态行家标识
    if ([model.peopleModel.is_expert isEqualToString:@"1"])
    {
        self.markImgv_.hidden = NO;
        nameWidth -= 18;
        nameX = CGRectGetMaxX(self.markImgv_.frame)+3;
    }else{
        self.markImgv_.hidden = YES;
    }
    
    //是否显示私信、关注按钮判断
    CGRect frame = self.workAgeLb_.frame;
    if (_showMessageButton || _showAttentionButton){
        frame.size.width = ScreenWidth-55-workX;
        nameWidth -= 45;
        if (!_rightButtonView) {
            _rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth-55,25,44,44)];
            _rightButtonView.userInteractionEnabled = YES;
            [_rightButtonView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightBtnRespone:)]];
            [self.contentView addSubview:_rightButtonView];
            
            _rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(15,5,15,16)];
            [_rightButtonView addSubview:_rightImage];
            
            _rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,25,44,20)];
            _rightLabel.textAlignment = NSTextAlignmentCenter;
            _rightLabel.font = [UIFont systemFontOfSize:14];
            [_rightButtonView addSubview:_rightLabel];
        }
        _rightButtonView.hidden = NO;
        if (_showMessageButton) {
            self.rightImage.image = [UIImage imageNamed:@"message_button_image"];
            self.rightLabel.text = @"私信";
            self.rightLabel.textColor = UIColorFromRGB(0x616161);
        }else{
            //关注状态
            if ([model.peopleModel.rel integerValue] == 1) {
                self.rightImage.image = [UIImage imageNamed:@"attention_cancel_image"];
                self.rightLabel.text = @"已关注";
                self.rightLabel.textColor = UIColorFromRGB(0x9e9e9e);
            }else{
                self.rightImage.image = [UIImage imageNamed:@"attention_success_image"];
                self.rightLabel.text = @"关注";
                self.rightLabel.textColor = UIColorFromRGB(0x616161);
            }
        }
    }else{
        frame.size.width = ScreenWidth-workX-10;
        if (_rightButtonView) {
            _rightButtonView.hidden = YES;
        }
    }
    if(_hideDynamic){
        frame.origin.y = 39;
    }else{
        frame.origin.y = 36;
    }
    frame.origin.x = workX;
    _workAgeLb_.frame = frame;
    
    frame = _dynamicLb_.frame;
    frame.size.width = _workAgeLb_.width;
    _dynamicLb_.frame = frame;
    
    //实名判断
    if ([model.peopleModel.is_shiming isEqualToString:@"1"]){
        if (!self.realNameLabel) {
            self.realNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,40,15)];
            self.realNameLabel.font = NINEFONT_TIME;
            self.realNameLabel.textAlignment = NSTextAlignmentCenter;
            self.realNameLabel.textColor = [UIColor whiteColor];
            self.realNameLabel.backgroundColor = UIColorFromRGB(0x43bc4f);
            self.realNameLabel.layer.cornerRadius = 2.0;
            self.realNameLabel.layer.masksToBounds = YES;
            self.realNameLabel.text = @"已认证";
            [self.contentView addSubview:self.realNameLabel
             ];
        }
        self.realNameLabel.hidden = NO;
        nameWidth -= 45;
    }else{
        if (self.realNameLabel) {
            self.realNameLabel.hidden = YES;
        }
    }
    //年龄性别
    CGFloat ageLbX = 16;
    self.ageImage.hidden = NO;
    if ([model.peopleModel.person_sex isEqualToString:@"男"]) {
        self.ageImage.image = [UIImage imageNamed:@"boy_image"];
        self.ageView.backgroundColor = UIColorFromRGB(0x8ca8f1);
    }else if([model.peopleModel.person_sex isEqualToString:@"女"]){
        self.ageImage.image = [UIImage imageNamed:@"girl_image"];
        self.ageView.backgroundColor = UIColorFromRGB(0xef8cc3);
    }else{
        self.ageImage.hidden = YES;
        self.ageView.backgroundColor = UIColorFromRGB(0x8ca8f1);
        ageLbX = 3;
    }
    if ([model.peopleModel.age integerValue] > 0) {
        [self.ageLb setText:model.peopleModel.age];
        
    }else if ([model.peopleModel.person_age integerValue] > 0){
        [self.ageLb setText:model.peopleModel.person_age];
    }else{
        [self.ageLb setText:@"保密"];
    }
    [self.ageLb sizeToFit];
    frame = self.ageLb.frame;
    frame.size.height = 15;
    frame.origin.x = ageLbX;
    self.ageLb.frame = frame;
    nameWidth -= 40;
    
    //同城同校
    if ([model.peopleModel.same_city isEqualToString:@"1"]){
        if (!self.sameCityLabel) {
            self.sameCityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,25,15)];
            self.sameCityLabel.font = NINEFONT_TIME;
            self.sameCityLabel.textAlignment = NSTextAlignmentCenter;
            self.sameCityLabel.textColor = [UIColor whiteColor];
            self.sameCityLabel.backgroundColor = UIColorFromRGB(0xfec337);
            self.sameCityLabel.layer.cornerRadius = 2.0;
            self.sameCityLabel.layer.masksToBounds = YES;
            self.sameCityLabel.text = @"同城";
            [self.contentView addSubview:self.sameCityLabel
             ];
        }
        self.sameCityLabel.hidden = NO;
        nameWidth -= 30;
    }else{
        if (self.sameCityLabel) {
            self.sameCityLabel.hidden = YES;
        }
    }
    
    if ([model.peopleModel.same_school isEqualToString:@"1"]){
        if (!self.sameSchoolLabel) {
            self.sameSchoolLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,25,15)];
            self.sameSchoolLabel.font = NINEFONT_TIME;
            self.sameSchoolLabel.textAlignment = NSTextAlignmentCenter;
            self.sameSchoolLabel.textColor = [UIColor whiteColor];
            self.sameSchoolLabel.backgroundColor = UIColorFromRGB(0xff9058);
            self.sameSchoolLabel.layer.cornerRadius = 2.0;
            self.sameSchoolLabel.layer.masksToBounds = YES;
            self.sameSchoolLabel.text = @"同校";
            [self.contentView addSubview:self.sameSchoolLabel
             ];
        }
        self.sameSchoolLabel.hidden = NO;
        nameWidth -= 30;
    }else{
        if (self.sameSchoolLabel) {
            self.sameSchoolLabel.hidden = YES;
        }
    }
    
    //用户名相关标签位置计算
    if(![model.peopleModel.person_iname isKindOfClass:[NSString class]]){
        model.peopleModel.person_iname = @"";
    }
    if (_peopleModel.nameAttString) {
        [self.nameLb_ setAttributedText:_peopleModel.nameAttString];
    }else{
        [self.nameLb_ setText:model.peopleModel.person_iname];
    }
    [self.nameLb_ sizeToFit];
    CGRect nameF = self.nameLb_.frame;
    nameF.origin.x = nameX;
    nameF.size.width = nameF.size.width > nameWidth ? nameWidth:nameF.size.width;
    self.nameLb_.frame = nameF;
    self.nameLb_.center = CGPointMake(self.nameLb_.center.x,_markImgv_.center.y);
    
    CGFloat startX = CGRectGetMaxX(nameF)+5;
    
    if ([model.peopleModel.is_shiming isEqualToString:@"1"]){
        self.realNameLabel.frame = CGRectMake(startX,15,36,15);
        startX = CGRectGetMaxX(self.realNameLabel.frame)+5;
    }
    
    _ageView.frame = CGRectMake(startX,15,CGRectGetMaxX(self.ageLb.frame)+4,15);
    startX = CGRectGetMaxX(_ageView.frame)+5;
    if ([model.peopleModel.same_city isEqualToString:@"1"]){
        self.sameCityLabel.frame = CGRectMake(startX,15,24,15);
        startX = CGRectGetMaxX(self.sameCityLabel.frame)+5;
        if ([model.peopleModel.same_school isEqualToString:@"1"]){
            self.sameSchoolLabel.frame = CGRectMake(startX,15,24,15);
        }
    }else{
        if ([model.peopleModel.same_school isEqualToString:@"1"]){
            self.sameSchoolLabel.frame = CGRectMake(startX,15,24,15);
        }
    }
           
    [self.workAgeLb_ setAttributedText:model.workAgeAttString]; 
    self.workAgeLb_.lineBreakMode = NSLineBreakByTruncatingTail;
    //动态
    if (_hideDynamic) {
        self.dynamicLb_.hidden  = YES;
        self.rightButtonView.frame = CGRectMake(ScreenWidth-55,15,44,44);    
        self.phototImgv_.frame = CGRectMake(10,14,46,46);
        self.lineView.frame = CGRectMake(10,73,ScreenWidth-10,1);
    }else{
        self.dynamicLb_.hidden  = NO;
        [self.dynamicLb_ setText:model.peopleModel.desc];
        self.dynamicLb_.lineBreakMode = NSLineBreakByTruncatingTail;
        self.dynamicLb_.userInteractionEnabled = model.dynamicBtnEnable;
        self.rightButtonView.frame = CGRectMake(ScreenWidth-55,25,44,44);
        self.phototImgv_.frame = CGRectMake(10,15,63,63);
        self.lineView.frame = CGRectMake(10,92,ScreenWidth-10,1);
    }
}

-(void)rightBtnRespone:(UITapGestureRecognizer *)sender
{
    if (![Manager shareMgr].haveLogin) {
        [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
        return;
    }
    if ([_rightLabel.text isEqualToString:@"关注"]) {
        [self addExpertAttention];
    }else if([_rightLabel.text isEqualToString:@"已关注"]) {
        [self cancelExpertAttention];
    }else if([_rightLabel.text isEqualToString:@"私信"]) {
        [self leaveMessage:nil];
    }
}

-(void)addExpertAttention{
    NSString * bodyMsg = [NSString stringWithFormat:@"uid=%@&follow_uid=%@",[Manager getUserInfo].userId_,_peopleModel.peopleModel.personId];
    [ELRequest postbodyMsg:bodyMsg op:@"zd_person_follow_rel" func:@"addPersonFollow" requestVersion:NO progressFlag:YES progressMsg:@"" success:^(NSURLSessionDataTask *operation, id result)
     {
         NSDictionary *dic = result;
         Status_DataModal * dataModal = [[Status_DataModal alloc] init];
         dataModal.code_ = [dic objectForKey:@"code"];
         dataModal.status_ = [dic objectForKey:@"status"];
         dataModal.des_ = [dic objectForKey:@"status_desc"];
         if ([dataModal.status_ isEqualToString:@"OK"]) {
             _peopleModel.peopleModel.rel = @"1";
             self.rightImage.image = [UIImage imageNamed:@"attention_cancel_image"];
             self.rightLabel.text = @"已关注";
             self.rightLabel.textColor = UIColorFromRGB(0x9e9e9e);
             [BaseUIViewController showAutoDismissSucessView:@"关注成功" msg:nil];
             [[Manager shareMgr] showSayViewWihtType:4];
         }else{
            [BaseUIViewController showAutoDismissFailView:@"" msg:dataModal.des_];
         }
     } failure:^(NSURLSessionDataTask *operation, NSError *error) {
         
     }];
}

-(void)cancelExpertAttention{
    NSString * bodyMsg = [NSString stringWithFormat:@"uid=%@&follow_uid=%@",[Manager getUserInfo].userId_,_peopleModel.peopleModel.personId];
    [ELRequest postbodyMsg:bodyMsg op:@"zd_person_follow_rel" func:@"delPersonFollow" requestVersion:NO progressFlag:YES progressMsg:@"" success:^(NSURLSessionDataTask *operation, id result)
     {
         NSDictionary *dic = result;
         Status_DataModal * dataModal = [[Status_DataModal alloc] init];
         dataModal.code_ = [dic objectForKey:@"code"];
         dataModal.status_ = [dic objectForKey:@"status"];
         dataModal.des_ = [dic objectForKey:@"status_desc"];
         if ([dataModal.status_ isEqualToString:@"OK"]) {
             _peopleModel.peopleModel.rel = @"";
             self.rightImage.image = [UIImage imageNamed:@"attention_success_image"];
             self.rightLabel.text = @"关注";
             self.rightLabel.textColor = UIColorFromRGB(0x616161);
             [BaseUIViewController showAutoDismissSucessView:@"取消关注成功" msg:nil];
         }else{
             [BaseUIViewController showAutoDismissFailView:@"" msg:dataModal.des_];
         }
     } failure:^(NSURLSessionDataTask *operation, NSError *error) {
         
     }];
}

-(void)dynamicBtnClick:(id)sender
{
    if ([_peopleModel.peopleModel.type isEqualToString:@"article"]) {
        ArticleDetailCtl * articleDetailCtl = [[ArticleDetailCtl alloc] init];
        [[self viewController].navigationController pushViewController:articleDetailCtl animated:YES];
        [articleDetailCtl beginLoad:_peopleModel.peopleModel.info[@"article_id"] exParam:nil];
    }else if ([_peopleModel.peopleModel.type isEqualToString:@"group"]) {
        ELGroupDetailCtl *detailCtl_ = [[ELGroupDetailCtl alloc] init];
        detailCtl_.isMine = YES;
//        detailCtl_.pushFromMe_ = YES;
        [[self viewController].navigationController pushViewController:detailCtl_ animated:YES];
        [detailCtl_ beginLoad:_peopleModel.peopleModel.info[@"group_id"] exParam:nil];
    }else if ([_peopleModel.peopleModel.type isEqualToString:@"follow"]) {
        ELPersonCenterCtl *personCenterCtl = [[ELPersonCenterCtl alloc] init];
        personCenterCtl.delegate = self;
        [[self viewController].navigationController pushViewController:personCenterCtl animated:NO];
        [personCenterCtl beginLoad:_peopleModel.peopleModel.info[@"person_id"] exParam:nil];
    }   
}

- (UIViewController *)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

#pragma mark - 个人中心加关注回调
- (void)addLikeSuccess{
    _peopleModel.peopleModel.rel = @"1";
    //[self.addConttenBtn_ setSelected:YES];
}

#pragma mark - 个人中心取消关注回调
- (void)leslikeSuccess{
    _peopleModel.peopleModel.rel = @"";
   //[self.addConttenBtn_ setSelected:NO];
}
//关注
- (void)addConttenClick:(UIButton *)button
{
    if (![Manager shareMgr].haveLogin) {
        [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
        return;
    }
    if (![_peopleModel.peopleModel.rel boolValue]) {//关注
        [self addExpertAttention];
    }else{
        [self cancelExpertAttention];
    }
}

-(void)loginDelegateCtl
{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}

- (void)userTapClick:(UITapGestureRecognizer *)sender
{
    ELPersonCenterCtl *personCenterCtl = [[ELPersonCenterCtl alloc] init];
    personCenterCtl.delegate = self;
    [[self viewController].navigationController pushViewController:personCenterCtl animated:NO];
    [personCenterCtl beginLoad:_peopleModel.peopleModel.personId exParam:nil];
    return;
}

#pragma mark 留言
-(void)leaveMessage:(UIButton *)sender
{
    if (![Manager shareMgr].haveLogin) {
        [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
        return;
    }
    MessageContact_DataModel *messagemodel = [[MessageContact_DataModel alloc]init];
    messagemodel.userId = _peopleModel.peopleModel.personId;
    messagemodel.userIname = _peopleModel.peopleModel.person_iname;
    messagemodel.sex = _peopleModel.peopleModel.person_sex;
    if (_peopleModel.peopleModel.age.length > 0) {
        messagemodel.age = _peopleModel.peopleModel.age;
    }else{
        messagemodel.age = _peopleModel.peopleModel.person_age;
    }
    messagemodel.gzNum = _peopleModel.peopleModel.person_gznum;
    messagemodel.userZW = _peopleModel.peopleModel.person_zw;
    messagemodel.pic = _peopleModel.peopleModel.person_pic;
    
    MessageDailogListCtl *ctl = [[MessageDailogListCtl alloc]init];
    [ctl beginLoad:messagemodel exParam:nil];
    [[self viewController].navigationController pushViewController:ctl animated:YES];
    
}

@end
