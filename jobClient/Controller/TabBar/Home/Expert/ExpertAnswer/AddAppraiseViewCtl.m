//
//  AddAppraiseViewCtl.m
//  jobClient
//
//  Created by YL1001 on 15/8/13.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "AddAppraiseViewCtl.h"

@interface AddAppraiseViewCtl ()

@end

@implementation AddAppraiseViewCtl

@synthesize alertTipsView_;

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (IBAction)btnResopne:(UIButton *)sender
{
    [_btnDelegate btnResponeWitnIndex:sender.tag];
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [_btnDelegate setTextViewLayout];
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView;
{
    NSString *str = textView.text;
    if (str.length > 1 || ![str isEqualToString:@""]) {
        
        self.tipLb_.text = @"";
    }
    else
    {
        self.tipLb_.text = @"输入对行家回答的看法";
    }
}

- (void)showViewCtl
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.view];
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:self.view];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_btnDelegate hideView];
    [alertTipsView_ removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.isEdit = YES;
    self.bgView_.layer.cornerRadius = 8;
    
    self.commitBtn_.layer.cornerRadius = 5;
    
    self.textView_.layer.borderWidth = 1;
    self.textView_.layer.borderColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0].CGColor;
    self.textView_.delegate = self;
}

- (void)showTextOnly
{
//    [[[UIApplication sharedApplication] keyWindow] addSubview:alertTipsView_];
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    [window addSubview:alertTipsView_];
    
    alertTipsView_.frame = CGRectMake((ScreenWidth - alertTipsView_.frame.size.width)/2, CGRectGetMaxY(self.bgView_.frame)+20, 160, 20);
    alertTipsView_.alpha = 0.2;
    [UIView animateWithDuration:0.5 animations:^{
        alertTipsView_.alpha = 0.8;
    }];
    
    [self performSelector:@selector(hideTextOnly) withObject:self afterDelay:3.0];
}

- (void)hideTextOnly
{
    [UIView animateWithDuration:0.5 animations:^{
        alertTipsView_.alpha = 0.2;
    }];
    [alertTipsView_ removeFromSuperview];
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
