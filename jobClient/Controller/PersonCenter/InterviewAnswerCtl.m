//
//  InterviewAnswerCtl.m
//  jobClient
//
//  Created by 一览iOS on 14-11-5.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "InterviewAnswerCtl.h"

@interface InterviewAnswerCtl ()

@end

@implementation InterviewAnswerCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       rightNavBarStr_ = @"提交";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = @"问答专访";
    [self setNavTitle:@"问答专访"];
    
    // Do any additional setup after loading the view from its nib.
    answerTextv_.layer.borderWidth = 0.5;
    answerTextv_.layer.borderColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0].CGColor;
    [answerTextv_ setFont:FOURTEENFONT_CONTENT];
    [answerTextv_ setTextColor:GRAYCOLOR];
    [questLb_ setFont:FIFTEENFONT_TITLE];
    [questLb_ setTextColor:BLACKCOLOR];
    
    CGRect questLbRect = questLb_.frame;
    CGRect answerRect = answerTextv_.frame;
    
    questLbRect.size.width = ScreenWidth - 20;
    answerRect.size.width = ScreenWidth - 20;
    
    questLb_.frame = questLbRect;
    answerTextv_.frame = answerRect;
    
    [answerTextv_ setText:inModel_.answer_];
    [Common setLbByText:questLb_ text:inModel_.question_ font:FIFTEENFONT_TITLE];

    answerRect.origin.y = CGRectGetMaxY(questLb_.frame) + 8;
    
    [answerTextv_ setFrame:answerRect];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [answerTextv_ resignFirstResponder];
}

#pragma Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification
{
    if( !singleTapRecognizer_ )
        singleTapRecognizer_ = [MyCommon addTapGesture:self.scrollView_ target:self numberOfTap:1 sel:@selector(viewSingleTap:)];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [MyCommon removeTapGesture:self.scrollView_ ges:singleTapRecognizer_];
    singleTapRecognizer_ = nil;
}

//设置右按扭的属性
- (void)setRightBarBtnAtt
{
    [rightBarBtn_ setTitle:@"提交" forState:UIControlStateNormal];
    rightBarBtn_.layer.cornerRadius = 2.0;
    [rightBarBtn_ setBackgroundColor:[UIColor clearColor]];
    [rightBarBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBarBtn_ setFrame:CGRectMake(0, 0, 55, 26)];
    [rightBarBtn_.titleLabel setFont:FIFTEENFONT_TITLE];
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    inModel_ = dataModal;
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_AnswerInterview:
        {
            Status_DataModal *model = [dataArr objectAtIndex:0];
            if ([model.status_ isEqualToString:@"OK"]) {
                inModel_.answer_ = [MyCommon removeSpaceAtSides:answerTextv_.text];
                if (self.block) {
                    self.block();
                }
                [BaseUIViewController showAutoDismissSucessView:nil msg:@"回答成功" seconds:0.5];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [BaseUIViewController showAutoDismissFailView:nil msg:@"回答失败" seconds:0.5];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)rightBarBtnResponse:(id)sender
{
    if ([[MyCommon removeSpaceAtSides:answerTextv_.text] isEqualToString:@""]) {
        [BaseUIViewController showAlertView:nil msg:@"回答内容不能为空" btnTitle:@"确定"];
        return;
    }
    if (!answerCon_) {
        answerCon_ = [self getNewRequestCon:NO];
    }
    [answerCon_ answerInterviewQuestion:[Manager getUserInfo].userId_ questId:inModel_.id_ answerContent:[MyCommon removeSpaceAtSides:answerTextv_.text]];
}

- (void)updateCom:(RequestCon *)con
{
    [super updateCom:con];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
