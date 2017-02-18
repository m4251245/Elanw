//
//  UpdateGroupIntroCtl.m
//  jobClient
//
//  Created by 一览iOS on 14-10-16.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "UpdateGroupIntroCtl.h"

@interface UpdateGroupIntroCtl ()

@end

@implementation UpdateGroupIntroCtl
@synthesize delegate_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        rightNavBarStr_ = @"完成";
    }
    return self;
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    inModel_ = dataModal;
}


-(void)textViewDidChange:(UITextView *)textView
{
    if ([[MyCommon removeSpaceAtSides:textView.text]isEqualToString:@""]) {
        [tipsLb setHidden:NO];
    }else{
        [tipsLb setHidden:YES];
    }
}

//设置右按扭的属性
- (void)setRightBarBtnAtt
{
    [rightBarBtn_ setTitle:@"完成" forState:UIControlStateNormal];
    [rightBarBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBarBtn_ setFrame:CGRectMake(0, 0, 55, 26)];
    [rightBarBtn_.titleLabel setFont:FIFTEENFONT_TITLE];
}

- (void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
    
    if ([inModel_.group_intro isEqualToString:@""])
    {
        [tipsLb setHidden:NO];
    }
    else
    {
        [groupIntroView setText:inModel_.group_intro];
        [tipsLb setHidden:YES];
    }
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon_ code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_UpdateGroups:
        {
            if ([[dataArr objectAtIndex:0] isEqualToString:@"OK"]) {
                [BaseUIViewController showAutoDismissSucessView:@"修改成功" msg:nil seconds:0.5];
                inModel_.group_intro = [MyCommon removeSpaceAtSides:groupIntroView.text];
                [delegate_ updateGroupIntroSuccess];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [BaseUIViewController showAutoDismissFailView:@"修改失败" msg:nil seconds:0.5];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)rightBarBtnResponse:(id)sender
{
    
    if ([[MyCommon removeSpaceAtSides:groupIntroView.text] isEqualToString:@""]) {
        [BaseUIViewController showAlertView:@"请输入社群简介" msg:nil btnTitle:@"知道了"];
        return;
    }
    
    NSString *str = [MyCommon utf8ToUnicode:groupIntroView.text];
    if (!updateCon_){
        updateCon_ = [self getNewRequestCon:NO];
    }
    [updateCon_ updateGroups:[Manager getUserInfo].userId_ groupId:inModel_.group_id groupName:inModel_.group_name groupIntro:[MyCommon removeSpaceAtSides:str] groupTag:inModel_.group_tag_names openStatus:inModel_.group_open_status groupPic:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"简介修改"];
    
    // Do any additional setup after loading the view from its nib.
    [groupIntroView setTextColor:BLACKCOLOR];
    [groupIntroView setFont:FIFTEENFONT_TITLE];
    [gourpIntroLb_ setFont:FIFTEENFONT_TITLE];
    [gourpIntroLb_ setTextColor:BLACKCOLOR];
    
    gourpIntroView_.layer.cornerRadius = 4.0;
    gourpIntroView_.layer.masksToBounds = YES;
    gourpIntroView_.layer.borderWidth = 1.0;
    gourpIntroView_.layer.borderColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
