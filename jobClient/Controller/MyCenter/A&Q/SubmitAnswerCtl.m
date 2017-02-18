//
//  SubmitAnswerCtl.m
//  Association
//
//  Created by 一览iOS on 14-4-7.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "SubmitAnswerCtl.h"

@interface SubmitAnswerCtl ()
{
    NSString * companyId_;
}

@end

@implementation SubmitAnswerCtl
@synthesize delegate_,currentFocusView_,type_;
-(id)init
{
    self = [super init];
    rightNavBarStr_ = @"提交";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    return self;
}

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
//    self.navigationItem.title = @"回答问题";
    [self setNavTitle:@"回答问题"];
    
    contentTx_.layer.cornerRadius = 4.0;
    contentTx_.layer.borderColor = [UIColor lightGrayColor].CGColor;
    contentTx_.layer.borderWidth = 1.0;
    contentTx_.delegate = self;
    
    scrollView_.delegate = self;
    
    [scrollView_ setContentSize:CGSizeMake(0, self.view.frame.size.height)];
    
    
    //设置代理
    for ( UIView *subView in [scrollView_ subviews] ) {
        if( [subView isKindOfClass:[UITextField class]] || [subView isKindOfClass:[UITextView class]] ){
            UITextField *tf = (UITextField *)subView;
            tf.delegate = self;
        }
    }

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateCom:(RequestCon *)con
{
    [super updateCom:con ];
    quizzerLb_.text = [NSString stringWithFormat:@"%@:",indataModal_.quizzerName_];
    float h = [Common setLbByText:questionLb_ text:indataModal_.questionTitle_ font:nil];
    
    CGRect rect = contentTx_.frame;
    rect.origin.y = questionLb_.frame.origin.y + h + 10;
    contentTx_.frame = rect;
    
    CGRect rect1 = tipsLb_.frame;
    rect1.origin.y = questionLb_.frame.origin.y + h + 10;
    tipsLb_.frame = rect1;
    
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    indataModal_ = dataModal;
    companyId_ = exParam;
    contentTx_.text = @"";
    [contentTx_ resignFirstResponder];
    [scrollView_ setContentOffset:CGPointMake(0, 0) animated:YES];
    [super beginLoad:dataModal exParam:exParam];
}

-(void)submitAnswer
{
    NSString *giveTextStr = contentTx_.text;
    giveTextStr = [giveTextStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    giveTextStr = [giveTextStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    giveTextStr = [giveTextStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if ([giveTextStr isEqualToString:@""]) {
        [BaseUIViewController showAlertView:@"提交失败" msg:@"答案内容为空" btnTitle:@"确定"];
        return;
    }
    if (type_ == 1) {
        [requestCon_ doHRAnswer:companyId_ questionId:indataModal_.questionId_ answererId:[Manager getUserInfo].userId_ content:contentTx_.text];
    }
    else
        [requestCon_ answerQuestion:[Manager getUserInfo].userId_  questionId:indataModal_.questionId_ content:contentTx_.text];
    
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon_ code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_AnswerQuestion:
        {
            Status_DataModal * dataModal = [dataArr objectAtIndex:0];
            [BaseUIViewController showAutoDismissAlertView:dataModal.des_ msg:@"" seconds:2.0];
            if ([dataModal.status_ isEqualToString:Success_Status]) {
                [self.navigationController popViewControllerAnimated:YES];
                [delegate_ submitOK];
            }
        }
            break;
        case Request_DoHRAnswer:
        {
            Status_DataModal * dataModal = [dataArr objectAtIndex:0];
            
            if ([dataModal.status_ isEqualToString:Success_Status]) {
                [self.navigationController popViewControllerAnimated:YES];
                [BaseUIViewController showAutoDismissAlertView:@"提交成功" msg:@"" seconds:2.0];
                [delegate_ submitOK];
            }
            else
            {
                [BaseUIViewController showAutoDismissAlertView:dataModal.des_ msg:@"" seconds:2.0];
            }
        }
        default:
            break;
    }
}

-(void)rightBarBtnResponse:(id)sender
{
    [self submitAnswer];
}

#pragma UIScrollViewDelegate
-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [currentFocusView_ resignFirstResponder];
}

#pragma UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    currentFocusView_ = textField;
    
    return YES;
}

#pragma UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    currentFocusView_ = textView;
    
    return YES;
}



#pragma Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    if( !singleTapRecognizer_ )
        singleTapRecognizer_ = [MyCommon addTapGesture:scrollView_ target:self numberOfTap:1 sel:@selector(viewSingleTap:)];
    tipsLb_.text = @"";
    NSDictionary *userInfo = [notification userInfo];
    
    //Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    CGFloat keyboardTop = keyboardRect.origin.y;
    
    float h = keyboardTop - self.view.bounds.origin.y;
    
    CGRect convertRect = [scrollView_ convertRect:currentFocusView_.frame fromView:[currentFocusView_ superview]];
    //convertRect.origin.y = convertRect.origin.y - scrollView_.contentOffset.y;
    
    //Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    if( convertRect.origin.y + convertRect.size.height + 10 > h ){
        //需要移动scrollView
        CGPoint point = scrollView_.contentOffset;
        point.y = convertRect.origin.y + convertRect.size.height + 10 - h;
        [scrollView_ setContentOffset:point animated:YES];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [MyCommon removeTapGesture:scrollView_ ges:singleTapRecognizer_];
    singleTapRecognizer_ = nil;
    if ([contentTx_.text length] == 0) {
        tipsLb_.text = @"我的见解...";
    }

    CGPoint point = scrollView_.contentOffset;
    [scrollView_ setContentSize:CGSizeMake(scrollView_.frame.size.width, scrollView_.frame.size.height+1)];
    if( point.y < 0 ){
        [scrollView_ setContentOffset:CGPointMake(0, 0) animated:YES];
    }else if( scrollView_.frame.size.height + point.y > scrollView_.contentSize.height ){
        if( scrollView_.frame.size.height > scrollView_.contentSize.height ){
            [scrollView_ setContentOffset:CGPointMake(0, 0) animated:YES];
        }else
            [scrollView_ setContentOffset:CGPointMake(0, scrollView_.contentSize.height - scrollView_.frame.size.height) animated:YES];
    }
}

//自己视图的单击事件
-(void) viewSingleTap:(id)sender
{
    [currentFocusView_ resignFirstResponder];
}

@end
