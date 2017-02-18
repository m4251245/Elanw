//
//  OfferPartyInterviewTipsCtl.m
//  jobClient
//
//  Created by 一览ios on 15/7/17.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "OfferPartyInterviewTipsCtl.h"

@interface OfferPartyInterviewTipsCtl ()

@end

@implementation OfferPartyInterviewTipsCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    _maskView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    _shadeView.layer.cornerRadius = 8.0f;
    _shadeView.layer.masksToBounds = YES;
    
    _confirmBtn.layer.cornerRadius = 8.0f;
    _confirmBtn.tag = 100;
    _confirmBtn.layer.masksToBounds = YES;
    
    _refuseBtn.layer.cornerRadius = 8.0f;
    _refuseBtn.tag = 101;
    _refuseBtn.layer.masksToBounds = YES;
    
    _sureBtn.layer.cornerRadius = 8.0f;
    _sureBtn.tag = 102;
    _sureBtn.layer.masksToBounds = YES;
    
    NSMutableAttributedString *hintString = [[NSMutableAttributedString alloc] initWithString:@"请与企业或现场工作人员联系"];
    [hintString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xE4403A) range:NSMakeRange(2, 2)];
    [hintString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xE4403A) range:NSMakeRange(5, 6)];
    _tipLb2.attributedText = hintString;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelInterviewNotific:) name:@"cancelInterviewNotification" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        [self loadView];
        [self viewDidLoad];
    }
    return self;
}

- (IBAction)btnResponse:(UIButton *)sender {
    
    switch (sender.tag) {
        case 100:
        {//参加面试
            [self replyInterviewNotification:@"20"];
        }
            break;
        case 101:
        {//不参加面试
            [self replyInterviewNotification:@"40"];
        }
            break;
        default:
            break;
    }
    [self hideViewCtl];
}

- (void)cancelInterviewNotific:(NSNotification *)notific
{
    OfferPartyTalentsModel *model = [notific object];
    
    if ([model.state isEqualToString:@"30"]) {
        self.tipLb2.hidden = NO;
        self.companyLb.hidden = NO;
        self.sureBtn.hidden = NO;
        self.refuseBtn.hidden = YES;
        self.confirmBtn.hidden = YES;
        
        self.offerPartyGuideImgv.image = [UIImage imageNamed:@"offerPar_interview3.png"];
        self.companyLb.text = model.jobfair_name;
        self.tipsLb1.text = @"企业取消邀请";
    }
}

//企业是否取消面试
- (void)getPersonInterviewState
{
    if ([_offerPartyModel.state isEqualToString:@"30"]) {
        self.tipLb2.hidden = NO;
        self.companyLb.hidden = NO;
        self.refuseBtn.hidden = YES;
        self.confirmBtn.hidden = YES;
        self.sureBtn.hidden = NO;
        
        self.offerPartyGuideImgv.image = [UIImage imageNamed:@"offerPar_interview3.png"];
        self.companyLb.text = _offerPartyModel.jobfair_name;
        self.tipsLb1.text = @"企业取消邀请";
    }
    else
    {//面试通知
        self.tipLb2.hidden = YES;
        self.companyLb.hidden = YES;
        self.refuseBtn.hidden = NO;
        self.confirmBtn.hidden = NO;
        self.sureBtn.hidden = YES;
        
        self.offerPartyGuideImgv.image = [UIImage imageNamed:@"offerPar_interview2.png"];
        self.tipsLb1.text = _offerPartyModel.jobfair_name;
    }
}

/**
 * 人才回应面试通知处理
 * conditionArr['role']    = $role;//30顾问20企业10人才40其他
 * conditionArr['role_id']   = $role_id;//企业编号，人才编号，或招聘顾问编号
 * state   20接受面试    40 拒绝面试
*/
- (void)replyInterviewNotification:(NSString *)state
{
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setValue:_offerPartyModel.hrId forKey:@"person_id"];
    [conditionDic setObject:@"10" forKey:@"role"];
    [conditionDic setObject:[Manager getUserInfo].userId_ forKey:@"role_id"];
    
    SBJsonWriter *jsonWrite = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWrite stringWithObject:conditionDic];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"tuijian_id={ \"id\":[%@]}&filetype=%@&state=%@&conditionArr=%@", _offerPartyModel.recommendId, @"mianshi", state, conditionStr];
   
    NSString * function = @"updateTjState";
    NSString * op = @"offerpai_busi";
    
//    NSMutableDictionary *tjresumeDic = [[NSMutableDictionary alloc] init];
//    [tjresumeDic setObject:_offerPartyModel.companyId forKey:@"reid"];
//    [tjresumeDic setObject:_offerPartyModel.recommendId forKey:@"id"];
//    [tjresumeDic setObject:_offerPartyModel.companyId forKey:@"company_id"];
//    [tjresumeDic setObject:@"mianshi" forKey:@"type"];
//    [tjresumeDic setObject:state forKey:@"state"];
//    
//    
//    NSMutableDictionary *commentDic = [[NSMutableDictionary alloc] init];
//    [commentDic setObject:@"" forKey:@"jobid"];
//    [commentDic setObject:@"" forKey:@"commentContent"];
//   
//    NSString *comment_type;
//    if ([state isEqualToString:@"20"]) {
//        comment_type = @"接受面试";
//    }else{
//        comment_type = @"拒绝面试";
//    }
//    [commentDic setObject:comment_type  forKey:@"comment_type"];
//    [commentDic setObject:_offerPartyModel.personId forKey:@"person_id"];
//    NSString *synergy_id = [CommonConfig getDBValueByKey:@"synergy_id"];
//    if (synergy_id && synergy_id.length > 1) {
//        [commentDic setObject:synergy_id forKey:@"synergy_m_id"];
//    }
//    [commentDic setObject:@"40" forKey:@"company_resume_comment_label_id"];
//    [commentDic setObject:@"5" forKey:@"person_type"];
//    
//    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
//    [conditionDic setObject:@"10" forKey:@"role"];
//    [conditionDic setObject:[Manager getUserInfo].userId_ forKey:@"role_id"];
//    
//    SBJsonWriter *jsonWrite = [[SBJsonWriter alloc] init];
//    NSString *tjresumeStr = [jsonWrite stringWithObject:tjresumeDic];
//    NSString *commentStr = [jsonWrite stringWithObject:commentDic];
//    NSString *conditionStr = [jsonWrite stringWithObject:conditionDic];
//    
//    NSString * bodyMsg = [NSString stringWithFormat:@"tjresumeArr=%@&commentArr=%@&conditionArr=%@", tjresumeStr, commentStr, conditionStr];
//    
//    NSString * function = @"updateTjStateNew";
//    NSString * op = @"offerpai_busi";

    [BaseUIViewController showLoadView:YES content:@"正在处理" view:self.view];
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        [BaseUIViewController showLoadView:NO content:nil view:nil];
        NSString *str = [NSString stringWithFormat:@"%@",result];
        if ([str isEqualToString:@"1"]) {
            [BaseUIViewController showAutoDismissSucessView:nil msg:@"操作成功"];
        }
        else
        {
            [BaseUIViewController showAutoDismissSucessView:nil msg:@"操作失败"];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [BaseUIViewController showLoadView:NO content:nil view:nil];
    }];
    
}

-(void)showViewCtl
{
    if (_isShowCtl)
    {
        return;
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self.view];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.view];
    _isShowCtl = YES;
}

-(void)hideViewCtl
{
    _isShowCtl = NO;
    [self.view removeFromSuperview];
}

@end
