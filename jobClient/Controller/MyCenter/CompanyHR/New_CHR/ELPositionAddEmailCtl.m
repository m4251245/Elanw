//
//  ELPositionAddEmailCtl.m
//  jobClient
//
//  Created by 一览ios on 16/11/16.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELPositionAddEmailCtl.h"

@interface ELPositionAddEmailCtl ()
{
    UIView *inputBgVview;
    NSArray *emailCount;
}
@end

@implementation ELPositionAddEmailCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"添加邮箱"];
    
}

- (void)configUI
{
    self.view.backgroundColor = UIColorFromRGB(0xf1f1f1);
    inputBgVview = [[UIView alloc] initWithFrame:CGRectMake(0, 14, ScreenWidth, 48*5)];
    inputBgVview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:inputBgVview];
    
    for (int i = 0; i<5; i++) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(16, 48*i, ScreenWidth-28, 48)];
        if (i == 0) {
            textField.placeholder = @"最多可填写5个邮箱";
        }
        textField.tag = 100+i;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        if (i < emailCount.count) {
            textField.text = [emailCount objectAtIndex:i];
        }
        
        [inputBgVview addSubview:textField];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 48*(i+1), ScreenWidth-15, 1)];
        lineView.backgroundColor = UIColorFromRGB(0xcdcdcd);
        [inputBgVview addSubview:lineView];
    }
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(20, inputBgVview.bottom+13, ScreenWidth-40, 48);
    confirmBtn.backgroundColor = UIColorFromRGB(0xf23f40);
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    confirmBtn.layer.cornerRadius = 10;
    [confirmBtn addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    _inzwmodel = dataModal;
    emailCount = [_inzwmodel.email componentsSeparatedByString:@";"];
    [self configUI];
}

- (void)btnResponse:(id)sender
{
    NSString *text1 = ((UITextField *)[inputBgVview viewWithTag:100]).text;
    NSString *text2 = ((UITextField *)[inputBgVview viewWithTag:101]).text;
    NSString *text3 = ((UITextField *)[inputBgVview viewWithTag:102]).text;
    NSString *text4 = ((UITextField *)[inputBgVview viewWithTag:103]).text;
    NSString *text5 = ((UITextField *)[inputBgVview viewWithTag:104]).text;
  
    _inzwmodel.email = @"";

    if (((UITextView *)[inputBgVview viewWithTag:100]).text.length > 0) {
       
        BOOL result = [MyCommon isValidateEmail:((UITextView *)[inputBgVview viewWithTag:100]).text];
        if (!result) {
            [BaseUIViewController showAutoDismissFailView:nil msg:@"请输入正确的邮箱" seconds:1.5f];
            return;
        }
        _inzwmodel.email = [_inzwmodel.email stringByAppendingFormat:@"%@",text1];
    }
    if (((UITextView *)[inputBgVview viewWithTag:101]).text.length > 0) {
        BOOL result = [MyCommon isValidateEmail:((UITextView *)[inputBgVview viewWithTag:101]).text];
        if (!result) {
            [BaseUIViewController showAutoDismissFailView:nil msg:@"请输入正确的邮箱" seconds:1.5f];
            return;
        }
        _inzwmodel.email = [_inzwmodel.email stringByAppendingFormat:@";%@",text2];
    }
    if (((UITextView *)[inputBgVview viewWithTag:102]).text.length > 0) {
        BOOL result = [MyCommon isValidateEmail:((UITextView *)[inputBgVview viewWithTag:102]).text];
        if (!result) {
            [BaseUIViewController showAutoDismissFailView:nil msg:@"请输入正确的邮箱" seconds:1.5f];
            return;
        }
        _inzwmodel.email = [_inzwmodel.email stringByAppendingFormat:@";%@",text3];
    }
    if (((UITextView *)[inputBgVview viewWithTag:103]).text.length > 0) {
        BOOL result = [MyCommon isValidateEmail:((UITextView *)[inputBgVview viewWithTag:103]).text];
        if (!result) {
            [BaseUIViewController showAutoDismissFailView:nil msg:@"请输入正确的邮箱" seconds:1.5f];
            return;
        }
        _inzwmodel.email = [_inzwmodel.email stringByAppendingFormat:@";%@",text4];
    }
    if (((UITextView *)[inputBgVview viewWithTag:104]).text.length > 0) {
        BOOL result = [MyCommon isValidateEmail:((UITextView *)[inputBgVview viewWithTag:104]).text];
        if (!result) {
            [BaseUIViewController showAutoDismissFailView:nil msg:@"请输入正确的邮箱" seconds:1.5f];
            return;
        }
       _inzwmodel.email = [_inzwmodel.email stringByAppendingFormat:@";%@",text5];
    }
    
    if ([_inzwmodel.email hasPrefix:@";"]) {
       _inzwmodel.email = [_inzwmodel.email substringFromIndex:1];
    }
    if (_inzwmodel.email.length <= 0) {
        [BaseUIViewController showAutoDismissFailView:nil msg:@"至少输入一个邮箱" seconds:3.f];
        return;
    }
    
    if (_block) {
        _block();
    }
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)keyboardWillHide:(NSNotification *)notification{
    [super keyboardWillHide:notification];
    CGRect frame = self.scrollView_.frame;
    frame.size.height = ScreenHeight;
    self.scrollView_.frame = frame;
}

-(void)keyboardWillShow:(NSNotification *)notification{
    [super keyboardWillShow:notification];
    CGRect frame = self.scrollView_.frame;
    frame.size.height = ScreenHeight-self.keyBoardHeight;
    self.scrollView_.frame = frame;
}

-(void)dismissKeyboard{
    [inputBgVview.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [inputBgVview.subviews[idx] resignFirstResponder];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
