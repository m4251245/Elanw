//
//  FBPositionDescCtl.m
//  jobClient
//
//  Created by 一览ios on 15/10/19.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "FBPositionDescCtl.h"

@interface FBPositionDescCtl ()

@end

@implementation FBPositionDescCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        rightNavBarStr_ = @"确定";
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"详细描述";
    [self setNavTitle:@"详细描述"];
    
    [_textView setText:_inzwmodel.zptext];
    [_countLb setText:[NSString stringWithFormat:@"%lu/1000",(unsigned long)_inzwmodel.zptext.length]];
    // Do any additional setup after loading the view from its nib.
}



-(void)rightBarBtnResponse:(id)sender
{
    if (_textView.text.length > 1000) {
        [BaseUIViewController showAlertView:@"" msg:@"描述不能超过1000字" btnTitle:@"知道了"];
        return;
    }
    _inzwmodel.zptext = _textView.text;
    if (_block) {
        _block();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    if( !singleTapRecognizer_ )
        singleTapRecognizer_ = [MyCommon addTapGesture:self.scrollView_ target:self numberOfTap:1 sel:@selector(viewSingleTap:)];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [MyCommon removeTapGesture:self.scrollView_ ges:singleTapRecognizer_];
    singleTapRecognizer_ = nil;
}

-(void)textViewDidChange:(UITextView *)textView
{
    NSString *count = [NSString stringWithFormat:@"%lu",(unsigned long)textView.text.length];
    [_countLb setText:[NSString stringWithFormat:@"%@/1000",count]];
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
