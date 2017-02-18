//
//  SendInterviewContentCtl.m
//  jobClient
//
//  Created by YL1001 on 15/7/20.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "SendInterviewContentCtl.h"
#import "User_DataModal.h"
#import "ELNewResumePreviewCtl.h"
#import "CompanyResumePrevierwModel.h"
#import "ELOfferPartyCompanyResumePreviewCtl.h"

@interface SendInterviewContentCtl ()
{
    RequestCon *_sendInterviewCon;
    
    CompanyResumePrevierwModel *_previewModel;
}
@end

@implementation SendInterviewContentCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (_operationType == OperationTypeInterview) {
        [self setNavTitle:@"面试通知"];
    }
    else
    {
        [self setNavTitle:@"发offer"];
    }
    
    _contentTextView.delegate = self;
    _contentTextView.text = _interviewModal.desc_;
    CALayer *layer = _sendBtn.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 3.f;
    
    [self limitTextViewWords:_contentTextView];
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    _previewModel = dataModal;
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_SendInterview:
        {
            Status_DataModal * dataModal = [dataArr objectAtIndex:0];
            if ([dataModal.status_ isEqualToString:Success_Status]) {
                [BaseUIViewController showAutoDismissSucessView:@"发送成功" msg:nil];
                NSInteger count = self.navigationController.childViewControllers.count;
                BaseUIViewController *ctl  =self.navigationController.childViewControllers[count-3];
                [self.navigationController popToViewController:ctl animated:YES];
                 
            }
            else
            {
                [BaseUIViewController showAutoDismissFailView:@"发送失败" msg:@"请稍后再试"];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    [self limitTextViewWords:textView];
    _interviewModal.desc_ = textView.text;
}

//限制textView字数
- (void)limitTextViewWords:(UITextView *)textView
{
    NSInteger res = TEXT_MAXLENGTH - textView.text.length;
    NSString *tipStr;
    if(res >= 0){
        tipStr = [NSString stringWithFormat:@"发送字数最多为200字，还可输入%ld字",(long)res];
    }
    else
    {
        tipStr = @"发送字数最多为200字，还可输入0字";
    }
    
    NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc] initWithString:tipStr];
    [mutableStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xFF6666) range:NSMakeRange(7, 3)];
    [mutableStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xFF6666) range:NSMakeRange(16, tipStr.length - 17)];
    _textNum.attributedText = mutableStr;
    
    
    NSString *lang = [textView.textInputMode primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"]) {//如果输入的时中文
        UITextRange *selectedRange = [textView markedTextRange];
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            if (textView.text.length > 200) {
                textView.text = [textView.text substringToIndex:200];
            }
        }
    }else{
        if (textView.text.length > 200) {
            textView.text = [textView.text substringToIndex:200];
        }
    }
}

- (void)btnResponse:(id)sender
{
    if (sender == _sendBtn)
    {
        if (_operationType == OperationTypeInterview) {
            [self sendInterview];
        }
        else if (_operationType == OperationTypeSendOffer)
        {
            [self sendOffer:@"60" DataModle:_interviewModal CompanyId:_previewModel.reid Forkey:_previewModel.forkey ForType:_previewModel.fortype];
        }
        else if (_operationType == OperationTypeOPSendOffer)
        {
            if (!_companyId && _previewModel) {
                _companyId = _previewModel.reid;
            }
            
            [self sendOffer:@"1" DataModle:_interviewModal CompanyId:_companyId Forkey:_userModel.recommendId ForType:@"3000"];
        }
    
    }
}

//发送面试邀请
- (void)sendInterview
{
    NSString * function = @"doInterviewNotify";
    NSString * op = @"company";
    
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:_interviewModal.desc_ forKey:@"mailtext"];
    [conditionDic setObject:_interviewModal.year forKey:@"year"];
    [conditionDic setObject:_interviewModal.month forKey:@"month"];
    [conditionDic setObject:_interviewModal.day forKey:@"day"];
    [conditionDic setObject:_interviewModal.hour forKey:@"hours"];
    [conditionDic setObject:_interviewModal.min forKey:@"min"];
    [conditionDic setObject:_interviewModal.address_ forKey:@"address"];
    [conditionDic setObject:_interviewModal.pname_ forKey:@"pname"];
    [conditionDic setObject:_interviewModal.phone_ forKey:@"phone"];
    [conditionDic setObject:_interviewModal.temlname_ forKey:@"sdesc"];
    [conditionDic setObject:@"1" forKey:@"isMobile"];
    NSString *synergy_id = [CommonConfig getDBValueByKey:@"synergy_id"];
    if (synergy_id && synergy_id.length > 1) {
        [conditionDic setObject:synergy_id forKey:@"synergy_m_id"];
    }
    
    NSMutableDictionary *updateDic = [[NSMutableDictionary alloc] init];
    if (_userModel.forKey.length > 0) {
        [updateDic setObject:_userModel.forKey forKey:@"forkey"];
        [updateDic setObject:_userModel.forType forKey:@"fortype"];
        [updateDic setObject:_userModel.companyId forKey:@"company_id"];
        [updateDic setObject:@"20" forKey:@"state"];
    }
    
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];
    NSString * updateStr = [jsonWriter stringWithObject:updateDic];

    NSString *bodyMsg = [NSString stringWithFormat:@"apptype=%@&appid=%@&interview_type=%@&tradeid=%@&company_id=%@&person_id=%@&zp_id=%@&conditionArr=%@&mobileArr=&updateCompanyPersonArr=%@", @"cmailbox", _interviewModal.resumeId, _interviewModal.type, [Manager getUserInfo].companyModal_.tradeId_, [Manager getUserInfo].companyModal_.companyID_, _interviewModal.userId, _interviewModal.zpId, conditionStr, updateStr];
    
    [BaseUIViewController showLoadView:YES content:@"发送中" view:self.view];
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:NO success:^(NSURLSessionDataTask *operation, id result) {
        NSDictionary *dic = result;
        Status_DataModal * dataModal = [[Status_DataModal alloc] init];
        dataModal.status_ = [dic objectForKey:@"status"];
        dataModal.des_ = [dic objectForKey:@"status_desc"];
        dataModal.code_ = [dic objectForKey:@"code"];
        
        if ([dataModal.code_ isEqualToString:@"200"]) {
            
            [BaseUIViewController showAutoDismissSucessView:nil msg:@"发送成功"];
            NSInteger count = self.navigationController.childViewControllers.count;
            BaseUIViewController *ctl  =self.navigationController.childViewControllers[count-3];
            if ([ctl isKindOfClass:[ELNewResumePreviewCtl class]]) {
                ELNewResumePreviewCtl *previewCtl = (ELNewResumePreviewCtl *)ctl;
                [previewCtl refreshLoad:nil];
            }
            [self.navigationController popToViewController:ctl animated:YES];
        }
        else{
            [BaseUIViewController showAutoDismissSucessView:nil msg:@"发送失败"];
        }
        
        [BaseUIViewController showLoadView:NO content:nil view:self.view];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
    
}

//发offer
/**
 fortype offer派3000
 forker  offer派中指tuijian_id
 */
- (void)sendOffer:(NSString *)state DataModle:(InterviewModel_DataModal *)dataModel CompanyId:(NSString *)companyId Forkey:(NSString *)forkey ForType:(NSString *)fortype
{
    NSString *dateStr = [NSString stringWithFormat:@"%@年%@月%@日 %@时%@分", dataModel.year, dataModel.month, dataModel.day, dataModel.hour, dataModel.min];
    NSString *datetimeStr = [NSString stringWithFormat:@"%@-%@-%@ %@:%@", dataModel.year, dataModel.month, dataModel.day, dataModel.hour, dataModel.min];;
    
    NSString *op = @"company_person_busi";
    NSString *func = @"setCompanyPersonResumeState";
    
    NSMutableDictionary *paramArrDic = [[NSMutableDictionary alloc] init];
    [paramArrDic setObject:companyId forKey:@"company_id"];
    
    if (_operationType == OperationTypeOPSendOffer) {
        [paramArrDic setObject:@"offer" forKey:@"filetype"];
        [paramArrDic setObject:@"60" forKey:@"process_state"];
    }
    
    NSMutableDictionary *conditionArrDic = [[NSMutableDictionary alloc] init];
    [conditionArrDic setObject:companyId forKey:@"company_id"];
    NSString *synergy_id = [CommonConfig getDBValueByKey:@"synergy_id"];
    if (synergy_id && synergy_id.length > 1) {
        [conditionArrDic setObject:synergy_id forKey:@"synergy_m_id"];
    }
    
    NSMutableDictionary *emailSmsArrDic = [[NSMutableDictionary alloc] init];
    [emailSmsArrDic setObject:@"" forKey:@"totalid"];
    [emailSmsArrDic setObject:dateStr forKey:@"date"];
    [emailSmsArrDic setObject:@"1" forKey:@"send_offer"];
    [emailSmsArrDic setObject:datetimeStr forKey:@"datetime"];
    [emailSmsArrDic setObject:dataModel.zpId forKey:@"zp_id"];
    [emailSmsArrDic setObject:dataModel.desc_ forKey:@"sdesc"];
    [emailSmsArrDic setObject:dataModel.phone_ forKey:@"phone"];
    [emailSmsArrDic setObject:dataModel.pname_ forKey:@"pname"];
    [emailSmsArrDic setObject:dataModel.userId forKey:@"senduid"];
    [emailSmsArrDic setObject:dataModel.address_ forKey:@"place"];
    [emailSmsArrDic setObject:@"" forKey:@"tradeid"];
    [emailSmsArrDic setObject:dataModel.jobName forKey:@"job_name"];
    [emailSmsArrDic setObject:dataModel.type forKey:@"interview_type"];
    
    
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString *paramArrStr = [jsonWriter stringWithObject:paramArrDic];
    NSString *conditionArrStr = [jsonWriter stringWithObject:conditionArrDic];
    NSString *emailSmsArrStr = [jsonWriter stringWithObject:emailSmsArrDic];
    
    NSString *bodyMsg = [NSString stringWithFormat:@"forkey=%@&fortype=%@&state=%@&paramArr=%@&conditionArr=%@&emailSmsArr=%@", forkey, fortype, state, paramArrStr, conditionArrStr, emailSmsArrStr];
    
    [BaseUIViewController showLoadView:YES content:nil view:nil];
    [ELRequest postbodyMsg:bodyMsg op:op func:func requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        NSDictionary *dic = result;
        Status_DataModal *model = [[Status_DataModal alloc] init];
        model.status_ = dic[@"status"];
        model.code_ = dic[@"code"];
        model.des_ = dic[@"status_desc"];
        if ([model.code_ isEqualToString:@"200"]) {
            NSInteger count = self.navigationController.childViewControllers.count;
            BaseUIViewController *ctl  =self.navigationController.childViewControllers[count-3];

            [[NSNotificationCenter defaultCenter] postNotificationName:@"sendOfferSuccess" object:nil];

            [self.navigationController popToViewController:ctl animated:YES];
        }
        
        [BaseUIViewController showLoadView:NO content:nil view:nil];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [BaseUIViewController showLoadView:NO content:nil view:nil];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
