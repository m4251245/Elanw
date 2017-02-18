//
//  ConsultantAddVisitCtl.m
//  jobClient
//
//  Created by 一览ios on 15/6/23.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ConsultantAddVisitCtl.h"
#import "ExRequetCon.h"

@interface ConsultantAddVisitCtl ()
{
    User_DataModal *inModel;
    RequestCon *commitCon;
}

@end

@implementation ConsultantAddVisitCtl

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"回访记录";
    [self setNavTitle:@"回访记录"];
    _commitBtn.layer.cornerRadius = 4.0;
    _commitBtn.layer.masksToBounds = YES;
    _contentTextView.returnKeyType = UIReturnKeyDone;
    // Do any additional setup after loading the view from its nib.
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    inModel = dataModal;
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        _tipsLb.text = @"请填写回访记录，该回访记录会自动同步到OA系统";
    }else{
        _tipsLb.text = @"";
    }
}

- (void)btnResponse:(id)sender
{
    if (sender == _commitBtn) {
        if([[MyCommon removeAllSpace:_contentTextView.text] isEqualToString:@""]) {
            [BaseUIViewController showAlertView:@"" msg:@"请填写回访内容" btnTitle:@"知道了"];
        }else{
            if (!commitCon) {
                commitCon = [self getNewRequestCon:NO];
            }
//            [commitCon addVisit:[Manager getHrInfo].salerId personid:inModel.userId_ content:_contentTextView.text type:@"0"];
            [commitCon addVisit:[Manager getHrInfo].salerId recodeId:nil personid:inModel.userId_ content:_contentTextView.text type:@"0"];
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        [_contentTextView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case request_addVisit:
        {
            Status_DataModal *model = dataArr[0];
            if ([model.status_ isEqualToString:@"OK"]) {
                if ([_delegate respondsToSelector:@selector(addSuccess)]) {
                    [_delegate addSuccess];
                }
                [BaseUIViewController showAutoDismissSucessView:@"" msg:@"提交成功" seconds:1.0];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [BaseUIViewController showAutoDismissSucessView:@"" msg:model.des_ seconds:1.0];
            }
        }
            break;
        default:
            break;
    }
}

#pragma Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    if( !singleTapRecognizer_ )
    {
        singleTapRecognizer_ = [MyCommon addTapGesture:self.scrollView_ target:self numberOfTap:1 sel:@selector(viewSingleTap:)];
    }
    [self showKeyBoardButtonWithBool:YES];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [MyCommon removeTapGesture:self.scrollView_ ges:singleTapRecognizer_];
    singleTapRecognizer_ = nil;
    [self showKeyBoardButtonWithBool:NO];
}

-(void)getDataFunction:(RequestCon *)con
{

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
