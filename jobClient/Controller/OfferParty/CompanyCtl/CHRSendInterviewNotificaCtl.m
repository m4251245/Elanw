//
//  CHRSendInterviewNotificaCtl.m
//  jobClient
//
//  Created by YL1001 on 16/1/14.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "CHRSendInterviewNotificaCtl.h"
#import "OfferPartyResumeEnumeration.h"

@interface CHRSendInterviewNotificaCtl ()
{
    NSTimer *_currentTimer;
    NSInteger _timeCount;
}
@end

@implementation CHRSendInterviewNotificaCtl

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _shadeView.layer.cornerRadius = 8.0f;
    _shadeView.layer.masksToBounds = YES;
    
    _sendBtn.layer.cornerRadius = 4.0f;
    _sendBtn.tag = 100;
    _sendBtn.layer.masksToBounds = YES;
    
    _noSendBtn.layer.cornerRadius = 4.0f;
    _noSendBtn.tag = 101;
    _noSendBtn.layer.masksToBounds = YES;
    
    _cancelBtn.layer.cornerRadius = 4.0f;
    _cancelBtn.tag = 102;
    _cancelBtn.layer.masksToBounds = YES;
    
    _sureBtn.layer.cornerRadius = 4.0f;
    _sureBtn.tag = 103;
    _sureBtn.layer.masksToBounds = YES;
    
    _isCancelInterview = YES;
    //offerPar人才回应面试通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNewMessage:) name:@"offerPartyTalentState" object:nil];
    self.view.frame = CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height);
}

- (IBAction)btnResponse:(UIButton *)sender {
    
    switch (sender.tag) {
        case 100:
        {//发送面试通知
            if (_userModel.resumeType == OPResumeTypeNoConfirFit) {
                [self isThroughThePrimary];
            }
            
            NSString *content =[NSString stringWithFormat:@"【offer派】%@公司的等候队伍已轮到您了，请马上前往该公司展位进行面谈。", [Manager getUserInfo].companyModal_.cname_];
            [self sendInterviewNotification:content];
        }
            break;
        case 102:
        {//取消面试通知
            [self hideView];
            [self cancelInterviewNotification];
            if (_currentTimer)
            {
                [_currentTimer invalidate];
            }
        }
            break;
        default:
        {
            [self hideView];
        }
            break;
    }

}

/**
 * 弹框信息处理
 * @param  talentName   人才名字
 * @param  status       人才状态： 离场 正在面试 接受邀请 不接受邀请
 * @param  tipStr
 */
- (void)setTalentName:(NSString *)talentName Status:(NSString *)status TipStr:(NSString *)tipStr
{
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",talentName,status]];
    NSRange range1=[[hintString string] rangeOfString:talentName];
    [hintString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xE4403A) range:range1];
    
    _talentsStatusLb.attributedText = hintString;
    _tipsLb.text = tipStr;
    
}

- (void)showViewCtl
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.view];
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:self.view];
    self.view.frame = CGRectMake(0, 600, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height +20);
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, -20, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height +20);
    }];
}

- (void)hideView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, 600, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height +20);
    }completion:^(BOOL finished){
        [self.view removeFromSuperview];
    }];
}

- (void)setUserModel:(User_DataModal *)userModel
{
    _userModel = userModel;
    
    //查询人才面试状态
    NSString *bodyMsg = [NSString stringWithFormat:@"company_id=%@&jobfair_id=%@&person_id=%@&conditArr=",[Manager getUserInfo].companyModal_.companyID_, _jobfairId, userModel.userId_];
    
    [ELRequest postbodyMsg:bodyMsg op:@"zhaop_person_tuijian" func:@"getMianshiStatus" requestVersion:NO success:^(NSURLSessionDataTask *operation, id result) {
        
        Status_DataModal *model = [[User_DataModal alloc] init];
        model.status_ = result[@"status"];
        model.code_ = result[@"code"];
        model.des_ = result[@"status_desc"];
        
        [self showViewCtl];
        self.sendBtn.hidden = NO;
        self.noSendBtn.hidden = NO;
        self.cancelBtn.hidden = YES;
        self.sureBtn.hidden = YES;
        
        if ([model.code_ isEqualToString:@"200"]) {
            
            [self setTalentName:userModel.uname_ Status:@"" TipStr:@"是否通知其面试"];
            [self.sendBtn setTitle:@"通知面试" forState:UIControlStateNormal];
        }
        else
        {
            [self setTalentName:userModel.uname_ Status:@"正在面试中" TipStr:@"是否继续发送通知"];
            [self.sendBtn setTitle:@"继续通知" forState:UIControlStateNormal];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

#pragma mark - 数据请求
/**
 $filetype = "company";
 $state      2 不通过初选  1 通过初选  3 待确定
 updateTjState($tuijianarr,$filetype,$state,$conditionArr);
 **/
#pragma mark 是否通过初选
- (void)isThroughThePrimary
{
    
    //记录是谁操作
    //30顾问 20企业 10人才 40其他
    NSString *roleState;
    //企业编号，人才编号，或招聘顾问编号
    NSString *roleId;
    
    //企业后台请求或者顾问企业列表
    roleState = @"20";
    roleId = _companyId;
    
//    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
//    [conditionDic setValue:roleState forKey:@"role"];
//    [conditionDic setValue:roleId forKey:@"role_id"];
//    
//    SBJsonWriter *jsonWrite = [[SBJsonWriter alloc] init];
//    NSString *conditionStr = [jsonWrite stringWithObject:conditionDic];
//    
//    NSString * bodyMsg = [NSString stringWithFormat:@"tuijian_id={\"id\":[\"%@\"]}&filetype=%@&state=%@&conditionArr=%@", _userModel.recommendId, @"company", @"1", conditionStr];
//    NSString * function = @"updateTjState";
//    NSString * op = @"offerpai_busi";
    
    NSMutableDictionary *tjresumeDic = [[NSMutableDictionary alloc] init];
    [tjresumeDic setObject:_userModel.role_id forKey:@"reid"];
    [tjresumeDic setObject:_userModel.recommendId forKey:@"id"];
    [tjresumeDic setObject:_companyId forKey:@"company_id"];
    [tjresumeDic setObject:@"company" forKey:@"type"];
    [tjresumeDic setObject:@"1" forKey:@"state"];
    
    
    NSMutableDictionary *commentDic = [[NSMutableDictionary alloc] init];
    [commentDic setObject:_userModel.zpId_ forKey:@"jobid"];
    [commentDic setObject:@"" forKey:@"commentContent"];
    [commentDic setObject:@"通知面试" forKey:@"comment_type"];
    [commentDic setObject:_userModel.userId_ forKey:@"person_id"];
    NSString *synergy_id = [CommonConfig getDBValueByKey:@"synergy_id"];
    if (synergy_id && synergy_id.length > 1) {
        [commentDic setObject:synergy_id forKey:@"synergy_m_id"];
    }
    [commentDic setObject:@"40" forKey:@"company_resume_comment_label_id"];
    [commentDic setObject:@"5" forKey:@"person_type"];
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:@"20" forKey:@"role"];
    [conditionDic setObject:_companyId forKey:@"role_id"];
    
    SBJsonWriter *jsonWrite = [[SBJsonWriter alloc] init];
    NSString *tjresumeStr = [jsonWrite stringWithObject:tjresumeDic];
    NSString *commentStr = [jsonWrite stringWithObject:commentDic];
    NSString *conditionStr = [jsonWrite stringWithObject:conditionDic];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"tjresumeArr=%@&commentArr=%@&conditionArr=%@", tjresumeStr, commentStr, conditionStr];
    
    NSString * function = @"updateTjStateNew";
    NSString * op = @"offerpai_busi";
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

//发送面试通知
- (void)sendInterviewNotification:(NSString *)content
{
    NSString *locationString=[[NSDate date] stringWithFormat:@"YYYYMMddHHmm"];
    NSRange range = NSMakeRange(0, 4);
    NSString *year = [locationString substringWithRange:range];
    range = NSMakeRange(4, 2);
    NSString *month = [locationString substringWithRange:range];
    range = NSMakeRange(6, 2);
    NSString *day = [locationString substringWithRange:range];
    range = NSMakeRange(8, 2);
    NSString *hour = [locationString substringWithRange:range];
    range = NSMakeRange(10, 2);
    NSString *min = [locationString substringWithRange:range];
    
    NSString *phone = _userModel.mobile_;
    if (!phone) {
        phone = @"";
    }
    NSString *offerId = _jobfairId;
    
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
//    [conditionDic setObject:content forKey:@"mailtext"];
    [conditionDic setObject:year forKey:@"year"];
    [conditionDic setObject:month forKey:@"month"];
    [conditionDic setObject:day forKey:@"day"];
    [conditionDic setObject:hour forKey:@"hours"];
    [conditionDic setObject:min forKey:@"min"];
    [conditionDic setObject:@"" forKey:@"address"];
    [conditionDic setObject:_userModel.uname_ forKey:@"pname"];
    [conditionDic setObject:phone forKey:@"phone"];
    [conditionDic setObject:@"tmpl1" forKey:@"sdesc"];
    [conditionDic setObject:@"1" forKey:@"isMobile"];
    
    [conditionDic setObject:@"1" forKey:@"offer"];
    [conditionDic setObject:offerId forKey:@"offer_id"];
    [conditionDic setObject:_userModel.recommendId forKey:@"tuijian_id"];
    [conditionDic setObject:[Manager getUserInfo].userId_ forKey:@"person_id"];
    
    NSMutableDictionary *mobileDic = [[NSMutableDictionary alloc] init];
    //msgType  100通知面试  200面试准备
    [mobileDic setObject:@"100" forKey:@"msgtype"];
    
    NSString *synergy_id = [CommonConfig getDBValueByKey:@"synergy_id"];
    if (synergy_id && synergy_id.length > 1) {
        [conditionDic setObject:synergy_id forKey:@"synergy_m_id"];
    }

    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];
    NSString *mobileStr = [jsonWriter stringWithObject:mobileDic];
    
    NSString *bodyMsg = [NSString stringWithFormat:@"apptype=%@&appid=%@&interview_type=%@&tradeid=%@&company_id=%@&person_id=%@&zp_id=%@&conditionArr=%@&mobileArr=%@", @"cmailbox", _userModel.resumeId, @"sms,email", [Manager getUserInfo].companyModal_.tradeId_, _companyId, _userModel.userId_, @"1000", conditionStr, mobileStr];
    
    [ELRequest postbodyMsg:bodyMsg op:@"company" func: @"doInterviewNotify" requestVersion:NO success:^(NSURLSessionDataTask *operation, id result) {
        
        NSDictionary *dic = result;
        Status_DataModal * dataModal = [[Status_DataModal alloc] init];
        dataModal.status_ = [dic objectForKey:@"status"];
        dataModal.des_ = [dic objectForKey:@"status_desc"];
        dataModal.code_ = [dic objectForKey:@"code"];
        
        if ([dataModal.status_ isEqualToString:Success_Status]) {
            self.isCancelInterview = YES;
            _sendBtn.hidden = YES;
            _noSendBtn.hidden = YES;
            _cancelBtn.hidden = NO;
            _sureBtn.hidden = YES;
            [self setTalentName:_userModel.uname_ Status:@"" TipStr:@"正在等待对方接受邀请..."];
            
            _timeCount = 30;
            [_currentTimer invalidate];
            _currentTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countDownTime:) userInfo:nil repeats:YES];
        }
        else
        {
            [BaseUIViewController showAutoDismissFailView:@"发送失败" msg:@"请稍后再试"];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        
    }];
}

- (void)cancelInterviewNotification
{
//    NSString * bodyMsg = [NSString stringWithFormat:@"tuijian_id={ \"id\":[%@]}&filetype=%@&state=%@", _userModel.recommendId, @"mianshi", @"30"];
//    NSString * function = @"updateTjState";
//    NSString * op = @"offerpai_busi";
    
    NSMutableDictionary *tjresumeDic = [[NSMutableDictionary alloc] init];
    [tjresumeDic setObject:_userModel.role_id forKey:@"reid"];
    [tjresumeDic setObject:_userModel.recommendId forKey:@"id"];
    [tjresumeDic setObject:_companyId forKey:@"company_id"];
    [tjresumeDic setObject:@"mianshi" forKey:@"type"];
    [tjresumeDic setObject:@"30" forKey:@"state"];
    
    
    NSMutableDictionary *commentDic = [[NSMutableDictionary alloc] init];
    [commentDic setObject:_userModel.zpId_ forKey:@"jobid"];
    [commentDic setObject:@"" forKey:@"commentContent"];
    [commentDic setObject:@"取消面试通知" forKey:@"comment_type"];
    [commentDic setObject:_userModel.userId_ forKey:@"person_id"];
    NSString *synergy_id = [CommonConfig getDBValueByKey:@"synergy_id"];
    if (synergy_id && synergy_id.length > 1) {
        [commentDic setObject:synergy_id forKey:@"synergy_m_id"];
    }
    [commentDic setObject:@"40" forKey:@"company_resume_comment_label_id"];
    [commentDic setObject:@"5" forKey:@"person_type"];
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:@"20" forKey:@"role"];
    [conditionDic setObject:_companyId forKey:@"role_id"];
    
    SBJsonWriter *jsonWrite = [[SBJsonWriter alloc] init];
    NSString *tjresumeStr = [jsonWrite stringWithObject:tjresumeDic];
    NSString *commentStr = [jsonWrite stringWithObject:commentDic];
    NSString *conditionStr = [jsonWrite stringWithObject:conditionDic];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"tjresumeArr=%@&commentArr=%@&conditionArr=%@", tjresumeStr, commentStr, conditionStr];
    
    NSString * function = @"updateTjStateNew";
    NSString * op = @"offerpai_busi";

    
    [BaseUIViewController showLoadView:YES content:@"正在处理" view:self.view];
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        NSInteger str = [result integerValue];
        [BaseUIViewController showLoadView:NO content:nil view:nil];
        if (str == 1) {
            [BaseUIViewController showAutoDismissSucessView:nil msg:@"已取消通知"];
        }
        else
        {
            [BaseUIViewController showAutoDismissSucessView:nil msg:@"操作失败"];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [BaseUIViewController showLoadView:NO content:nil view:nil];
    }];
}

#pragma mark 倒计时
- (void)countDownTime:(NSTimer *)timer
{
    _timeCount -= 1;
    if (_timeCount <= 0) {
        [_currentTimer invalidate];
        if (self.isCancelInterview == YES) {
            [self hideView];
            [self cancelInterviewNotification];
        }
    }
}

-(void)dealloc
{
    if (_currentTimer)
    {
        [_currentTimer invalidate];
    }
}

//人才回应后刷新数据
- (void)receiveNewMessage:(NSNotification *)nitification;
{
    _isCancelInterview = NO;
    
    NSDictionary *dic = [nitification object];
    _sendBtn.hidden = YES;
    _noSendBtn.hidden = YES;
    _cancelBtn.hidden = YES;
    _sureBtn.hidden = NO;
    
    NSString *name = [[[dic objectForKey:@"content"] componentsSeparatedByString:@"，"] firstObject];
    NSString *offerState = [dic objectForKey:@"state"];
    if ([offerState isEqualToString:@"20"]) {//参加面试
        [self setTalentName:name Status:@"已接受邀请" TipStr:@"即将前来面试，请稍等"];
    }
    else if([offerState isEqualToString:@"40"])
    {//拒绝面试
        [self setTalentName:name Status:@"暂不接受邀请" TipStr:@"请稍后再通知"];
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
