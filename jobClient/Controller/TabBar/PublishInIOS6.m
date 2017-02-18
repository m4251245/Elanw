//
//  PublishInIOS6.m
//  jobClient
//
//  Created by YL1001 on 14-8-18.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "PublishInIOS6.h"

@interface PublishInIOS6 ()

@end

@implementation PublishInIOS6
@synthesize delegate_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       rightNavBarStr_ = @"完成"; 
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = @"添加内容";
    [self setNavTitle:@"添加内容"];
    
    contentTx_.delegate = self;
    contentTx_.placeholder = @"请输入内容";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    contentTx_.text = dataModal;
    contentTx_.placeholder = @"请输入内容";
}



-(void)rightBarBtnResponse:(id)sender
{
    [contentTx_ resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
    [delegate_ finishAddContent:contentTx_.text];
}

-(void)backBarBtnResponse:(id)sender
{
    [contentTx_ resignFirstResponder];
    [super backBarBtnResponse:sender];
    [delegate_ finishAddContent:contentTx_.text];
}


#pragma Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    if( !singleTapRecognizer_ )
        singleTapRecognizer_ = [MyCommon addTapGesture:self.scrollView_ target:self numberOfTap:1 sel:@selector(viewSingleTap:)];
    
    NSDictionary *userInfo = [notification userInfo];
    
    //Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    CGFloat keyboardTop = keyboardRect.origin.y;
    
    float h = keyboardTop - self.view.bounds.origin.y;
    
    CGRect convertRect = [self.scrollView_ convertRect:self.currentFocusView_.frame fromView:[self.currentFocusView_ superview]];
    //convertRect.origin.y = convertRect.origin.y - scrollView_.contentOffset.y;
    
    //Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    if( convertRect.origin.y + convertRect.size.height  > h ){
        //需要移动scrollView
        CGPoint point = self.scrollView_.contentOffset;
        point.y = convertRect.origin.y + convertRect.size.height - h;
        [self.scrollView_ setContentOffset:point animated:YES];
    }
    

    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [MyCommon removeTapGesture:self.scrollView_ ges:singleTapRecognizer_];
    singleTapRecognizer_ = nil;
    
    CGPoint point = self.scrollView_.contentOffset;
    [self.scrollView_ setContentSize:CGSizeMake(self.scrollView_.frame.size.width, self.scrollView_.frame.size.height+1)];
    if( point.y < 0 ){
        [self.scrollView_ setContentOffset:CGPointMake(0, 0) animated:YES];
    }else if( self.scrollView_.frame.size.height + point.y > self.scrollView_.contentSize.height ){
        if( self.scrollView_.frame.size.height > self.scrollView_.contentSize.height ){
            [self.scrollView_ setContentOffset:CGPointMake(0, 0) animated:YES];
        }else
            [self.scrollView_ setContentOffset:CGPointMake(0, self.scrollView_.contentSize.height - self.scrollView_.frame.size.height) animated:YES];
    }
    
}

@end
