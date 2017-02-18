//
//  OrderCtl.m
//  jobClient
//
//  Created by 一览ios on 15/3/7.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "JoinActivityCtl.h"
#import "PayCtl.h"
#import "OrderService_DataModal.h"
#import "RRServiceSelectCtl.h"
#import "Order.h"

@interface JoinActivityCtl ()<UITextFieldDelegate, UITextViewDelegate>
{
    RequestCon *_saveActivityCon;
    
    __weak IBOutlet UIView *backView;
    
    IBOutlet UIView *remarkView;
    
    IBOutlet UIView *nameView;
    IBOutlet UIView *phoneView;
    
    IBOutlet UIView *companyView;
    
    IBOutlet UIView *groupView;
    IBOutlet UIView *jobView;
    
    IBOutlet UIView *emailView;
    NSMutableArray *arrTF;
}
@end

@implementation JoinActivityCtl

- (instancetype)init
{
    self = [super init];
    rightNavBarStr_ = @"确定";
    arrTF = [[NSMutableArray alloc] init];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationItem.title = @"活动";
    [self setNavTitle:@"活动"];
    _scrollView.contentSize = CGSizeMake(320,700);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHideKeyBoard:)];
    _scrollView.userInteractionEnabled = YES;
    [_scrollView addGestureRecognizer:tap];
    
    CGFloat height = 0;
    CGRect frameOne;
    if([_arrName containsObject:@"gaae_name"])
    {
        frameOne = nameView.frame;
        frameOne.origin.y = height;
        nameView.frame = frameOne;
        height += 50;
        [backView addSubview:nameView];
        [arrTF addObject:_userNameTF];
    }
    else
    {
        [nameView removeFromSuperview];
    }
    if([_arrName containsObject:@"gaae_contacts"])
    {
        frameOne = phoneView.frame;
        frameOne.origin.y = height;
        phoneView.frame = frameOne;
        height += 50;
        [backView addSubview:phoneView];
        [arrTF addObject:_phoneTF];
    }
    else
    {
        [phoneView removeFromSuperview];
    }
    if([_arrName containsObject:@"company"])
    {
        frameOne = companyView.frame;
        frameOne.origin.y = height;
        companyView.frame = frameOne;
        height += 50;
        [backView addSubview:companyView];
        [arrTF addObject:_companyTF];
    }
    else
    {
        [companyView removeFromSuperview];
    }
    if([_arrName containsObject:@"group"])
    {
        frameOne = groupView.frame;
        frameOne.origin.y = height;
        groupView.frame = frameOne;
        height += 50;
        [backView addSubview:groupView];
        [arrTF addObject:_groupTF];
    }
    if([_arrName containsObject:@"jobs"])
    {
        frameOne = jobView.frame;
        frameOne.origin.y = height;
        jobView.frame = frameOne;
        height += 50;
        [backView addSubview:jobView];
        [arrTF addObject:_jobTF];
    }
    else
    {
        [jobView removeFromSuperview];
    }
    if([_arrName containsObject:@"email"])
    {
        frameOne = emailView.frame;
        frameOne.origin.y = height;
        emailView.frame = frameOne;
        height += 50;
        [backView addSubview:emailView];
        [arrTF addObject:_emailTF];
    }
    else
    {
        [emailView removeFromSuperview];
    }
    
    CGRect frame = backView.frame;
    frame.size.height = height;
    backView.frame = frame;
    
    if([_arrName containsObject:@"remark"])
    {
        frameOne = remarkView.frame;
        frameOne.origin.y = height + backView.frame.origin.y + 5;
        remarkView.frame = frameOne;
        [_scrollView addSubview:remarkView];
        [arrTF addObject:_summaryTV];
    }
    else
    {
        [remarkView removeFromSuperview];
    }
}
-(void)tapHideKeyBoard:(UITapGestureRecognizer *)sender
{
    [_summaryTV resignFirstResponder];
    [_userNameTF resignFirstResponder];
    [_phoneTF resignFirstResponder];
    [_companyTF resignFirstResponder];
    [_groupTF resignFirstResponder];
    [_jobTF resignFirstResponder];
    [_emailTF resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        _scrollView.contentOffset = CGPointMake(0,0);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GetResumeApplyServiceInfo://服务信息
        {
        
        }
            break;
        case Request_GetArticleApply:
        {
            Status_DataModal *modal = dataArr[0];
            if ([modal.status_ isEqualToString:Success_Status])
            {
                [_joinDelagete joinNameRefreshBtn];
                [BaseUIViewController showAutoDismissAlertView:nil msg:modal.des_ seconds:1.0f];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [BaseUIViewController showAutoDismissFailView:nil msg:modal.des_ seconds:1.0f];
            }
        }
            break;
        default:
            break;
    }
}


- (void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
}

- (void)btnResponse:(UIButton *)sender
{
    
}

- (void)rightBarBtnResponse:(id)sender
{
    if(![self validForm]){
        return;
    }
    if (!_saveActivityCon) {
        _saveActivityCon = [self getNewRequestCon:YES];
    }
    _userNameTF.text = [MyCommon removeAllSpace:_userNameTF.text];
    _phoneTF.text = [MyCommon removeAllSpace:_phoneTF.text];
    
    [_saveActivityCon getApplyWithArticleId:_articleModal.id_ personId:[Manager getUserInfo].userId_ personIname:_userNameTF.text personPhone:_phoneTF.text personRemark:_summaryTV.text personCompany:_companyTF.text personGroup:_groupTF.text person_jobs:_jobTF.text person_email:_emailTF.text];
}

- (BOOL)validForm
{
    if ([[_userNameTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] && [_arrName containsObject:@"gaae_name"]) {
        [BaseUIViewController showAlertView:nil msg:@"请填写用户名" btnTitle:@"确定"];
        return NO;
    }else if ([[_phoneTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] && [_arrName containsObject:@"gaae_contacts"]){
        [BaseUIViewController showAlertView:nil msg:@"请填写联系电话" btnTitle:@"确定"];
        return NO;
    }else if ([[_companyTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] && [_arrName containsObject:@"company"]){
        [BaseUIViewController showAlertView:nil msg:@"请填写公司名称" btnTitle:@"确定"];
        return NO;
    }
    else if ([[_groupTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] && [_arrName containsObject:@"group"]){
        [BaseUIViewController showAlertView:nil msg:@"请填写部门名称" btnTitle:@"确定"];
        return NO;
    }
    else if ([[_jobTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] && [_arrName containsObject:@"jobs"]){
        [BaseUIViewController showAlertView:nil msg:@"请填写职位名称" btnTitle:@"确定"];
        return NO;
    }
    else if ([[_emailTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] && [_arrName containsObject:@"email"]){
        [BaseUIViewController showAlertView:nil msg:@"请填写邮箱" btnTitle:@"确定"];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (arrTF.count >= 2) {
        if (textField == arrTF[0]) {
            [arrTF[0] resignFirstResponder];
            [arrTF[1] becomeFirstResponder];
        }
    }
    if (arrTF.count >= 3) {
        if (textField == arrTF[1]) {
            [arrTF[1] resignFirstResponder];
            [arrTF[2] becomeFirstResponder];
        }
    }
    if (arrTF.count >= 4) {
        if (textField == arrTF[2]) {
            [arrTF[2] resignFirstResponder];
            [arrTF[3] becomeFirstResponder];
        }
    }
    if (arrTF.count >= 5) {
        if (textField == arrTF[3]) {
            [arrTF[3] resignFirstResponder];
            [arrTF[4] becomeFirstResponder];
        }
    }
    if (arrTF.count >= 6) {
        if (textField == arrTF[4]) {
            [arrTF[4] resignFirstResponder];
            [arrTF[5] becomeFirstResponder];
        }
    }
    if (arrTF.count >= 7) {
        if (textField == arrTF[5]) {
            [arrTF[5] resignFirstResponder];
            [arrTF[6] becomeFirstResponder];
        }
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGFloat height = 0;
    if (arrTF.count >= 5) {
        if(textField == arrTF[4])
        {
            height = 50;
        }
    }
    if (arrTF.count >= 6) {
        if(textField == arrTF[5])
        {
            height = 100;
        }
    }

    [UIView animateWithDuration:0.3 animations:^{
        _scrollView.contentOffset = CGPointMake(0,height);
    }];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _tipsLb.hidden = YES;
    CGFloat height = 0;
    if (arrTF.count >= 5) {
        height = 50;
    }
    if (arrTF.count >= 6) {
        height = 100;
    }
    
    CGFloat heightOne = 0;
    if (arrTF.count >= 3) {
        heightOne = 100;
    }
    if(textView == _summaryTV)
    {
        [UIView animateWithDuration:0.3 animations:^{
           _scrollView.contentOffset = CGPointMake(0,height + heightOne);
        }];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSString *content = textView.text;
    if ([[content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] ] isEqualToString:@""]) {
        _tipsLb.hidden = NO;
        textView.text = @"";
    }
    [UIView animateWithDuration:0.3 animations:^{
        _scrollView.contentOffset = CGPointMake(0,0);
    }];
}


@end
