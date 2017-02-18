//
//  RegFirstCtl.m
//  jobClient
//
//  Created by 一览ios on 14/12/21.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "RegInfoTwoCtl.h"
#import "User_DataModal.h"
#import "NSString+URLEncoding.h"
#import "personTagModel.h"


@interface RegInfoTwoCtl ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate>
{
    User_DataModal          *   indaModal_;
    BOOL bKeyboardShow_;
    UITapGestureRecognizer *_singleTapRecognizer;
    NSString *_tradeId;
    RequestCon *_saveUserCon;
    RequestCon *_addSchoolRelCon;
}
@end

@implementation RegInfoTwoCtl

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        rightNavBarStr_ = @"下一步";
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"个人档案";
    [self setNavTitle:@"个人档案"];
    if (!indaModal_) {
        indaModal_ = [[User_DataModal alloc] init];   
    }
    indaModal_.identity_ = @"1";
    _tradeTF.delegate = self;
    _schoolTF.delegate = self;
    _majorTF.delegate = self;
    [self initAttr];
    _graduateView.hidden= YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_tradeTF becomeFirstResponder];
}

- (void)initAttr
{

    [_talentBtn setImage:[UIImage imageNamed:@"icon_bag_no.png"] forState:UIControlStateNormal];
    [_talentBtn setImage:[UIImage imageNamed:@"icon_bag_yes.png"] forState:UIControlStateSelected];
    [_graduateBtn setImage:[UIImage imageNamed:@"icon_Hat_no.png"] forState:UIControlStateNormal];
    [_graduateBtn setImage:[UIImage imageNamed:@"icon_Hat_yes.png"] forState:UIControlStateSelected];
    [_talentBtn setTitle:@"职场达人" forState:UIControlStateSelected];
    [_graduateBtn setTitle:@"应届生" forState:UIControlStateSelected];
    CALayer *talentBtnLayer = _talentBtn.layer;
    talentBtnLayer.masksToBounds = YES;
    talentBtnLayer.cornerRadius = 4.0;
    talentBtnLayer.borderWidth = 1.0;
    talentBtnLayer.borderColor = [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1.0].CGColor;
    CALayer *graduateBtnLayer = _graduateBtn.layer;
    graduateBtnLayer.masksToBounds = YES;
    graduateBtnLayer.cornerRadius = 4.0;
    graduateBtnLayer.borderWidth = 1.0;
    graduateBtnLayer.borderColor = [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1.0].CGColor;
    CALayer *nextBtn1 = _nextBtn1.layer;
    nextBtn1.masksToBounds = YES;
    nextBtn1.cornerRadius = 4.0;
    CALayer *nextBtn2 = _nextBtn2.layer;
    nextBtn2.masksToBounds = YES;
    nextBtn2.cornerRadius = 4.0;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    indaModal_ = dataModal;
    [super beginLoad:dataModal exParam:exParam];
}

- (void)getDataFunction:(RequestCon *)con
{
    [super getDataFunction:con];
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    if (requestCon == _saveUserCon) {
        Status_DataModal * dataModal = [dataArr objectAtIndex:0];
        if([dataModal.status_ isEqualToString:Success_Status]){
            [BaseUIViewController showModalLoadingView:NO title:nil status:nil];
            [self showChooseAlertView:11 title:@"注册完成" msg:@"是否马上登录" okBtnTitle:@"马上登录" cancelBtnTitle:@"稍后登录"];
        }
        else
        {
            [BaseUIViewController showAutoDismissFailView:@"注册失败"  msg:dataModal.des_];
        }
    }
}

- (void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
    [_talentBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
}



- (void)btnResponse:(id)sender
{
    if(sender == _talentBtn){
        _tradeTF.text = @"";
        UIButton *btn = (UIButton *)rightBarBtn_;
        [btn setTitle:@"下一步" forState:UIControlStateNormal];
//        [_trade_hangye resignFirstResponder];
        [_tradeTF resignFirstResponder];
        if (_graduateBtn.selected) {
            _graduateBtn.selected = NO;
            _graduateBtn.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0];
        }
        
        if (_talentBtn.selected) {
            _talentBtn.selected = NO;
            _talentBtn.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0];
            indaModal_.identity_ = nil;
        }else{
            _talentBtn.selected = YES;
            _talentBtn.backgroundColor = [UIColor colorWithRed:215.0/255 green:50.0/255 blue:50.0/255 alpha:1.0];
            indaModal_.identity_ = @"1";//职场达人
            _graduateView.hidden = YES;
            _talentView.hidden = NO;
            
        }
        return;
    }else if(sender == _graduateBtn){
        _tradeTF.text = @"";
        UIButton *btn = (UIButton *)rightBarBtn_;
        [btn setTitle:@"完成" forState:UIControlStateNormal];
        _tradeId = nil;
        indaModal_.trade_ = nil;
//        [_trade_hangye resignFirstResponder];
        [_tradeTF resignFirstResponder];
        if (_talentBtn.selected) {
            _talentBtn.selected = NO;
            _talentBtn.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0];
        }
        if (_graduateBtn.selected) {
            _graduateBtn.selected = NO;
            _graduateBtn.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0];
            indaModal_.identity_ = nil;
        }else{
            _graduateBtn.selected = YES;
            _graduateBtn.backgroundColor = [UIColor colorWithRed:215.0/255 green:50.0/255 blue:50.0/255 alpha:1.0];
            indaModal_.identity_ = @"0";//应届生
            _talentView.hidden = YES;
            CGRect frame = _graduateView.frame;
            frame.origin = _talentView.frame.origin;
            _graduateView.frame = frame;
            _graduateView.hidden = NO;
        }
        return;
    }else if (sender == _nextBtn1 || sender == _nextBtn2){
        [self rightBarBtnResponse:sender];
    }
}

#pragma mark 应届生注册
- (void)graduateRegist
{
//    inModal_.userId_ = @"15698343";
    [self saveUserInfo:inModal_.userId_];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"RegistSuccess" object:inModal_];
    //注册成功应届生请求关注学校
    if (!_addSchoolRelCon) {
        _addSchoolRelCon = [self getNewRequestCon:NO];
    }
    [_addSchoolRelCon addAttentionSchoolWithUserId:inModal_.userId_ schoolName:inModal_.school_];
}

#pragma mark 完善注册信息
-(void)saveUserInfo:(NSString*)userId
{
    if (!_saveUserCon) {
        _saveUserCon = [self getNewRequestCon:NO];
    }
    //    // person_id 人才ID
    //    // person_pic_personality 图片
    //    // person_iname 姓名
    //    // person_nickname 呢称
    //    // person_sex 性别
    //    // person_hka 籍贯
    //    // person_zw 职称/职位
    //    // person_job_now 行业/职业
    //    // person_signature 个性签名
    //    // person_company 公司/单位
    //tradeID：行业代码 trade->person_job_now行业名称 job ->person_zw头衔  pic->person_pic_personality头像    zym－>专业 rctypeId－>分类 企业达人／应届生
    
    [_saveUserCon saveUserInfo:userId job:indaModal_.job_ sex:indaModal_.sex_ pic:indaModal_.img_ name:indaModal_.name_ trade:indaModal_.trade_ company:@"" nickname:@"" signature:@"" hkaId:@"" school:indaModal_.school_ zym:indaModal_.major_ rctypeId:indaModal_.identity_ regionStr:nil workAge:nil brithday:nil tradeId: @"" tradeName:@""];
}



-(void)alertViewChoosed:(UIAlertView *)alertView index:(int)index type:(int)type
{
    [super alertViewChoosed:alertView index:index type:type];
    switch (type) {
        case 1:
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
        case 11:
        {
//            LoginCtl *loginCtl = [Manager shareMgr].loginCtl_;
//            inModal_.uname_ = @"13480939802";
//            inModal_.pwd_ = @"123456";
//            loginCtl.usernameTf_.text = inModal_.uname_;
//            loginCtl.pwdTf_.text =inModal_.pwd_;
            [[Manager shareMgr].loginCtl_ login:0];
        }
            break;
        default:
            break;
    }
}

-(void)alertViewCancel:(UIAlertView *)alertView index:(int)index type:(int)type
{
    switch (type) {
        case 11:
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == _tradeTF || textField == _majorTF) {
        [self rightBarBtnResponse:nil];
    }
    
    if (textField == _schoolTF) {
        [_majorTF becomeFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark 应届生完成注册，达人选择行业
- (void)rightBarBtnResponse:(id)sender
{
    //下一
    if (!indaModal_.identity_ ) {
        [BaseUIViewController showAlertView:@"请选择职场达人或应届生" msg:nil btnTitle:@"确定"];
        return;
    }
    if ([indaModal_.identity_ isEqualToString:@"0"]) {//应届生
        if ([[_schoolTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
            [BaseUIViewController showAlertView:@"请填写在哪所院校" msg:nil btnTitle:@"确定"];
            return;
        }
        if ([[_majorTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
            [BaseUIViewController showAlertView:@"请填写学的什么专业" msg:nil btnTitle:@"确定"];
            return;
        }
    }else{
        if ([[_tradeTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
            [BaseUIViewController showAlertView:@"请填写你的职业" msg:nil btnTitle:@"确定"];
            return;
        }
    }
    
    NSString *regex = @"^[\u4e00-\u9fa5_a-zA-Z0-9 ]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([indaModal_.identity_ isEqualToString:@"0"]) {//应届生
        if(![pred evaluateWithObject: _schoolTF.text]){
            NSString *errMsg;
            errMsg = @"院校只能由中文,字母或者数字组成";
            [BaseUIViewController showAlertView:errMsg msg:nil btnTitle:@"确定"];
            [_schoolTF becomeFirstResponder];
            return;
        }
        if(![pred evaluateWithObject: _majorTF.text]){
            NSString *errMsg;
            errMsg = @"专业只能由中文,字母或者数字组成";
            [BaseUIViewController showAlertView:errMsg msg:nil btnTitle:@"确定"];
            [_majorTF becomeFirstResponder];
            return;
        }
    }else{
        if (![[_majorTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
            if(![pred evaluateWithObject: _tradeTF.text]){
                NSString *errMsg;
                errMsg = @"职业只能由中文,字母或者数字组成";
                [BaseUIViewController showAlertView:errMsg msg:nil btnTitle:@"确定"];
                [_tradeTF becomeFirstResponder];
                return;
            }
        }
    }
    
    if ([indaModal_.identity_ isEqualToString:@"0"]) {//应届生 完成注册
        indaModal_.school_ = _schoolTF.text;
        indaModal_. major_ = _majorTF.text;
        indaModal_.trade_ = @"";
        indaModal_.job_ = @"";
        indaModal_.tradeId = @"";
        indaModal_.tradeName = @"";
//        [self graduateRegist];
        
    }
    if ([indaModal_.identity_ isEqualToString:@"1"]) {//达人选择行业
        indaModal_.trade_ = _tradeTF.text;
        indaModal_.school_ = @"";
        indaModal_. major_ = @"";
    }
    
    RegInfoThreeCtl *regInfoThreeCtl = [[RegInfoThreeCtl alloc] init];
    [self.navigationController pushViewController:regInfoThreeCtl animated:YES];
    [regInfoThreeCtl beginLoad:indaModal_ exParam:nil];
}

//设置右按扭的属性
- (void)setRightBarBtnAtt
{
    [rightBarBtn_ setTitle:@"下一步" forState:UIControlStateNormal];
    rightBarBtn_.layer.cornerRadius = 2.0;
    [rightBarBtn_ setBackgroundColor:[UIColor colorWithRed:196.0/255.0 green:0.0/255.0 blue:8.0/255.0 alpha:1.0]];
    [rightBarBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBarBtn_ setFrame:CGRectMake(0, 0, 55, 26)];
    [rightBarBtn_.titleLabel setFont:FIFTEENFONT_TITLE];
}

//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    if (textField == _trade_hangye && [indaModal_.identity_ isEqualToString:@"1"]) {//达人选择行业
//        [textField resignFirstResponder];
//        RegInfoThreeCtl *regInfoCtl = [[RegInfoThreeCtl alloc]init];
//        regInfoCtl.delegate = self;
//        [self.navigationController pushViewController:regInfoCtl animated:YES];
//        [regInfoCtl beginLoad:indaModal_ exParam:nil];
//    }
//}

//- (void)updateTrade:(personTagModel *)personTagModel
//{
//    _trade_hangye.text = personTagModel.tagName_;
//}



@end
