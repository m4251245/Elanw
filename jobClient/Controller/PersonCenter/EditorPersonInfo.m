//
//  EditorPersonInfo.m
//  jobClient
//
//  Created by 一览ios on 14-12-30.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "EditorPersonInfo.h"

@interface EditorPersonInfo ()

@end

@implementation EditorPersonInfo

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        rightNavBarStr_ = @"保存";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [editorTextField_ addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    editorView_.layer.borderColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0].CGColor;
    editorView_.layer.borderWidth = 0.5;
    
    [tipsLb_ setFont:FIFTEENFONT_TITLE];
    [tipsLb_ setTextColor:BLACKCOLOR];
    
    [editorTextField_ setFont:FIFTEENFONT_TITLE];
    [editorTextField_ setTextColor:UIColorFromRGB(0x333333)];
    
    [editorBtn_.titleLabel setFont:FIFTEENFONT_TITLE];
    [editorBtn_ setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    
    [editorTextField_ setHidden:YES];
    [editorBtn_ setHidden:YES];
    switch (_editorType) {
        case name_type:
        {
            [tipsLb_ setText:@"姓名："];
            [self setNavTitle:@"修改姓名"];
            [editorTextField_ setHidden:NO];
        }
            break;
        case age_type:
        {
            [tipsLb_ setText:@"年龄："];
            [editorBtn_ setHidden:NO];
            [self setNavTitle:@"修改出生年月"];
            
        }
            break;
        case workage_type:
        {
            [editorTextField_ setHidden:NO];
            [tipsLb_ setText:@"工作年限："];
            [self setNavTitle:@"修改工作年限"];
        }
            break;
        case workAddr_type:
        {
            [editorBtn_ setHidden:NO];
            [tipsLb_ setText:@"现工作地："];
            [self setNavTitle:@"修改现工作地"];
        }
            break;
        case trade_type:
        {
            [editorBtn_ setHidden:NO];
            [tipsLb_ setText:@"行业："];
            [self setNavTitle:@"修改行业"];
        }
            break;
        case zhiye_type:
        {
            [editorTextField_ setHidden:NO];
            [tipsLb_ setText:@"职业："];
            [self setNavTitle:@"修改职业"];
        }
            break;
        case touxian_type:
        {
            [editorTextField_ setHidden:NO];
            [tipsLb_ setText:@"头衔："];
            [self setNavTitle:@"修改头衔"];
        }
            break;
        case gender_type:
        {
            [editorBtn_ setHidden:NO];
            [tipsLb_ setText:@"性别"];
            [self setNavTitle:@"修改性别"];
        }
            break;
        case role_type:
        {
            [editorBtn_ setHidden:NO];
            [tipsLb_ setText:@"求职身份"];
            [self setNavTitle:@"修改求职身份"];
        }
            break;
        case jobStatus_type:
        {
            [editorBtn_ setHidden:NO];
            [tipsLb_ setText:@"求职状态"];
            [self setNavTitle:@"修改求职状态"];
        }
            break;
        default:
            break;
    }
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    inModelOne_ = dataModal;
}

//设置右按扭的属性
//- (void)setRightBarBtnAtt
//{
//    [rightBarBtn_ setTitle:@"保存" forState:UIControlStateNormal];
//    rightBarBtn_.layer.cornerRadius = 2.0;
//    [rightBarBtn_ setBackgroundColor:[UIColor clearColor]];
//    [rightBarBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [rightBarBtn_ setFrame:CGRectMake(0, 0, 45, 31)];
//    [rightBarBtn_.titleLabel setFont:[UIFont systemFontOfSize:15]];
//}

- (void)btnResponse:(id)sender
{
    switch (_editorType) {
        case age_type:
        {
            preCondictionListCtl.delegate_ = self;
            NSDate *date = nil;
            if ([editorBtn_.titleLabel.text isEqualToString:@"请选择出生年月"] || [editorBtn_.titleLabel.text isEqualToString:@""]) {
                date = [@"1980-01-01" dateFormStringFormat:@"yyyy-MM-dd"];
            }else{
                date = [editorBtn_.titleLabel.text dateFormStringFormat:@"yyyy-MM-dd"];
            }
            [preCondictionListCtl beginGetData:date exParam:nil type:GetBirthDayDateType];
        }
            break;
        case workAddr_type:
        {
            if (![Manager shareMgr].regionListCtl_) {
                [Manager shareMgr].regionListCtl_ = [[RegionCtl alloc] init];
            }
            [self.navigationController pushViewController:[Manager shareMgr].regionListCtl_ animated:YES];
            [[Manager shareMgr].regionListCtl_ beginLoad:nil exParam:nil];
            [Manager shareMgr].regionListCtl_.delegate_ = self;
        }
            break;
        case trade_type:
        {
            RegInfoThreeCtl *regCtl = [[RegInfoThreeCtl alloc]init];
            [regCtl setType:@"0"];
            [regCtl beginLoad:nil exParam:nil];
            regCtl.delegate = self;
            [self.navigationController pushViewController:regCtl animated:YES];
        }
            break;
        case gender_type:
        {
            //选择性别
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
            [actionSheet showInView:self.view];
           
        }
            break;
        case role_type:
        {
            //选择社会身份
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"社会人才",@"应届生", nil];
            [actionSheet showInView:self.view];
            
        }
            break;
        case jobStatus_type:
        {
            //选择求职状态
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"已离职，即可到岗",@"仍在职，欲换工作",@"暂不跳槽",@"寻找新机会", nil];
            [actionSheet showInView:self.view];
            
        }
            break;
        
        default:
            break;
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_editorType == gender_type) {
        if (buttonIndex == 0) {
            [editorBtn_ setTitle:@"男" forState:UIControlStateNormal];
        }else if (buttonIndex == 1){
            [editorBtn_ setTitle:@"女" forState:UIControlStateNormal];
        }
    }else if (_editorType == role_type){
        if (buttonIndex == 0) {
            [editorBtn_ setTitle:@"社会人才" forState:UIControlStateNormal];
        }else if (buttonIndex == 1){
            [editorBtn_ setTitle:@"应届生" forState:UIControlStateNormal];
        }
    }else if (_editorType == jobStatus_type){
        if (buttonIndex == 0){
            [editorBtn_ setTitle:@"已离职，即可到岗" forState:UIControlStateNormal];
        }else if (buttonIndex == 1){
            [editorBtn_ setTitle:@"仍在职，欲换工作" forState:UIControlStateNormal];
        }else if (buttonIndex == 2){
            [editorBtn_ setTitle:@"暂不跳槽" forState:UIControlStateNormal];
        }else if (buttonIndex == 3){
            [editorBtn_ setTitle:@"寻找新机会" forState:UIControlStateNormal];
        }
    }
}

#pragma mark -
- (void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
    switch (_editorType) {
        case name_type:
        {
            [editorTextField_ setText:inModelOne_.userModel_.iname_];
        }
            break;
        case age_type:
        {
            if ([inModelOne_.userModel_.bday_ isEqualToString:@""]) {
                [editorBtn_ setTitle:@"请选择出生年月" forState:UIControlStateNormal];
            }else{
                [editorBtn_ setTitle:inModelOne_.userModel_.bday_ forState:UIControlStateNormal];
            }
        }
            break;
        case workage_type:
        {
            if([inModelOne_.userModel_.gznum_ isEqualToString:@"0.0"]){
                inModelOne_.userModel_.gznum_ = @"0";
            }
            if ([inModelOne_.userModel_.gznum_ isEqualToString:@""]) {
                [editorTextField_ setPlaceholder:@"请输入工作年限"];
            }else{
                [editorTextField_ setText:inModelOne_.userModel_.gznum_];
            }
        }
            break;
        case workAddr_type:
        {
            if ([inModelOne_.userModel_.cityStr_ isEqualToString:@""]) {
                [editorBtn_ setTitle:@"请选择现工作地" forState:UIControlStateNormal];
            }else{
                [editorBtn_ setTitle:inModelOne_.userModel_.cityStr_ forState:UIControlStateNormal];
            }
        }
            break;
        case trade_type:
        {
            if ([inModelOne_.userModel_.tradeName isEqualToString:@""]) {
                [editorBtn_ setTitle:@"请选择现行业" forState:UIControlStateNormal];
            }else{
                [editorBtn_ setTitle:inModelOne_.userModel_.tradeName forState:UIControlStateNormal];
            }
        }
            break;
        case zhiye_type:
        {
            if ([inModelOne_.userModel_.job_ isEqualToString:@""]) {
                [editorTextField_ setPlaceholder:@"请输入职业"];\
            }else{
                [editorTextField_ setText:inModelOne_.userModel_.job_];
            }
        }
            break;
        case touxian_type:
        {
            if ([inModelOne_.userModel_.zw_ isEqualToString:@""]) {
                [editorTextField_ setPlaceholder:@"请输入头衔"];
            }else{
                [editorTextField_ setText:inModelOne_.userModel_.zw_];
            }
        }
            break;
        case gender_type:
        {
            if (![inModelOne_.userModel_.sex_ isEqualToString:@"男"] && ![inModelOne_.userModel_.sex_ isEqualToString:@"女"]) {
                [editorBtn_ setTitle:@"请选择性别" forState:UIControlStateNormal];
            }else{
                [editorBtn_ setTitle:inModelOne_.userModel_.sex_ forState:UIControlStateNormal];
            }
        }
            break;
        case role_type:
        {
            if (![inModelOne_.userModel_.sex_ isEqualToString:@"社会人才"] && ![inModelOne_.userModel_.sex_ isEqualToString:@"应届生"]) {
                [editorBtn_ setTitle:@"请选择求职身份" forState:UIControlStateNormal];
            }else{
                [editorBtn_ setTitle:inModelOne_.userModel_.sex_ forState:UIControlStateNormal];
            }
        }
            break;
        case jobStatus_type:
        {
            if (![inModelOne_.userModel_.sex_ isEqualToString:@"已离职，即可到岗"] && ![inModelOne_.userModel_.sex_ isEqualToString:@"仍在职，欲换工作'"] && ![inModelOne_.userModel_.sex_ isEqualToString:@"暂不跳槽"] && ![inModelOne_.userModel_.sex_ isEqualToString:@"寻找新机会"]) {
                
                [editorBtn_ setTitle:@"请选择求职状态" forState:UIControlStateNormal];
            }else{
                [editorBtn_ setTitle:inModelOne_.userModel_.sex_ forState:UIControlStateNormal];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [super textFieldShouldBeginEditing:textField];
    switch (_editorType) {
        case name_type:
        {
            textField.keyboardType  = UIKeyboardTypeDefault;
        }
            break;
        case workage_type:
        {
            textField.keyboardType  = UIKeyboardTypeDecimalPad;
            textField.text = @"";
        }
            break;
        case zhiye_type:
        {
            textField.keyboardType  = UIKeyboardTypeDefault;
        }
            break;
        case touxian_type:
        {
            textField.keyboardType  = UIKeyboardTypeDefault;
        }
            break;
        default:
            break;
    }
    return YES;
}

- (void)textFieldDidChange:(UIEvent *)sent
{
    UITextField *textField = (UITextField *)sent;
    
    if ([[MyCommon removeSpaceAtSides:textField.text] isEqualToString:@""]) {
        switch (_editorType) {
            case name_type:
            {
                if ([[MyCommon removeSpaceAtSides:textField.text] isEqualToString:@""]) {
                    [editorTextField_ setPlaceholder:@"请输入姓名"];
                }
            }
                break;
            case workage_type:
            {
                if ([[MyCommon removeSpaceAtSides:textField.text] isEqualToString:@""]) {
                    [editorTextField_ setPlaceholder:@"请输入工作年限"];
                }
            }
                break;
            case zhiye_type:
            {
                if ([[MyCommon removeSpaceAtSides:textField.text] isEqualToString:@""]) {
                    [editorTextField_ setPlaceholder:@"请输入职业"];\
                }
            }
                break;
            case touxian_type:
            {
                if ([[MyCommon removeSpaceAtSides:textField.text] isEqualToString:@""]) {
                    [editorTextField_ setPlaceholder:@"请输入头衔"];
                }
            }
                break;
            default:
                break;
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    switch (_editorType) {
        case workage_type:
        {
            NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
            [futureString  insertString:string atIndex:range.location];
            
            NSInteger flag=0;
            const NSInteger limited = 1;
            if ([futureString containsString:@"."]) {
                for (NSInteger i = futureString.length-1; i >= 0; i--) {
                    if ([futureString characterAtIndex:i] == '.') {
                        if (flag > limited) {
                            return NO;
                        }
                        break;
                    }
                    flag++;
                }
            }
        }
            break;
        default:
            break;
    }
    
    return YES;
}


- (void)rightBarBtnResponse:(id)sender
{
    if (_fromResume) {
        switch (_editorType) {
            case name_type:
            {
                inModelOne_.userModel_.iname_ = [MyCommon removeAllSpace:editorTextField_.text];
            }
                break;
            case age_type:
            {
                NSString *birthdayStr = editorBtn_.titleLabel.text;
                NSDate *brithDate = [birthdayStr dateFormStringFormat:@"yyyy-MM-dd"];
                NSTimeInterval dateDiff = [brithDate timeIntervalSinceNow];
                int age = trunc(dateDiff/(60*60*24))/365;
                inModelOne_.userModel_.age_ = [NSString stringWithFormat:@"%d",-age];
                
                inModelOne_.userModel_.bday_ = birthdayStr;
            }
                break;
            case gender_type:
            {
                inModelOne_.userModel_.sex_ = editorBtn_.titleLabel.text;
            }
                break;
            case role_type:
            {
                if ([editorBtn_.titleLabel.text isEqualToString:@"社会人才"]) {
                    inModelOne_.userModel_.role_ = @"0";
                }else if ([editorBtn_.titleLabel.text isEqualToString:@"应届生"]){
                    inModelOne_.userModel_.role_ = @"1";
                }
            }
                break;
            case jobStatus_type:
            {
                inModelOne_.userModel_.jobStatus = editorBtn_.titleLabel.text;
            }
                break;
            case workage_type:
            {
                if (![MyCommon isPureFloat:editorTextField_.text] || ![MyCommon isPureFloat:editorTextField_.text]) {
                    [BaseUIViewController showAutoDismissSucessView:nil msg:@"含非法字符，请输入纯数字！"];
                    return;
                }
                inModelOne_.userModel_.gznum_ = [MyCommon removeAllSpace:editorTextField_.text];
            }
                break;
            case workAddr_type:
            {
                inModelOne_.userModel_.cityStr_ = editorBtn_.titleLabel.text;
            }
                break;
            case trade_type:
            {
                inModelOne_.userModel_.tradeName = editorBtn_.titleLabel.text;
            }
                break;
            case zhiye_type:
            {
                inModelOne_.userModel_.job_ = [MyCommon removeAllSpace:editorTextField_.text];
            }
                break;
            case touxian_type:
            {
                inModelOne_.userModel_.zw_ = [MyCommon removeAllSpace:editorTextField_.text];
            }
                break;
            default:
                break;
        }
        [_delegate editorSuccess];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    
    if (!editCon_) {
        editCon_ = [self getNewRequestCon:NO];
    }
    switch (_editorType) {
        case name_type:
        {
            if ([[MyCommon removeAllSpace:editorTextField_.text] isEqualToString:@""]) {
                [BaseUIViewController showAlertView:@"温馨提示" msg:@"请输入姓名" btnTitle:@"知道了"];
                return;
            }
            [editCon_ saveUserInfo:[Manager getUserInfo].userId_ job:nil sex:nil pic:nil name:[MyCommon removeSpaceAtSides:editorTextField_.text] trade:nil company:nil nickname:nil signature:nil  hkaId:nil school:nil zym:nil rctypeId:nil regionStr:nil workAge:nil brithday:nil tradeId:nil tradeName:nil];
        }
            break;
        case age_type:
        {
            if ([[MyCommon removeAllSpace:editorBtn_.titleLabel.text] isEqualToString:@""]) {
                [BaseUIViewController showAlertView:@"温馨提示" msg:@"请选择出生年月" btnTitle:@"知道了"];
                return;
            }
            [editCon_ saveUserInfo:[Manager getUserInfo].userId_ job:nil sex:nil pic:nil name:nil trade:nil company:nil nickname:nil signature:nil hkaId:nil school:nil zym:nil rctypeId:nil regionStr:nil workAge:nil brithday:[MyCommon removeSpaceAtSides:editorBtn_.titleLabel.text] tradeId:nil tradeName:nil];
        }
            break;
        case workage_type:
        {
            if ([[MyCommon removeAllSpace:editorTextField_.text] isEqualToString:@""]) {
                [BaseUIViewController showAlertView:@"温馨提示" msg:@"请输入工作年限" btnTitle:@"知道了"];
                return;
            }
            
            if (![MyCommon isPureFloat:editorTextField_.text] || ![MyCommon isPureFloat:editorTextField_.text]) {
                [BaseUIViewController showAutoDismissSucessView:nil msg:@"含非法字符，请输入纯数字！"];
                return;
            }
            
            if ([editorTextField_.text integerValue] > 60) {
                [BaseUIViewController showAutoDismissSucessView:nil msg:@"工作年限必须小于60"];
                return;
            }
            
            [editCon_ saveUserInfo:[Manager getUserInfo].userId_ job:nil sex:nil pic:nil name:nil trade:nil company:nil nickname:nil signature:nil hkaId:nil school:nil zym:nil rctypeId:nil regionStr:nil workAge:[MyCommon removeSpaceAtSides:editorTextField_.text] brithday:nil tradeId:nil tradeName:nil];
        }
            break;
        case workAddr_type:
        {
            if ([[MyCommon removeAllSpace:regionDataModal_.id_] isEqualToString:@""]) {
                [BaseUIViewController showAlertView:@"温馨提示" msg:@"请选择工作地" btnTitle:@"知道了"];
                return;
            }
            [editCon_ saveUserInfo:[Manager getUserInfo].userId_ job:nil sex:nil pic:nil name:nil trade:nil company:nil nickname:nil signature:nil hkaId:nil school:nil zym:nil rctypeId:nil regionStr:regionDataModal_.id_ workAge:nil brithday:nil tradeId:nil tradeName:nil];
        }
            break;
        case trade_type:
        {
            if ([[MyCommon removeAllSpace:personModel_.tagName_] isEqualToString:@""]) {
                [BaseUIViewController showAlertView:@"温馨提示" msg:@"请选择行业" btnTitle:@"知道了"];
                return;
            }
            [editCon_ saveUserInfo:[Manager getUserInfo].userId_ job:nil sex:nil pic:nil name:nil trade:nil company:nil nickname:nil signature:nil hkaId:nil school:nil zym:nil rctypeId:nil regionStr:nil workAge:nil brithday:nil tradeId:personModel_.tagId_ tradeName:personModel_.tagName_];
        }
            break;
        case zhiye_type:
        {
            if ([[MyCommon removeAllSpace:editorTextField_.text] isEqualToString:@""]) {
                [BaseUIViewController showAlertView:@"温馨提示" msg:@"请输入职业" btnTitle:@"知道了"];
                return;
            }
            
            [editCon_ saveUserInfo:[Manager getUserInfo].userId_ job:nil sex:nil pic:nil name:nil trade:[MyCommon removeSpaceAtHead:editorTextField_.text] company:nil nickname:nil signature:nil personIntro:nil expertIntro:nil hkaId:nil school:nil zym:nil rctypeId:@"1" regionStr:nil workAge:nil brithday:nil];
        }
            break;
        case touxian_type:
        {
            if ([[MyCommon removeAllSpace:editorTextField_.text] isEqualToString:@""]) {
                [BaseUIViewController showAlertView:@"温馨提示" msg:@"请输入头衔" btnTitle:@"知道了"];
                return;
            }
            [editCon_ saveUserInfo:[Manager getUserInfo].userId_ job:[MyCommon removeSpaceAtSides:editorTextField_.text] sex:nil pic:nil name:nil trade:nil company:nil nickname:nil signature:nil personIntro: nil expertIntro:nil hkaId:nil school:nil zym:nil rctypeId:@"1" regionStr:nil workAge:nil brithday:nil];
        }
            break;
        case gender_type:
        {
            if ([editorBtn_.titleLabel.text isEqualToString:@""] || editorBtn_.titleLabel.text == nil) {
                [BaseUIViewController showAlertView:@"温馨提示" msg:@"请选择性别" btnTitle:@"知道了"];
            }else{
                [editCon_ saveUserInfo:[Manager getUserInfo].userId_ job:nil sex:editorBtn_.titleLabel.text pic:nil name:nil trade:nil company:nil nickname:nil signature:nil personIntro: nil expertIntro:nil  hkaId:nil school:nil zym:nil rctypeId:@"1" regionStr:nil workAge:nil brithday:nil];
            }
        }
            break;
        case role_type:
        {
            if ([editorBtn_.titleLabel.text isEqualToString:@""] || editorBtn_.titleLabel.text == nil) {
                [BaseUIViewController showAlertView:@"温馨提示" msg:@"请选择求职身份" btnTitle:@"知道了"];
            }else{
                [editCon_ saveUserInfo:[Manager getUserInfo].userId_ job:nil sex:editorBtn_.titleLabel.text pic:nil name:nil trade:nil company:nil nickname:nil signature:nil personIntro: nil expertIntro:nil  hkaId:nil school:nil zym:nil rctypeId:@"1" regionStr:nil workAge:nil brithday:nil];
            }
        }
            break;
        case jobStatus_type:
        {
            if ([editorBtn_.titleLabel.text isEqualToString:@""] || editorBtn_.titleLabel.text == nil) {
                [BaseUIViewController showAlertView:@"温馨提示" msg:@"请选择求职状态" btnTitle:@"知道了"];
            }else{
                [editCon_ saveUserInfo:[Manager getUserInfo].userId_ job:nil sex:editorBtn_.titleLabel.text pic:nil name:nil trade:nil company:nil nickname:nil signature:nil personIntro: nil expertIntro:nil  hkaId:nil school:nil zym:nil rctypeId:@"1" regionStr:nil workAge:nil brithday:nil];
            }
        }
            break;

        default:
            break;
    }
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_SaveInfo:
        {
            Status_DataModal * dataModal = [dataArr objectAtIndex:0];
            if([dataModal.status_ isEqualToString:Success_Status]){
                switch (_editorType) {
                    case name_type:
                    {
                        User_DataModal *userModel = [Manager getUserInfo];
                       [CommonConfig setDBValueByKey:Config_Key_UserName value:[MyCommon removeAllSpace:editorTextField_.text]];
                        userModel.name_ = [MyCommon removeAllSpace:editorTextField_.text];
                        [Manager setUserInfo:userModel];
                        inModelOne_.userModel_.iname_ = [MyCommon removeAllSpace:editorTextField_.text];

                    }
                        break;
                    case age_type:
                    {
                        NSString *birthdayStr = editorBtn_.titleLabel.text;
                        NSDate *brithDate = [birthdayStr dateFormStringFormat:@"yyyy-MM-dd"];
                        NSTimeInterval dateDiff = [brithDate timeIntervalSinceNow];
                        int age = trunc(dateDiff/(60*60*24))/365;
                        inModelOne_.userModel_.age_ = [NSString stringWithFormat:@"%d",-age];
                        
                        inModelOne_.userModel_.bday_ = birthdayStr;
                    }
                        break;
                    case gender_type:
                    {
                        inModelOne_.userModel_.sex_ = editorBtn_.titleLabel.text;
                    }
                        break;
                    case role_type:
                    {
                        if ([editorBtn_.titleLabel.text isEqualToString:@"社会人才"]) {
                            inModelOne_.userModel_.role_ = @"0";
                        }else if ([editorBtn_.titleLabel.text isEqualToString:@"应届生"]){
                            inModelOne_.userModel_.role_ = @"1";
                        }
                    
                    }
                        break;
                    case jobStatus_type:
                    {
                        inModelOne_.userModel_.jobStatus = editorBtn_.titleLabel.text;
                    }
                        break;
                    case workage_type:
                    {
                        inModelOne_.userModel_.gznum_ = [MyCommon removeAllSpace:editorTextField_.text];
                    }
                        break;
                    case workAddr_type:
                    {
                        inModelOne_.userModel_.cityStr_ = editorBtn_.titleLabel.text;
                    }
                        break;
                    case trade_type:
                    {
                        User_DataModal *userModel = [Manager getUserInfo];
                        [CommonConfig setDBValueByKey:@"tradeName" value:personModel_.tagName_];
                        [CommonConfig setDBValueByKey:@"tradeId" value:personModel_.tagId_];
                        userModel.tradeName= personModel_.tagName_;
                        userModel.tradeId = personModel_.tagId_;
                        [Manager setUserInfo:userModel];
                        inModelOne_.userModel_.tradeName = editorBtn_.titleLabel.text;
                    }
                        break;
                    case zhiye_type:
                    {
                        [CommonConfig setDBValueByKey:@"jobNow" value:[MyCommon removeAllSpace:editorTextField_.text]];
                        User_DataModal *userModel = [Manager getUserInfo];
                        userModel.job_ = [MyCommon removeAllSpace:editorTextField_.text];
                        [Manager setUserInfo:userModel];
                        inModelOne_.userModel_.job_ = [MyCommon removeAllSpace:editorTextField_.text];
                    }
                        break;
                    case touxian_type:
                    {
                        inModelOne_.userModel_.zw_ = [MyCommon removeAllSpace:editorTextField_.text];
                    }
                        break;
                    default:
                        break;
                }
                [_delegate editorSuccess];
                [BaseUIViewController showAutoDismissSucessView:@"修改成功" msg:nil];
                //修改成功回调
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                [BaseUIViewController showAutoDismissFailView:@"修改失败" msg:@"请稍后再试"];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark 工作地址回调
-(void) chooseHotCity:(RegionCtl *)ctl city:(NSString *)city
{
    CondictionList_DataModal *dataModal = [[CondictionList_DataModal alloc] init];
    dataModal.str_ = city;
    dataModal.id_ = [CondictionPlaceCtl getRegionId:city];
    regionDataModal_ = dataModal;
    //地区
    if( !regionDataModal_ || regionDataModal_ == nil )
    {
        [editorBtn_ setTitle:@"请选择现工作地" forState:UIControlStateNormal];
    }else
    {
        NSString *str = [CondictionPlaceCtl getRegionDetailAddress:regionDataModal_.id_];
        [editorBtn_ setTitle:str forState:UIControlStateNormal];
    }
}

#pragma mark  出生年月回调
-(void) condictionChooseComplete:(PreBaseUIViewController *)ctl dataModal:(CondictionList_DataModal *)dataModal type:(CondictionChooseType)type
{
    switch ( type ) {
        case GetBirthDayDateType:
        {
            birthDayDataModal_ = dataModal;
            //出生日期
            if( !birthDayDataModal_ || birthDayDataModal_ == nil )
            {
                [editorBtn_ setTitle:@"请选择出生年月" forState:UIControlStateNormal];
            }else
            {
                [editorBtn_ setTitle:birthDayDataModal_.str_ forState:UIControlStateNormal];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark-  选择行业回调
-(void)updateTrade:(personTagModel *)personTagModel
{
    personModel_ = personTagModel;
    [editorBtn_ setTitle:personTagModel.tagName_ forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
