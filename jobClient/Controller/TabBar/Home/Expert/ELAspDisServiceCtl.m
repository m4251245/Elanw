//
//  ELAspDisServiceCtl.m
//  jobClient
//
//  Created by YL1001 on 15/9/4.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELAspDisServiceCtl.h"
#import "PayCtl.h"
#import "PrestigeInstructionCtl.h"
#import "SBJson.h"
#import "ELMyAspectantDiscussCtl.h"

@interface ELAspDisServiceCtl ()
{
    BOOL isAgree;
    UIView *maskView_;
    
    IBOutlet UIButton *fingerpostBtn;
    
    Expert_DataModal *expertModal;
    ELAspectantDiscuss_Modal *courseModal;
    RequestCon *payRequest;
    RequestCon *courseRequest;
    
    CGFloat questionTextLength;
    CGFloat infoTextLength;
    
    NSString *filePath;
    NSMutableArray *btnArray;
    NSMutableArray *courseArr;
    
    NSString *selectedCourse;
    NSString *selectedCoursePrice;

    IBOutlet NSLayoutConstraint *_serviceViewAutoHeight;
}
@end

@implementation ELAspDisServiceCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavTitle:@"约谈"];
    self.scrollView_.contentSize = CGSizeMake(320, [UIScreen mainScreen].bounds.size.height);
    isAgree = NO;
    
    personInfoBgView.layer.cornerRadius = 8;
    personInfoBgView.layer.masksToBounds = YES;
    
    serviceBgView.layer.cornerRadius = 8;
    serviceBgView.layer.masksToBounds = YES;
    
    alertView.layer.cornerRadius = 8;
    alertView.layer.masksToBounds = YES;
    
    [phoneNum setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    
    if (!_isShowCourse)
    {
        serviceBgView.hidden = YES;
        _serviceViewAutoHeight.constant = 0;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

//获取课程列表
- (void)getCourseList:(NSArray *)dataArray
{
    CGFloat labelMaxY = 38;
    btnArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < dataArray.count; i++) {
        
        UILabel *courseLb = [[UILabel alloc] init];
        courseLb.font = THIRTEENFONT_CONTENT;
        courseLb.frame = CGRectMake(32, labelMaxY, 264, 21);
        courseLb.numberOfLines = 0;
        courseLb.textColor = UIColorFromRGB(0x999999);
        
        ELAspectantDiscuss_Modal *datamodal = [dataArray objectAtIndex:i];
        courseLb.text = datamodal.course_title;
        [courseLb sizeToFit];
        labelMaxY = CGRectGetMaxY(courseLb.frame) + 15;
        [serviceBgView addSubview:courseLb];
        
        UIButton *selectBtn = [[UIButton alloc] init];
        //2 为两个课程间的间隔，
        selectBtn.frame = CGRectMake(8, courseLb.frame.origin.y, 14, 14);
        selectBtn.tag = 100 + i;
        [selectBtn setImage:[UIImage imageNamed:@"cb_uncheck.png"] forState:UIControlStateNormal];
        [selectBtn addTarget:self action:@selector(selectCourse:) forControlEvents:UIControlEventTouchUpInside];
        selectBtn.backgroundColor = [UIColor grayColor];
        [serviceBgView addSubview:selectBtn];
        [btnArray addObject:selectBtn];
        
        if (dataArray.count == 1) {
            [selectBtn setImage:[UIImage imageNamed:@"cb_checked.png"] forState:UIControlStateNormal];
            selectedCourse = datamodal.course_id;
            selectedCoursePrice = datamodal.course_price;
        }
    }
    
    _serviceViewAutoHeight.constant = labelMaxY;
}

- (void)selectCourse:(UIButton *)sender
{
    for (UIButton *btn in btnArray) {
        [btn setImage:[UIImage imageNamed:@"cb_uncheck.png"] forState:UIControlStateNormal];
    }
    [sender setImage:[UIImage imageNamed:@"cb_checked.png"] forState:UIControlStateNormal];
    ELAspectantDiscuss_Modal *datamodal = [courseArr objectAtIndex:sender.tag-100];

    selectedCourse = datamodal.course_id;
    selectedCoursePrice = datamodal.course_price;
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    if (_isShowCourse) {//显示课程
        expertModal = dataModal;
        if (!courseRequest) {
            courseRequest = [self getNewRequestCon:NO];
        }
        [courseRequest getInterViewCourseListWithPersonId:expertModal.id_];
    }
    else
    {//不显示课程
        courseModal = dataModal;
    }
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_getCourseList:
        {
            if (_isShowCourse == YES) {
                courseArr = [[NSMutableArray alloc] initWithArray:dataArr];
                [self getCourseList:dataArr];
            }
            else
            {
                serviceBgView.hidden = YES;
                _serviceViewAutoHeight.constant = 0;
            }
        }
            break;

        default:
            break;
    }
}

- (void)btnResponse:(id)sender
{
    if (sender == agreeBtn) {
        if (isAgree) {
            [agreeBtn setImage:[UIImage imageNamed:@"cb_checked.png"] forState:UIControlStateNormal];
            isAgree = NO;
        }
        else
        {
            [agreeBtn setImage:[UIImage imageNamed:@"cb_uncheck.png"] forState:UIControlStateNormal];
            isAgree = YES;
        }
    }
    else if (sender == rulesBtn)
    {
        PrestigeInstructionCtl *instructionCtl = [[PrestigeInstructionCtl alloc] init];
        instructionCtl.type = @"1";
        [self.navigationController pushViewController:instructionCtl animated:YES];
    }
    else if (sender == fingerpostBtn)
    {
        PrestigeInstructionCtl *instructionCtl = [[PrestigeInstructionCtl alloc] init];
        instructionCtl.type = @"interViewFingerpost";
        [self.navigationController pushViewController:instructionCtl animated:YES];
    }
    else if (sender == discussBtn)
    {
        if (![questionTV.text isEqualToString:@""] && ![personInfoTV.text isEqualToString:@""] && ![phoneNum.text isEqualToString:@""]) {
            
            NSString *phoneN = [phoneNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if(![phoneN isMobileNumValid]){
                [BaseUIViewController showAutoDisappearAlertView:@"" msg:@"请输入正确的手机号码" seconds:1.0];
            }
            else
            {
                if (questionTextLength < 20 || infoTextLength < 20) {
                    [BaseUIViewController showAutoDisappearAlertView:@"" msg:@"问题描述，个人情况最少20字" seconds:1.0];
                }
                else if (questionTextLength > 500 || infoTextLength > 500)
                {
                    [BaseUIViewController showAutoDisappearAlertView:@"" msg:@"问题描述，个人情况最多500字" seconds:1.0];
                }
                else
                {
                    if (isAgree == NO) {
                        costMoneyLb.text = expertModal.aspDiscuss.course_price;
                        
                        if (!payRequest) {
                            payRequest = [self getNewRequestCon:NO];
                        }
                        
                        if (_isShowCourse) {//显示课程
                            if (selectedCourse == nil) {
                                [BaseUIViewController showAutoDisappearAlertView:@"" msg:@"请选择课程" seconds:1.0];
                                return;
                            }
                            [self CreateTheInterviewRecordWithPersonId:[Manager getUserInfo].userId_ hangJiaId:expertModal.id_ courseId:selectedCourse mobile:phoneNum.text question:questionTV.text intro:personInfoTV.text];
                            [BaseUIViewController showLoadView:YES content:@"正在加载" view:self.view];
                        }
                        else
                        {//不显示课程
                            [self CreateTheInterviewRecordWithPersonId:[Manager getUserInfo].userId_ hangJiaId:courseModal.BYTZ_Id courseId:courseModal.course_id mobile:phoneNum.text question:questionTV.text intro:personInfoTV.text];
                            [BaseUIViewController showLoadView:YES content:@"正在加载" view:self.view];
                        }
                        
                    }
                    else
                    {
                        [BaseUIViewController showAlertView:nil msg:@"请选择用户协议" btnTitle:@"确定"];
                    }

                }
            }
        }
        else
        {
            if ([phoneNum.text isEqualToString:@""])
            {
                [BaseUIViewController showAutoDisappearAlertView:nil msg:@"手机号码不能为空" seconds:1.0];
                return;
            }
            
            if ([questionTV.text isEqualToString:@""]) {
                [BaseUIViewController showAutoDisappearAlertView:nil msg:@"问题描述不能为空" seconds:1.0];
                return;
            }
            
            if ([personInfoTV.text isEqualToString:@""])
            {
                [BaseUIViewController showAutoDisappearAlertView:nil msg:@"请填写你的情况" seconds:1.0];
                return;
            }
        }
    }
    else if (sender == cancelBtn)
    {
        [self maskClicked];
    }
    else if (sender == sureBtn)
    {
        [self maskClicked];
        [self goPay];
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    NSString *str;
    if (textView == questionTV) {
        str = textView.text;
        questionTextLength = str.length;
        if ((str.length > 1 || ![str isEqualToString:@""])) {
            
            tipsLb1.text = @"";
        }
        else
        {
            tipsLb1.text = @"20-500字";
        }
    }
    else if (textView == personInfoTV)
    {
        str = textView.text;
        infoTextLength = str.length;
        if ((str.length > 1 || ![str isEqualToString:@""])) {
            
            tipsLb2.text = @"";
        }
        else
        {
            tipsLb2.text = @"描述你的个人信息，倾向的约谈方式(线上或线下)，想要约谈的时间地点等，便于行家更好地进行排期（20-500字）";
        }
    }
    
}

#pragma mark - UITextFiledDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == phoneNum) {
        NSUInteger lengthOfString = string.length;
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {//只允许数字输入
            unichar character = [string characterAtIndex:loopIndex];
            if (character < 48) return NO; // 48 unichar for 0
            if (character > 57) return NO; // 57 unichar for 9
        }
        // Check for total length
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if (proposedNewLength > 11) return NO;//限制长度
    }
    
    return YES;
}

#pragma mark - 发起约谈请求
- (void)CreateTheInterviewRecordWithPersonId:(NSString *)personId hangJiaId:(NSString *)hangJiaId courseId:(NSString *)courseId mobile:(NSString *)mobile question:(NSString *)question intro:(NSString *)intro
{
    NSString *op = @"yuetan_record_busi";
    NSString *function = @"addYuetan";
    
    NSMutableDictionary *yuetanInfoDic = [[NSMutableDictionary alloc] init];
    [yuetanInfoDic setValue:mobile forKey:@"yuetan_mobile"];
    [yuetanInfoDic setValue:question forKey:@"yuetan_question"];
    [yuetanInfoDic setValue:intro forKey:@"yuetan_intro"];
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setValue:@"" forKey:@"description"];
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *yuetanInfoStr = [jsonWriter stringWithObject:yuetanInfoDic];
    NSString *conditionStr = [jsonWriter stringWithObject:conditionDic];
    
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&hangjia_id=%@&course_id=%@&yuetanInfoArr=%@&conditionArr=%@",personId, hangJiaId, courseId, yuetanInfoStr, conditionStr];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result){
        
        NSDictionary *dic = result;
        Status_DataModal *statusModal = [[Status_DataModal alloc] init];
        statusModal.status_ = dic[@"status"];
        statusModal.code_ = dic[@"code"];
        statusModal.status_desc = dic[@"status_desc"];
        if ([statusModal.code_ isEqualToString:@"200"]) {
            ELMyAspectantDiscussCtl *ctl = [[ELMyAspectantDiscussCtl alloc] init];
            [ctl beginLoad:nil exParam:nil];
            [self.navigationController pushViewController:ctl animated:YES];
            
        }
        else
        {
            [BaseUIViewController showAutoDismissFailView:@"" msg:statusModal.status_desc seconds:1.5];
        }
        [BaseUIViewController showLoadView:NO content:nil view:nil];
        
    }failure:^(NSURLSessionDataTask *operation, NSError *error){
        [BaseUIViewController showLoadView:NO content:nil view:nil];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    singleTapRecognizer_ = nil;
    
    CGPoint point = self.scrollView_.contentOffset;
    if( point.y < 0 ){
        [self.scrollView_ setContentOffset:CGPointMake(0, 0) animated:YES];
    }else if( self.scrollView_.frame.size.height + point.y > self.scrollView_.contentSize.height ){
        if( self.scrollView_.frame.size.height > self.scrollView_.contentSize.height ){
            [self.scrollView_ setContentOffset:CGPointMake(0, 0) animated:YES];
        }else
            [self.scrollView_ setContentOffset:CGPointMake(0, self.scrollView_.contentSize.height - self.scrollView_.frame.size.height) animated:YES];
    }
    
    CGRect frame = self.toolbarHolder.frame;
    frame.origin.y = self.view.frame.size.height;
    self.toolbarHolder.frame = frame;
}

#pragma mark 显示AlertView
- (void)showAlertView
{
    if (!maskView_) {
        maskView_ = [[UIView alloc]initWithFrame:[[UIApplication sharedApplication] keyWindow].bounds];
        maskView_.backgroundColor = [UIColor blackColor];
        maskView_.alpha = 0.0;
        [MyCommon addTapGesture:maskView_ target:self numberOfTap:1 sel:@selector(maskClicked)];
    }
    
    CGRect frame = CGRectMake(30, 600, 260, 147);
    alertView.frame = frame;
    maskView_.frame = [[UIApplication sharedApplication] keyWindow].bounds;
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:maskView_];
    [[[UIApplication sharedApplication] keyWindow] addSubview:alertView];
    
    [UIView animateWithDuration:0.3 animations:^{
        maskView_.alpha = 0.7;
        alertView.frame = CGRectMake(30, ([UIScreen mainScreen].bounds.size.height-147)/2, 260, 147);
    }];
}

#pragma mark 隐藏WithdrawBgView
- (void)maskClicked
{
    [UIView animateWithDuration:0.3 animations:^{
        maskView_.alpha = 0.0;
        alertView.frame = CGRectMake(30, 480, 260, 147);
        
    } completion:^(BOOL finished) {
        [maskView_ removeFromSuperview];
        [alertView removeFromSuperview];
    }];
}

- (void)goPay
{
    PayCtl *payctl = [[PayCtl alloc] init];
    [Manager shareMgr].payType = PayTypeDiscuss;
    payctl.order = _payOrder;
    [payctl beginLoad:nil exParam:nil];
    [self.navigationController pushViewController:payctl animated:YES];
}



@end
