//
//  SendInterviewCtl.m
//  jobClient
//
//  Created by YL1001 on 14-9-12.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "SendInterviewCtl.h"
#import "SendInterviewContentCtl.h"
#import "CompanyResumePrevierwModel.h"

@interface SendInterviewCtl ()
{
    CompanyResumePrevierwModel *_previewModel;
    
    NSString *_desContent;
    __weak IBOutlet UILabel *_positionLb;
    __weak IBOutlet UILabel *_dateLb;

    __weak IBOutlet NSLayoutConstraint *_bottomViewSpace;
    __weak IBOutlet NSLayoutConstraint *_preBtnSapce;
    __weak IBOutlet NSLayoutConstraint *modelViewHeight;
}

@end

@implementation SendInterviewCtl
@synthesize type_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (_operationType == OperationTypeInterview) {
        [self setNavTitle:@"面试通知"];
        _positionLb.text = @"面试职位";
        _dateLb.text = @"面试时间";
        
        modelViewHeight.constant = 40;
        cnameTF_.userInteractionEnabled = YES;
    }
    else if (_operationType == OperationTypeSendOffer || _operationType == OperationTypeOPSendOffer)
    {
        [self setNavTitle:@"发offer"];
        _positionLb.text = @"入职职位";
        _dateLb.text = @"入职时间";
        
        modelViewHeight.constant = 0;
        cnameTF_.userInteractionEnabled = NO;
    }

    
    if (type_ == Interview_SMS) {
        messageBtn_.selected = YES;
        _selectedBtn = messageBtn_;
    }
    else if (type_ == Interview_Emial){
        mailBtn_.selected = YES;
        _selectedBtn = mailBtn_;
    }
    else
    {
        messageBtn_.selected = YES;
        mailBtn_.selected = YES;
    }
    
    CALayer *layer = _previewBtn.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 3.f;
    
    [self.scrollView_ setContentSize:CGSizeMake(1, 1)];
    
    _bottomViewSpace.constant = -400;
    [self.view bringSubviewToFront:bottomView_];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateCom:(RequestCon *)con
{
    if (inDataModal_.job_ != nil && ![inDataModal_.job_ isEqualToString:@""] ) {
        [zwBtn_ setTitle:inDataModal_.job_ forState:UIControlStateNormal];
    }
    cnameTF_.text = [Manager getUserInfo].companyModal_.cname_;
    personNameTF_.text = [Manager getUserInfo].companyModal_.pname_;
    phoneTF_.text = [Manager getUserInfo].companyModal_.phone_;
    addressTF_.text = [Manager getUserInfo].companyModal_.address_;
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    inDataModal_ = dataModal;
    
    if (exParam) {
        _previewModel = exParam;
    }
    
    [self updateCom:nil];
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
                [self.navigationController popViewControllerAnimated:YES];
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


-(void)btnResponse:(id)sender
{
    if (sender != cnameTF_) {
        [cnameTF_ resignFirstResponder];
    }
    if (sender != personNameTF_) {
        [personNameTF_ resignFirstResponder];
    }
    if (sender != phoneTF_) {
        [phoneTF_ resignFirstResponder];
    }
    if (sender != addressTF_) {
        [addressTF_ resignFirstResponder];
    }
    
    if (sender == modelBtn_) {//模版选择
        ChosseInterviewModelCtl * chooseInterviewCtl = [[ChosseInterviewModelCtl alloc] init];
        chooseInterviewCtl.type_ = ChooseInterview;
        chooseInterviewCtl.delegate_ = self;
        [self.navigationController pushViewController:chooseInterviewCtl animated:YES];
        [chooseInterviewCtl beginLoad:[Manager getUserInfo].companyModal_.companyID_ exParam:nil];
    }
    else if (sender == zwBtn_)//职位选择
    {
        ChosseInterviewModelCtl * chooseInterviewCtl = [[ChosseInterviewModelCtl alloc] init];
        chooseInterviewCtl.type_ = ChooseZWForInterview;
        chooseInterviewCtl.delegate_ = self;
        [self.navigationController pushViewController:chooseInterviewCtl animated:YES];
        [chooseInterviewCtl beginLoad:[Manager getUserInfo].companyModal_.companyID_ exParam:nil];
    }
    else if (sender == dateBtn_)//日期时间选择
    {
        _bottomViewSpace.constant = 0;
    }
    else if (sender == chooseTimeBtn_)
    {
        _bottomViewSpace.constant = -400;
        NSString * dateStr = [MyCommon getDateStr:datePicker_.date format:@"yyyy年MM月dd日 HH时mm分"];
        [dateBtn_ setTitle:dateStr forState:UIControlStateNormal];
    }
    else if (sender == messageBtn_)//选择短信发送
    {
        if (_selectedBtn == sender) {
            return;
        }
        _selectedBtn.selected = NO;
        messageBtn_.selected = YES;
        _selectedBtn = messageBtn_;
    }
    else if (sender == mailBtn_)//选择邮件发送
    {
        if (_selectedBtn == sender) {
            return;
        }
        _selectedBtn.selected = NO;
        mailBtn_.selected = YES;
        _selectedBtn = mailBtn_;
    }else if (sender == _emailAndSmsBtn){
        if (_selectedBtn == sender) {
            return;
        }
        _selectedBtn.selected = NO;
        _emailAndSmsBtn.selected = YES;
        _selectedBtn = _emailAndSmsBtn;
    }else if (sender == _previewBtn){
        [self rightBarBtnResponse:nil];
    }
}

#pragma ChooseInterviewCtlDelegate
-(void)chooseInterviewModel:(InterviewModel_DataModal *)dataModal
{
    [modelBtn_ setTitle:dataModal.temlname_ forState:UIControlStateNormal];
    cnameTF_.text = dataModal.cname_;
    addressTF_.text = dataModal.address_;
    personNameTF_.text = dataModal.pname_;
    phoneTF_.text = dataModal.phone_;
    _desContent = dataModal.desc_;
}

-(void)chooseZw:(ZWDetail_DataModal *)dataModal
{
    [zwBtn_ setTitle:dataModal.jtzw_ forState:UIControlStateNormal];
}

-(void)rightBarBtnResponse:(id)sender
{
    if ([[cnameTF_.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        [BaseUIViewController showAlertView:@"公司名称不能为空" msg:nil btnTitle:@"确定"];
        return;
    }
    if ([[personNameTF_.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        [BaseUIViewController showAlertView:@"联系人不能为空" msg:nil btnTitle:@"确定"];
        return;
    }
    if ([[phoneTF_.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        [BaseUIViewController showAlertView:@"联系电话不能为空" msg:nil btnTitle:@"确定"];
        return;
    }
    if ([[addressTF_.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        [BaseUIViewController showAlertView:@"公司地址不能为空" msg:nil btnTitle:@"确定"];
        return;
    }
    if ([zwBtn_.titleLabel.text isEqualToString:@"选择职位"]) {
        [BaseUIViewController showAlertView:@"请选择职位" msg:nil btnTitle:@"确定"];
        return;
    }
    if ([dateBtn_.titleLabel.text isEqualToString:@"选择日期时间"]) {
        [BaseUIViewController showAlertView:@"请选择日期时间" msg:nil btnTitle:@"确定"];
        return;
    }
    NSString * type = @"";
    NSString * year = @"";
    NSString * month = @"";
    NSString * day = @"";
    NSString * hour = @"";
    NSString * min = @"";
    if (_selectedBtn == messageBtn_) {
        type = @"sms";
    }else if (_selectedBtn == mailBtn_){
        type = @"email";
    }else if (_selectedBtn == _emailAndSmsBtn){
        type = @"sms,email";
    }
    NSRange range ;
    range.length = 4;
    range.location = 0;
    @try {
        
        year =[dateBtn_.titleLabel.text substringWithRange:range];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    range.length = 2;
    range.location = 5;
    @try {
        month = [dateBtn_.titleLabel.text substringWithRange:range];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    range.length = 2;
    range.location = 8;
    @try {
        day = [dateBtn_.titleLabel.text substringWithRange:range];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    range.length = 2;
    range.location = 12;
    @try {
        hour = [dateBtn_.titleLabel.text substringWithRange:range];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    range.length = 2;
    range.location = 15;
    @try {
        min = [dateBtn_.titleLabel.text substringWithRange:range];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    NSString *content;
    if (_operationType == OperationTypeInterview) {
        content = [NSString stringWithFormat:@"%@，您好，请于%@携带简历到%@面试%@一职，地址：%@，联系人：%@（%@)",inDataModal_.name_, dateBtn_.titleLabel.text, cnameTF_.text, zwBtn_.titleLabel.text, addressTF_.text,personNameTF_.text, phoneTF_.text];
    }
    else {
        content = @"您已通过了面试，很高兴邀请您前来入职，请注意入职的时间和地点，若行程有变更，请及时联系通知。";
    }
    
    InterviewModel_DataModal *interviewModel = [[InterviewModel_DataModal alloc]init];
    interviewModel.type = type;
    interviewModel.userId = inDataModal_.userId_;
    interviewModel.resumeId = inDataModal_.emailId_;
    interviewModel.zpId = inDataModal_.zpId_;
    interviewModel.tradeId = inDataModal_.tradeId;
    interviewModel.jobName = zwBtn_.titleLabel.text;
    interviewModel.desc_ = content;
    interviewModel.year = year;
    interviewModel.month = month;
    interviewModel.day = day;
    interviewModel.hour = hour;
    interviewModel.min = min;
    interviewModel.address_ = addressTF_.text;
    interviewModel.pname_ = personNameTF_.text;
    interviewModel.phone_ = phoneTF_.text;
    interviewModel.temlname_ = modelBtn_.titleLabel.text;
    
    SendInterviewContentCtl *contentCtl = [[SendInterviewContentCtl alloc]init];
    contentCtl.interviewModal = interviewModel;
    contentCtl.userModel = inDataModal_;
    contentCtl.operationType = _operationType;
    contentCtl.companyId = _companyId;
    [self.navigationController pushViewController:contentCtl animated:YES];
    [contentCtl beginLoad:_previewModel exParam:nil];
}
@end
