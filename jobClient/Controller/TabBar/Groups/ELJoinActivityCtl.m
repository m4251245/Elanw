//
//  ELJoinActivityCtl.m
//  jobClient
//
//  Created by 一览iOS on 15/9/17.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELJoinActivityCtl.h"
#import "ELActivitySuccessAlertView.h"
#import "User_DataModal.h"

@interface ELJoinActivityCtl () <UITextFieldDelegate>
{
    __weak IBOutlet UIView *backView;
    
    __weak IBOutlet UIButton *deleteBtn;
    
    __weak IBOutlet UIButton *joinBtn;
    
    __weak IBOutlet UIView *centerView;
    IBOutlet UIView *remarkView;
    
    IBOutlet UIView *nameView;
    IBOutlet UIView *phoneView;
    
    IBOutlet UIView *companyView;
    
    IBOutlet UIView *groupView;
    IBOutlet UIView *jobView;
    
    IBOutlet UIView *emailView;
    
    NSMutableArray *arrTF;
    
    CGFloat keyboarfHeight;
    BOOL showKeyBoard;
    UIView *viewTF;
    UITextField *textTF;
    ELRequest *elrequest;
    IBOutlet UILabel *groupNameLable;
    
}
@end

@implementation ELJoinActivityCtl

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    centerView.layer.cornerRadius = 4.0;
    joinBtn.clipsToBounds = YES;
    joinBtn.layer.cornerRadius = 3.0;
    
    [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoardTextField)]];
    
    [centerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoardTextField)]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
        arrTF = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)hideKeyBoardTextField
{
    [_userNameTF resignFirstResponder];
    [_phoneTF resignFirstResponder];
    [_companyTF resignFirstResponder];
    [_groupTF resignFirstResponder];
    [_jobTF resignFirstResponder];
    [_emailTF resignFirstResponder];
    [_summaryTV resignFirstResponder];
    [UIView animateWithDuration:0.26 animations:^{
        self.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self creatViewWithArr:_arrList];
}

-(void)creatViewWithArr:(NSArray *)arrData
{
    [arrTF removeAllObjects];
    
    _userNameTF.text = @"";
    _phoneTF.text = @"";
    _companyTF.text = @"";
    _groupTF.text = @"";
    _jobTF.text = @"";
    _emailTF.text = @"";
    _summaryTV.text = @"";
    
    [nameView removeFromSuperview];
    [phoneView removeFromSuperview];
    [companyView removeFromSuperview];
    [groupView removeFromSuperview];
    [jobView removeFromSuperview];
    [emailView removeFromSuperview];
    [remarkView removeFromSuperview];
    
    CGFloat height = 0;
    CGRect frameOne;
    
    User_DataModal *userModal = [Manager getUserInfo];
    
    if([arrData containsObject:@"gaae_name"])
    {
        frameOne = nameView.frame;
        frameOne.origin.y = height;
        nameView.frame = frameOne;
        height += 40;
        [backView addSubview:nameView];
        [arrTF addObject:_userNameTF];
        _userNameTF.delegate = self;
        _userNameTF.returnKeyType = UIReturnKeyNext;
        if (userModal.name_.length > 0) {
            _userNameTF.text = userModal.name_;
        }else if (userModal.nickname_.length > 0){
            _userNameTF.text = userModal.nickname_;
        }
    }

    if([arrData containsObject:@"gaae_contacts"])
    {
        frameOne = phoneView.frame;
        frameOne.origin.y = height;
        phoneView.frame = frameOne;
        height += 40;
        [backView addSubview:phoneView];
        [arrTF addObject:_phoneTF];
        _phoneTF.delegate = self;
        _phoneTF.returnKeyType = UIReturnKeyNext;
        if (userModal.mobile_.length > 0) {
            _phoneTF.text = userModal.mobile_;
        }
    }

    if([arrData containsObject:@"company"])
    {
        frameOne = companyView.frame;
        frameOne.origin.y = height;
        companyView.frame = frameOne;
        height += 40;
        [backView addSubview:companyView];
        [arrTF addObject:_companyTF];
        _companyTF.delegate = self;
        _companyTF.returnKeyType = UIReturnKeyNext;
    }

    if([arrData containsObject:@"group"])
    {
        frameOne = groupView.frame;
        frameOne.origin.y = height;
        groupView.frame = frameOne;
        height += 40;
        [backView addSubview:groupView];
        [arrTF addObject:_groupTF];
        _groupTF.delegate = self;
        _groupTF.returnKeyType = UIReturnKeyNext;
    }

    if([arrData containsObject:@"jobs"])
    {
        frameOne = jobView.frame;
        frameOne.origin.y = height;
        jobView.frame = frameOne;
        height += 40;
        [backView addSubview:jobView];
        [arrTF addObject:_jobTF];
        _jobTF.delegate = self;
        _jobTF.returnKeyType = UIReturnKeyNext;
    }
 
    if([arrData containsObject:@"email"])
    {
        frameOne = emailView.frame;
        frameOne.origin.y = height;
        emailView.frame = frameOne;
        height += 40;
        [backView addSubview:emailView];
        [arrTF addObject:_emailTF];
        _emailTF.delegate = self;
        _emailTF.returnKeyType = UIReturnKeyNext;
    }

    if([arrData containsObject:@"remark"])
    {
        frameOne = remarkView.frame;
        frameOne.origin.y = height;
        remarkView.frame = frameOne;
        height += 40;
        [backView addSubview:remarkView];
        [arrTF addObject:_summaryTV];
        _summaryTV.delegate = self;
        _summaryTV.returnKeyType = UIReturnKeyNext;
    }
    
    if([_myDataModal_._activity_info.is_create_group isEqualToString:@"1"]){
        [backView addSubview:groupNameLable];
        groupNameLable.frame = CGRectMake(18,height+8,230,0);
        groupNameLable.text = [NSString stringWithFormat: @"报名成功后，默认加入“%@”",_myDataModal_._group_info.group_name];
        [groupNameLable sizeToFit];
        if(_myDataModal_._group_info.group_name && ![_myDataModal_._group_info.group_name isEqualToString:@""]){
            height += (groupNameLable.frame.size.height+18);
        }
    }
    
    CGRect frame = backView.frame;
    frame.size.height = height;
    backView.frame = frame;
    
    frame = centerView.frame;
    frame.size.height = 100 + backView.frame.size.height;
    centerView.frame = frame;
    
    frame = joinBtn.frame;
    frame.origin.y = CGRectGetMaxY(backView.frame) + 8;
    joinBtn.frame = frame;
    centerView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
    UITextField *field = [arrTF lastObject];
    field.returnKeyType = UIReturnKeyDone;
    
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
    if ([arrTF lastObject] == textField)
    {
        [self btnTextFieldRespone:joinBtn];
    }
    return NO;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textTF = textField;
    UIView *view = textField.superview;
    CGRect rect1 = [view convertRect:textField.frame toView:self.view];
    viewTF = view;
    
    if (CGRectGetMaxY(rect1) > ([UIScreen mainScreen].bounds.size.height - keyboarfHeight) && showKeyBoard)
    {
        CGFloat height = (CGRectGetMaxY(rect1) - ([UIScreen mainScreen].bounds.size.height - keyboarfHeight));
        self.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2 - height);
    }
    return YES;
}

-(void)showCtlView
{
    self.view.frame = [UIScreen mainScreen].bounds;
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.view];
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:self.view];
}

-(void)hideCtlView
{
    [_joinDelagete keyBoardNotification];
    [self.view removeFromSuperview];
}

-(void)keyBoardShow:(NSNotification *)notification
{
    showKeyBoard = YES;
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyboarfHeight = keyboardRect.size.height;
    
    CGRect rect1 = [viewTF convertRect:textTF.frame toView:self.view];
    if (CGRectGetMaxY(rect1) > ([UIScreen mainScreen].bounds.size.height - keyboarfHeight))
    {
        CGFloat height = (CGRectGetMaxY(rect1) - ([UIScreen mainScreen].bounds.size.height - keyboarfHeight));
        [UIView animateWithDuration:0.26 animations:^{
                self.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2 - height);
        }];
    }
}

-(void)keyBoardHide:(NSNotification *)notification
{
    self.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2 );
    showKeyBoard = NO;
}
- (IBAction)btnTextFieldRespone:(UIButton *)sender
{
    [self hideKeyBoardTextField];
    if (sender == deleteBtn) {
        [self hideCtlView];
    }
    else if (sender == joinBtn)
    {
        if(![self validForm]){
            return;
        }
        _userNameTF.text = [MyCommon removeAllSpace:_userNameTF.text];
        _phoneTF.text = [MyCommon removeAllSpace:_phoneTF.text];
        
        NSString * userId = [Manager getUserInfo].userId_;
        if (![Manager shareMgr].haveLogin) {
            userId = @"";
        }
        NSMutableDictionary *conDic = [[NSMutableDictionary alloc] init];
        SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
        NSString *conDicStr = [jsonWriter stringWithObject:conDic];
        
        NSString * bodyMsg = [NSString stringWithFormat:@"article_id=%@&person_id=%@&person_iname=%@&person_phone=%@&person_remark=%@&person_company=%@&person_group=%@&person_jobs=%@&person_email=%@&conditionArr=%@",_myDataModal_.id_,userId,_userNameTF.text,_phoneTF.text,_summaryTV.text,_companyTF.text,_groupTF.text,_jobTF.text,_emailTF.text,conDicStr];
        NSString * function = @"addActivityEnroll";
        NSString * op = @"salarycheck_all_busi";
        

        [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
         {
             NSDictionary *dic = result;
             NSString *status = [dic objectForKey:@"status"];
             NSString *desc = [dic objectForKey:@"status_desc"];
             //NSString *code = [dic objectForKey:@"code"];
             
             if ([status isEqualToString:Success_Status])
             {
                 [_joinDelagete publishSuccessRefresh];
                 Article_DataModal *modal = [[Article_DataModal alloc] init];
                 modal.id_ = _myDataModal_.id_;
                 modal.thum_ = _myDataModal_.thumb;
                 modal.summary_ = _myDataModal_.summary;
                 modal.title_ = _myDataModal_.title;
                 modal._activity_info = [[ELActivityModel alloc] init];
                 modal._activity_info.intro = _myDataModal_._activity_info.intro;
                 if([_myDataModal_._activity_info.is_create_group isEqualToString:@"1"]){
                     [[ELActivitySuccessAlertView activitySuccessView] showWithGroupJoinSuccessArticleModal:modal];
                 }else{
                     [[ELActivitySuccessAlertView activitySuccessView] showWithJoinSuccessArticleModal:modal];
                 }
                // [BaseUIViewController showAutoDismissAlertView:nil msg:desc seconds:1.0f];
                 [self hideCtlView];
             }
             else
             {
                 [BaseUIViewController showAutoDismissFailView:nil msg:desc seconds:1.0f];
             }
             
         } failure:^(NSURLSessionDataTask *operation, NSError *error)
         {
            [BaseUIViewController showAutoDismissFailView:nil msg:@"报名失败，请稍后再试" seconds:1.0f];
         }];
    }
}

- (BOOL)validForm
{
    if ([[_userNameTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] && [_arrList containsObject:@"gaae_name"]) {
        [BaseUIViewController showAlertView:nil msg:@"姓名不能为空" btnTitle:@"确定"];
        return NO;
    }else if ([[_phoneTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] && [_arrList containsObject:@"gaae_contacts"]){
        [BaseUIViewController showAlertView:nil msg:@"电话不能为空" btnTitle:@"确定"];
        return NO;
    }else if ([[_companyTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] && [_arrList containsObject:@"company"]){
        [BaseUIViewController showAlertView:nil msg:@"公司不能为空" btnTitle:@"确定"];
        return NO;
    }
    else if ([[_groupTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] && [_arrList containsObject:@"group"]){
        [BaseUIViewController showAlertView:nil msg:@"部门不能为空" btnTitle:@"确定"];
        return NO;
    }
    else if ([[_jobTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] && [_arrList containsObject:@"jobs"]){
        [BaseUIViewController showAlertView:nil msg:@"职务不能为空" btnTitle:@"确定"];
        return NO;
    }
    else if ([[_emailTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] && [_arrList containsObject:@"email"]){
        [BaseUIViewController showAlertView:nil msg:@"邮箱不能为空" btnTitle:@"确定"];
        return NO;
    }
    else if ([[_summaryTV.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] && [_arrList containsObject:@"remark"]){
        [BaseUIViewController showAlertView:nil msg:@"活动发起人希望您填写留言，多说两句吧~" btnTitle:@"确定"];
        return NO;
    }
    
    if (![MyCommon isMobile:_phoneTF.text] && [_arrList containsObject:@"gaae_contacts"])
    {
        [BaseUIViewController showAlertView:nil msg:@"输入的手机号码有误" btnTitle:@"确定"];
        return NO;
    }
    if (![MyCommon isValidateEmail:_emailTF.text] && [_arrList containsObject:@"email"]) {
        [BaseUIViewController showAlertView:nil msg:@"输入的邮箱有误" btnTitle:@"确定"];
        return NO;
    }
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
