//
//  ELRealNameAuthenticationPrivilegeCtl.m
//  jobClient
//
//  Created by YL1001 on 15/12/22.
//  Copyright © 2015年 YL1001. All rights reserved.
//

#import "ELRealNameAuthenticationPrivilegeCtl.h"
#import "ELRealNameAuthenticationCtl.h"

@interface ELRealNameAuthenticationPrivilegeCtl ()
{
    IBOutlet UIScrollView *_scrollView;
    
    IBOutlet UIView *_noAuthenticationView;
    IBOutlet UIImageView *_titleImg;
    
    IBOutlet UIView *_authenStatuView;
    IBOutlet UIImageView *_authenImg;
    IBOutlet UIImageView *_statusImg;
    IBOutlet UILabel *_authenStatuLb;
    IBOutlet UILabel *_authenResultLb;
    
    IBOutlet UIView *_privilegeBgView;
    IBOutlet UIView *_privilegeView1;
    IBOutlet UIImageView *_privilegeImg1;
    
    IBOutlet UIView *_privilegeView2;
    IBOutlet UIImageView *_privilegeImg2;
    
    IBOutlet UIView *_privilegeView3;
    IBOutlet UIImageView *_privilegeImg3;
    
    IBOutlet UIView *_privilegeView4;
    IBOutlet UIImageView *_privilegeImg4;
    
    IBOutlet UIButton *_applyBtn;
    
}

@end

@implementation ELRealNameAuthenticationPrivilegeCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"实名认证"];
    
    _titleImg.layer.cornerRadius = 35.0;
    _titleImg.layer.masksToBounds = YES;
    
    _authenImg.layer.cornerRadius = 35.0;
    _authenImg.layer.masksToBounds = YES;
    
    _privilegeView1.layer.cornerRadius = 25.0;
    _privilegeView1.layer.masksToBounds = YES;
    _privilegeImg1.layer.cornerRadius = 17.5;
    _privilegeImg1.layer.masksToBounds = YES;
    
    _privilegeView2.layer.cornerRadius = 25.0;
    _privilegeView2.layer.masksToBounds = YES;
    _privilegeImg2.layer.cornerRadius = 17.5;
    _privilegeImg2.layer.masksToBounds = YES;
    
    _privilegeView3.layer.cornerRadius = 25.0;
    _privilegeView3.layer.masksToBounds = YES;
    _privilegeImg3.layer.cornerRadius = 17.5;
    _privilegeImg3.layer.masksToBounds = YES;
    
    _privilegeView4.layer.cornerRadius = 25.0;
    _privilegeView4.layer.masksToBounds = YES;
    _privilegeImg4.layer.cornerRadius = 17.5;
    _privilegeImg4.layer.masksToBounds = YES;
    
    _applyBtn.layer.cornerRadius = 8.0;
    _applyBtn.layer.masksToBounds = YES;
    
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(_privilegeBgView.frame));
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [self getRealNameStatus];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)btnResponse:(id)sender
{
    if (sender == _applyBtn) {
        ELRealNameAuthenticationCtl *ctl = [[ELRealNameAuthenticationCtl alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

- (void)getRealNameStatus
{
    NSString *userId = [Manager getUserInfo].userId_;
    
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@",userId];
    
    [ELRequest postbodyMsg:bodyMsg op:@"person_info_busi" func:@"get_shiming_info" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
     {
         NSDictionary *dic = result;
         NSString *code = dic[@"code"];
         
         _applyBtn.hidden = YES;
         
         if ([code isEqualToString:@"300"])
         {//未申请
             _applyBtn.hidden = NO;
             _noAuthenticationView.hidden = NO;
             _authenStatuView.hidden = YES;
             
             [_applyBtn setTitle:@"马上认证，马上提现" forState:UIControlStateNormal];
         }
         else if([code isEqualToString:@"200"])
         {//认证通过
             _noAuthenticationView.hidden = YES;
             _authenStatuView.hidden = NO;
             
             _authenStatuLb.text = @"已认证成功";
             _authenResultLb.text = @"有身份的人不需要解释";
             [_authenResultLb sizeToFit];
             _statusImg.image = [UIImage imageNamed:@"realName_audit.png"];
         }
         else if([code isEqualToString:@"500"])
         {//认证失败
             _applyBtn.hidden = NO;
             _noAuthenticationView.hidden = YES;
             _authenStatuView.hidden = NO;
             
             _authenStatuLb.text = @"认证申请未通过";
             NSString *reason = dic[@"reason"];
             _authenResultLb.text = [NSString stringWithFormat:@"%@",reason];
             [_authenResultLb sizeToFit];
             _statusImg.image = [UIImage imageNamed:@"realName_noAudit.png"];
             
             CGRect authenViewFrame =  _authenStatuView.frame;
             authenViewFrame.size.height = CGRectGetMaxY(_authenResultLb.frame) + 8;
             _authenStatuView.frame = authenViewFrame;
             
             authenViewFrame = _privilegeBgView.frame;
             authenViewFrame.origin.y = CGRectGetMaxY(_authenStatuView.frame);
             _privilegeBgView.frame = authenViewFrame;
             
             [_applyBtn setTitle:@"重新申请" forState:UIControlStateNormal];
         }
         else if([code isEqualToString:@"600"])
         {//审核中
             _noAuthenticationView.hidden = YES;
             _authenStatuView.hidden = NO;
             
             _authenStatuLb.text = @"您的认证申请快件";
             _authenResultLb.text = @"正在加急审核中...";
             [_authenResultLb sizeToFit];
             _statusImg.image = [UIImage imageNamed:@"realName_noAudit.png"];
         }
         
     } failure:^(NSURLSessionDataTask *operation, NSError *error) {
         
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
