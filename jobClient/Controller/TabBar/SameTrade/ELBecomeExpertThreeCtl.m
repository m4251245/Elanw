//
//  ELBecomeExpertThreeCtl.m
//  jobClient
//
//  Created by 一览iOS on 15/10/27.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELBecomeExpertThreeCtl.h"
#import "ELBecomeExpertCtl.h"
#import "ELBecomeExpertHelpCtl.h"

@interface ELBecomeExpertThreeCtl () <UITextViewDelegate>
{
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UIView *backViewOne;
    __weak IBOutlet UIView *backViewTwo;
    __weak IBOutlet UILabel *countOne;
    __weak IBOutlet UILabel *countTwo;
    __weak IBOutlet UIButton *finishBtn;
    __weak IBOutlet UIButton *helpBtn;
    
    __weak IBOutlet UITextView *textViewOne;
    
    __weak IBOutlet UITextView *textViewTwo;
    
    __weak IBOutlet UILabel *lableOne;
    __weak IBOutlet UILabel *lableTwo;
    
    BOOL showKeyBoard;
    CGFloat keyboarfHeight;
    
    UIView *viewTF;
    UITextView *textTF;
    
    ELRequest *elRequest;
}
@end

@implementation ELBecomeExpertThreeCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.navigationItem.title = @"申请成为行家";
    [self setNavTitle:@"申请成为行家"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    scrollView.userInteractionEnabled = YES;
    [scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoardOne)]];
    backViewOne.clipsToBounds = YES;
    backViewOne.layer.cornerRadius = 4.0;
    backViewTwo.clipsToBounds = YES;
    backViewTwo.layer.cornerRadius = 4.0;
    finishBtn.clipsToBounds = YES;
    finishBtn.layer.cornerRadius = 4.0;
    
    textViewTwo.delegate = self;
    textViewOne.delegate = self;

}

-(void)hideKeyBoardOne
{
    [textViewOne resignFirstResponder];
    [textViewTwo resignFirstResponder];
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


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (textView == textViewOne)
    {
        lableOne.hidden = YES;
        if (textViewTwo.text.length > 0) {
            lableTwo.hidden = YES;
        }
        else
        {
            lableTwo.hidden = NO;
        }
    }
    else if (textView == textViewTwo)
    {
        lableTwo.hidden = YES;
        if (textViewOne.text.length > 0) {
            lableOne.hidden = YES;
        }
        else
        {
            lableOne.hidden = NO;
        }
    }
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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSInteger i = 0;
    if (textView == textViewOne) {
        i = 500;
    }
    else
    {
        i = 140;
    }
    if ((textView.text.length + text.length) >= i)
    {
        NSString *str = [NSString stringWithFormat:@"%@%@",textView.text,text];
        textView.text = [str substringWithRange:NSMakeRange(0,i)];
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView == textViewOne)
    {
        if (textView.text.length >= 500 || textView.text.length == 0)
        {
            countOne.text = @"500字";
            
        }
        else
        {
            countOne.text = [NSString stringWithFormat:@"%ld字",(long)textView.text.length];
        }
    }
    else if (textView == textViewTwo)
    {
        if (textView.text.length >= 140 || textView.text.length == 0) {
            countTwo.text = @"140字";
        }
        else
        {
            countTwo.text = [NSString stringWithFormat:@"%ld字",(long)textView.text.length];
        }
    }
}

-(void)btnResponse:(id)sender
{
    if (sender == finishBtn)
    {
        if([[textViewTwo.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
        {
            [BaseUIViewController showAlertView:nil msg:@"请填写申请理由" btnTitle:@"确定"];
            return;
        }
        
        NSString * userId = [Manager getUserInfo].userId_;
        if (![Manager shareMgr].haveLogin) {
            userId = @"";
        }
        NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
        [conditionDic setObject:userId forKey:@"person_id"];
        [conditionDic setObject:_personName forKey:@"person_iname"];
        [conditionDic setObject:_goodPlace forKey:@"good_at_tradeid"];
        [conditionDic setObject:_workTime forKey:@"person_gznum"];
        [conditionDic setObject:_phone forKey:@"person_mobile"];
        [conditionDic setObject:_email forKey:@"person_email"];
        [conditionDic setObject:_nowPlace forKey:@"regionid"];
        [conditionDic setObject:_shareImageUrl forKey:@"zd_background"];
        [conditionDic setObject:_resume forKey:@"intro"];
        [conditionDic setObject:_expertType forKey:@"expert_type"];
        [conditionDic setObject:_jobExperience forKey:@"zyjl"];
        [conditionDic setObject:_headerName forKey:@"person_zw"];
        [conditionDic setObject:textViewTwo.text forKey:@"reason"];
        if (_edutionExerience.length > 0) {
            [conditionDic setObject:_edutionExerience forKey:@"jyjl"];
        }
        if(textViewOne.text.length > 0)
        {
            [conditionDic setObject:textViewOne.text forKey:@"achievement"];
        }
        
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
                 for (UIViewController *ctl in self.navigationController.viewControllers)
                 {
                     if ([ctl isKindOfClass:[ELBecomeExpertCtl class]])
                     {
                         [self.navigationController popToViewController:ctl animated:YES];
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
    else if (sender == helpBtn)
    {
        ELBecomeExpertHelpCtl *ctl = [[ELBecomeExpertHelpCtl alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
