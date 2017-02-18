//
//  ELBecomeExpertTwoCtl.m
//  jobClient
//
//  Created by 一览iOS on 15/9/19.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELBecomeExpertTwoCtl.h"
//#import "PhotoBrowerCtl.h"
#import "ELBecomeExpertHelpCtl.h"
#import "ELBecomeExpertCtl.h"
#import "AlbumListCtl.h"
#import "ELBecomeExpertTypeExplainCtl.h"
#import "ELBecomeExpertThreeCtl.h"
#import "PrestigeInstructionCtl.h"
#import "ELBecomeExpertIntroCtl.h"

@interface ELBecomeExpertTwoCtl () <UITextViewDelegate>
{
    
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UIView *backViewTop;
    __weak IBOutlet UIView *backViewOne;
    __weak IBOutlet UILabel *lableOne;
    __weak IBOutlet UITextView *resumeTV;
    __weak IBOutlet UIButton *finishBtn;
    __weak IBOutlet UILabel *countOne;
    __weak IBOutlet UIButton *plannerBtn;
    __weak IBOutlet UIButton *brokerBtn;
    __weak IBOutlet UIButton *skillTutorBtn;
    __weak IBOutlet UIButton *typeExplainBtn;
    
    NSString *expertTypeStr;
    
    BOOL showKeyBoard;
    CGFloat keyboarfHeight;
    
    UIView *viewTF;
    UITextView *textTF;
    
    ELBecomeExpertThreeCtl *becomeExpertThreeCtl;

}
@end

@implementation ELBecomeExpertTwoCtl

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.navigationItem.title = @"申请成为行家";
    [self setNavTitle:@"申请成为行家"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    scrollView.userInteractionEnabled = YES;
    [scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoardOne)]];
    scrollView.contentSize = CGSizeMake(320,568);
    
    backViewTop.clipsToBounds = YES;
    backViewTop.layer.cornerRadius = 4.0;
    backViewOne.clipsToBounds = YES;
    backViewOne.layer.cornerRadius = 4.0;
    
    finishBtn.clipsToBounds = YES;
    finishBtn.layer.cornerRadius = 4.0;
    
    plannerBtn.clipsToBounds = YES;
    plannerBtn.layer.cornerRadius = 4.0;
    plannerBtn.layer.borderWidth = 0.5;
    plannerBtn.layer.borderColor = GRAYCOLOR.CGColor;
    
    brokerBtn.clipsToBounds = YES;
    brokerBtn.layer.cornerRadius = 4.0;
    brokerBtn.layer.borderWidth = 0.5;
    brokerBtn.layer.borderColor = GRAYCOLOR.CGColor;
    
    skillTutorBtn.clipsToBounds = YES;
    skillTutorBtn.layer.cornerRadius = 4.0;
    skillTutorBtn.layer.borderWidth = 0.5;
    skillTutorBtn.layer.borderColor = GRAYCOLOR.CGColor;

    expertTypeStr = @"";
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 632);
    
    if (_personIntro.length > 0)
    {
        resumeTV.text = _personIntro;
        lableOne.hidden = YES;
        [self textViewDidChange:resumeTV];
    }
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"button_question_hangjia"] forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0,0,25,40);
    [rightButton addTarget:self action:@selector(rightButtonRespone:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightNavigationItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -6;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightNavigationItem];
}

-(void)rightButtonRespone:(UIButton *)sender{
    ELBecomeExpertIntroCtl *ctl = [[ELBecomeExpertIntroCtl alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}

-(void)hideKeyBoardOne
{
    [resumeTV resignFirstResponder];
}

-(void)keyBoardShow:(NSNotification *)notification
{
    showKeyBoard = YES;
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyboarfHeight = keyboardRect.size.height;
    
    CGRect rect1 = [viewTF convertRect:textTF.frame toView:self.view];
    if (CGRectGetMaxY(rect1) > ([UIScreen mainScreen].bounds.size.height - keyboarfHeight - 64))
    {
        CGFloat height = (CGRectGetMaxY(rect1) - ([UIScreen mainScreen].bounds.size.height - keyboarfHeight - 64));
        scrollView.contentOffset = CGPointMake(0,height + scrollView.contentOffset.y);
    }
    scrollView.contentInset = UIEdgeInsetsMake(0,0,keyboarfHeight,0);
}

-(void)keyBoardHide:(NSNotification *)notification
{
    showKeyBoard = NO;
    scrollView.contentInset = UIEdgeInsetsZero;
}


#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    textTF = textView;
    UIView *view = textView.superview;
    CGRect rect1 = [view convertRect:textView.frame toView:self.view];
    viewTF = view;
    
    if (CGRectGetMaxY(rect1) > ([UIScreen mainScreen].bounds.size.height - keyboarfHeight - 64) && showKeyBoard)
    {
        CGFloat height = (CGRectGetMaxY(rect1) - ([UIScreen mainScreen].bounds.size.height - keyboarfHeight - 64));
        scrollView.contentOffset = CGPointMake(0,height + scrollView.contentOffset.y);
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView == resumeTV)
    {
        NSInteger length = textView.text.length;
        length = 1000 - length;
        countOne.text = [NSString stringWithFormat:@"%ld",(long)length];
        if (length <= 0) {
            countOne.text = @"0";
        }
        
        if (textView.text.length > 0) {
            lableOne.hidden = YES;
        }else{
            lableOne.hidden = NO;
            countOne.text = @"20~1000字";
        }

        NSString *lang = [textView.textInputMode primaryLanguage];
        if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
            UITextRange *selectedRange = [textView markedTextRange];
            //获取高亮部分
            UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
            if (!position) { // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
                if (resumeTV.text.length > 1000) {
                    resumeTV.text = [textView.text substringToIndex:1000];
                }
            }
        }else{
            if (resumeTV.text.length > 1000) {
                resumeTV.text = [resumeTV.text substringToIndex:1000];
            }
        }
    }
}

- (IBAction)btnRespone:(UIButton *)sender
{
    if (sender == finishBtn)
    {
        if ([expertTypeStr isEqualToString:@""]) {
            [BaseUIViewController showAlertView:nil msg:@"请选择行家类型" btnTitle:@"确定"];
            return;
        }
        
        if ([[resumeTV.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
        {
            [BaseUIViewController showAlertView:nil msg:@"请填写个人简介" btnTitle:@"确定"];
            return;
        }
        else if (resumeTV.text.length < 20)
        {
            [BaseUIViewController showAlertView:nil msg:@"请输入不少于20字的个人简介" btnTitle:@"确定"];
            return;
        }
        
//        if (!becomeExpertThreeCtl)
//        {
//            becomeExpertThreeCtl = [[ELBecomeExpertThreeCtl alloc] init];
//        }
//        becomeExpertThreeCtl.personName = _personName;
//        becomeExpertThreeCtl.goodPlace = _goodPlace;
//        becomeExpertThreeCtl.workTime = _workTime;
//        becomeExpertThreeCtl.phone = _phone;
//        becomeExpertThreeCtl.email = _email;
//        becomeExpertThreeCtl.nowPlace = _nowPlace;
//        becomeExpertThreeCtl.headerName = _headerName;
//        becomeExpertThreeCtl.shareImageUrl = shareImageUrl;
//        becomeExpertThreeCtl.resume = resumeTV.text;
//        becomeExpertThreeCtl.jobExperience = jobExperienceTV.text;
//        becomeExpertThreeCtl.edutionExerience = educatonTV.text;
//        becomeExpertThreeCtl.expertType = expertTypeStr;
//        
//        [self.navigationController pushViewController:becomeExpertThreeCtl animated:YES];
        NSString * userId = [Manager getUserInfo].userId_;
        if (![Manager shareMgr].haveLogin) {
            userId = @"";
        }
        NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
        [conditionDic setObject:userId forKey:@"person_id"];
        [conditionDic setObject:_personName forKey:@"person_iname"];
        [conditionDic setObject:_goodPlace forKey:@"good_at_tradeid"];
        [conditionDic setObject:_phone forKey:@"person_mobile"];
        [conditionDic setObject:_email forKey:@"person_email"];
        [conditionDic setObject:resumeTV.text forKey:@"intro"];
        [conditionDic setObject:expertTypeStr forKey:@"expert_type"];
        [conditionDic setObject:_companyName forKey:@"person_company"];
        [conditionDic setObject:_jobName forKey:@"person_job_now"];
        
        SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
        NSString * conditionDicStr = [jsonWriter stringWithObject:conditionDic];
        
        NSString *bodyMsg = [NSString stringWithFormat:@"insertArr=%@",conditionDicStr];
        NSString * function = @"addExpertApply";
        NSString * op = @"zd_ask_question_busi";
        [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
         {
             NSDictionary *dic = result;
             NSString *status = dic[@"status"];
             NSString *desc = dic[@"status_desc"];
             if ([status isEqualToString:@"OK"])
             {
                 [BaseUIViewController showAutoDismissSucessView:@"" msg:desc seconds:1.0];
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"ELBECOMEEXPERTSTATUSREFRESH" object:nil];
                 for (UIViewController *ctl in self.navigationController.viewControllers)
                 {
                     if ([ctl isKindOfClass:[ELBecomeExpertCtl class]])
                     {
                         [self.navigationController popToViewController:ctl animated:YES];
                         break;
                     }
                 }
             }
             else
             {
                 [BaseUIViewController showAutoDismissFailView:@"" msg:desc seconds:1.0];
             }
             
         } failure:^(NSURLSessionDataTask *operation, NSError *error)
         {
             [BaseUIViewController showAutoDismissFailView:@"" msg:@"申请失败，请稍后再试" seconds:1.0];
         }];
        
    }
}

- (IBAction)expertTypeBtnClick:(id)sender {
//    1职业发展导师,2职业经纪人,3专业技能导师
    if (sender == plannerBtn) {
        [plannerBtn setTitleColor:REDCOLOR forState:UIControlStateNormal];
        plannerBtn.layer.borderColor = REDCOLOR.CGColor;
        
        [brokerBtn setTitleColor:UIColorFromRGB(0xC8C8C8) forState:UIControlStateNormal];
        brokerBtn.layer.borderColor = UIColorFromRGB(0xC8C8C8).CGColor;
        
        [skillTutorBtn setTitleColor:UIColorFromRGB(0xC8C8C8) forState:UIControlStateNormal];
        skillTutorBtn.layer.borderColor = UIColorFromRGB(0xC8C8C8).CGColor;
        
        expertTypeStr = @"1";
    }
    else if (sender == brokerBtn)
    {
        [plannerBtn setTitleColor:UIColorFromRGB(0xC8C8C8) forState:UIControlStateNormal];
        plannerBtn.layer.borderColor = UIColorFromRGB(0xC8C8C8).CGColor;
        
        [brokerBtn setTitleColor:REDCOLOR forState:UIControlStateNormal];
        brokerBtn.layer.borderColor = REDCOLOR.CGColor;
        
        [skillTutorBtn setTitleColor:UIColorFromRGB(0xC8C8C8) forState:UIControlStateNormal];
        skillTutorBtn.layer.borderColor = UIColorFromRGB(0xC8C8C8).CGColor;
        
        expertTypeStr = @"2";
    }
    else if (sender == skillTutorBtn)
    {
        [plannerBtn setTitleColor:UIColorFromRGB(0xC8C8C8) forState:UIControlStateNormal];
        plannerBtn.layer.borderColor = UIColorFromRGB(0xC8C8C8).CGColor;
        
        [brokerBtn setTitleColor:UIColorFromRGB(0xC8C8C8) forState:UIControlStateNormal];
        brokerBtn.layer.borderColor = UIColorFromRGB(0xC8C8C8).CGColor;
        
        [skillTutorBtn setTitleColor:REDCOLOR forState:UIControlStateNormal];
        skillTutorBtn.layer.borderColor = REDCOLOR.CGColor;
        
        expertTypeStr = @"3";
    }
    else if (sender == typeExplainBtn)
    {
        ELBecomeExpertTypeExplainCtl *expertTypeExplainCtl = [[ELBecomeExpertTypeExplainCtl alloc] init];
        [self.navigationController pushViewController:expertTypeExplainCtl animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
