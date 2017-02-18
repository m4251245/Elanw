//
//  JionGroupReasonCtl.m
//  jobClient
//
//  Created by 一览iOS on 14-12-10.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "JionGroupReasonCtl.h"

@interface JionGroupReasonCtl ()
{
    NSString *groupId;
}
@end

@implementation JionGroupReasonCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      rightNavBarStr_ = @"提交";  
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"申请加入";
    [self setNavTitle:@"申请加入"];
    
    [reasonTextView_ setFont:FOURTEENFONT_CONTENT];
    [reasonTextView_ setTextColor:BLACKCOLOR];
    [tipsLb_ setFont:FOURTEENFONT_CONTENT];
    [tipsLb_ setTextColor:GRAYCOLOR];
    reasonTextView_.layer.borderColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0].CGColor;
    reasonTextView_.layer.borderWidth = 0.5;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [reasonTextView_ becomeFirstResponder];
    [self setFd_prefersNavigationBarHidden:NO];
//    self.navigationItem.title = @"申请加入";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [reasonTextView_ resignFirstResponder];
}

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
    if ([dataModal isKindOfClass:[Groups_DataModal class]]) {
        Groups_DataModal *modal = dataModal;
        groupId = modal.id_;
    }else{
        groupId = dataModal; 
    }
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon_ code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_JoinGroup:
        {
            Status_DataModal * dataModal = [dataArr objectAtIndex:0];
            if ([dataModal.status_ isEqualToString:Success_Status]) {
                if ([dataModal.code_ isEqualToString:@"200"]) {
                    //审核中
                    [BaseUIViewController showAutoDismissSucessView:@"申请成功,等待审核" msg:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                    [_delegate joinGroupSuccess];
                }
            }
            else
            {
                [BaseUIViewController showAutoDismissFailView:dataModal.des_ msg:@"请稍后再试"];
            }
        }
            break;
        default:
            break;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([[MyCommon removeSpaceAtSides:textView.text] isEqualToString:@""]) {
        [tipsLb_ setHidden:NO];
    }else{
        [tipsLb_ setHidden:YES];
    }
}

- (void)rightBarBtnResponse:(id)sender
{
    if (!joinCon_) {
        joinCon_ = [self getNewRequestCon:NO];
    }
    [joinCon_ joinGroup:[Manager getUserInfo].userId_ group:groupId content:[MyCommon removeSpaceAtSides:reasonTextView_.text]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
