//
//  CreateCourseOtherBtnCtl.m
//  jobClient
//
//  Created by YL1001 on 15/10/16.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "CreateCourseOtherBtnCtl.h"

@interface CreateCourseOtherBtnCtl ()

@end

@implementation CreateCourseOtherBtnCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    //    _maskView.layer.cornerRadius = 8;
    self.TimeView.layer.cornerRadius = 8.0f;
    self.TimeView.layer.masksToBounds = YES;
    
    [_maskView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskViewClick:)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)maskViewClick:(UIGestureRecognizer*)sender
{
    [_otherTimeTF resignFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
    [futureString  insertString:string atIndex:range.location];
    
//    NSInteger flag=0;
    
    NSInteger limited = 0;
    if ([_hourOrPrice isEqualToString:@"hours"]) {
       limited = 1;
    }
    else if ([_hourOrPrice isEqualToString:@"price"])
    {
        limited = 2;
    }
    
     
    
    NSRange rangeStr = [futureString rangeOfString:@"."];
    if (rangeStr.location != NSNotFound) {
        NSArray *arr = [futureString componentsSeparatedByString:@"."];
        NSInteger lastLength = futureString.length - rangeStr.location-rangeStr.length;
        if (lastLength > limited || arr.count > 2) {
            return NO;
        } 
        
    }
//    for (NSInteger i = futureString.length-1; i>=0; i--) {
//        
//        if ([futureString characterAtIndex:i] == '.') {
//            
//            if (flag > limited) {
//                return NO;
//            }
//            
//            break;
//        }
//        flag++;
//    }
    return YES;
}

#pragma mark - 重写键盘隐藏(解决contentSize不准)
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    if (keyboardRect.size.height < 226) {
        keyboardRect.size.height = 226;
    }
    if (ScreenHeight <= 480) {
        CGFloat height = ScreenHeight - keyboardRect.size.height -_TimeView.frame.size.height;
        [UIView animateWithDuration:animationDuration animations:^{
            [_TimeView setFrame:CGRectMake((ScreenWidth - 240)/2, height-10, _TimeView.frame.size.width, _TimeView.frame.size.height)];
        }];
    }
    
}


- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    if (ScreenHeight <= 480) {
        [UIView animateWithDuration:animationDuration animations:^{
            [_TimeView setFrame:CGRectMake((ScreenWidth - 240)/2, 200, _TimeView.frame.size.width, _TimeView.frame.size.height)];
        }];
    }
    
}
- (IBAction)btnClick:(id)sender
{
    if (sender == _confirmBtn) {
        if (_timeBlock) {
            if (_otherTimeTF.text && ![_otherTimeTF.text isEqualToString:@""]) {
                _timeBlock([_otherTimeTF.text doubleValue]);
            }else{
                _timeBlock(0);
            }
            
        }
    }else if (sender == _closeBtn){
        if (_timeBlock) {
            _timeBlock(0);
        }
    }

}


@end
