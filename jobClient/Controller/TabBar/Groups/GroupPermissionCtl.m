//
//  GroupPermissionCtl.m
//  Association
//
//  Created by YL1001 on 14-5-12.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "GroupPermissionCtl.h"

@interface GroupPermissionCtl ()
{
    NSString *groupId;
}
@end

@implementation GroupPermissionCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        rightNavBarStr_ = @"保存";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = @"社群权限";
    [self setNavTitle:@"社群权限"];
    
    publishArr_ = [[NSArray alloc] init];
    inviteArr_ = [[NSArray alloc] init];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置右按扭的属性
- (void)setRightBarBtnAtt
{
    [rightBarBtn_ setTitle:@"保存" forState:UIControlStateNormal];
    rightBarBtn_.layer.cornerRadius = 2.0;
    [rightBarBtn_ setBackgroundColor:[UIColor clearColor]];
    [rightBarBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBarBtn_ setFrame:CGRectMake(0, 0, 55, 26)];
    [rightBarBtn_.titleLabel setFont:FIFTEENFONT_TITLE];
}

-(void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
    if (con == getPerCon_) {
        if (myModal_) {
            joinStatus_ = myModal_.joinStatus_;
            publishStatus_ = myModal_.publishStatus_;
            inviteStatus_ = myModal_.inviteStatus_;
            if (myModal_.joinStatus_ == 1) {
                requestJoinBtn_.selected = YES;
                allJoinBtn_.selected = NO;
                inviteJoinBtn_.selected = NO;
            }
            if (myModal_.joinStatus_ == 3) {
                requestJoinBtn_.selected = NO;
                allJoinBtn_.selected = NO;
                inviteJoinBtn_.selected = YES;
            }
            if (myModal_.joinStatus_ == 100) {
                requestJoinBtn_.selected = NO;
                allJoinBtn_.selected = YES;
                inviteJoinBtn_.selected = NO;
            }
            if (myModal_.publishStatus_ == 1 ) {
                mePublishBtn_.selected = YES;
                somePublishBtn_.selected = NO;
                allPublishBtn_.selected = NO;
            }
            if (myModal_.publishStatus_ == 3) {
                mePublishBtn_.selected = NO;
                somePublishBtn_.selected = YES;
                allPublishBtn_.selected = NO;
            }
            if (myModal_.publishStatus_ == 100) {
                mePublishBtn_.selected = NO;
                somePublishBtn_.selected = NO;
                allPublishBtn_.selected = YES;
            }
            if (myModal_.inviteStatus_ == 1) {
                meInviteBtn_.selected = YES;
                someInviteBtn_.selected = NO;
                allInviteBtn_.selected = NO;
            }
            if (myModal_.inviteStatus_ == 3) {
                meInviteBtn_.selected = NO;
                someInviteBtn_.selected = YES;
                allInviteBtn_.selected = NO;
            }
            if (myModal_.inviteStatus_ == 100) {
                meInviteBtn_.selected = NO;
                someInviteBtn_.selected = NO;
                allInviteBtn_.selected = YES;
            }
        }
    }
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    groupId = dataModal;
    someInviteBtn_.enabled = NO;
    somePublishBtn_.enabled = NO;
    if (!getPerCon_) {
        getPerCon_ = [self getNewRequestCon:NO];
    }
    [getPerCon_ getGroupPermission:groupId];
    
    //[super beginLoad:dataModal exParam:exParam];
}




-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GetGroupPermission:
        {
            myModal_ = [dataArr objectAtIndex:0];
            somePublishBtn_.enabled = YES;
            someInviteBtn_.enabled = YES;
        }
            break;
        case Request_SetGroupPermission:
        {
            Status_DataModal * dataModal = [dataArr objectAtIndex:0];
            if ([dataModal.status_ isEqualToString:Success_Status]) {
                [self.navigationController popViewControllerAnimated:YES];
                [BaseUIViewController showAutoDismissSucessView:@"保存成功" msg:nil];
            }
            else
            {
                [BaseUIViewController showAutoDismissFailView:@"保存失败" msg:@"请稍后再试"];
            }
        }
            break;
        default:
            break;
    }
}


-(void)btnResponse:(id)sender
{
    UIButton * btn = sender;
    btn.selected = YES;
    if (sender == allJoinBtn_ ) {
        inviteJoinBtn_.selected = NO;
        requestJoinBtn_.selected = NO;
        joinStatus_ = 100;
    }
    if (sender == inviteJoinBtn_) {
        allJoinBtn_.selected = NO;
        requestJoinBtn_.selected = NO;
        joinStatus_ = 3;
        
    }
    if (sender == requestJoinBtn_) {
        allJoinBtn_.selected = NO;
        inviteJoinBtn_.selected = NO;
        joinStatus_ = 1;
    }
    if (sender == mePublishBtn_) {
        allPublishBtn_.selected = NO;
        somePublishBtn_.selected = NO;
        publishStatus_ = 1;
    }
    if (sender == allPublishBtn_) {
        mePublishBtn_.selected = NO;
        somePublishBtn_.selected = NO;
        publishStatus_ = 100;
    }
    if (sender == somePublishBtn_) {
        allPublishBtn_.selected = NO;
        mePublishBtn_.selected = NO;
        publishStatus_ = 3;
        chooseMemberCtl_ = [[ChooseMemberCtl alloc] init];
    
        chooseMemberCtl_.type_ = Publish_Type;
        chooseMemberCtl_.delegate_ = self;
        [self.navigationController pushViewController:chooseMemberCtl_ animated:YES];
        [chooseMemberCtl_ beginLoad:groupId exParam:myModal_.publishArr_];
    }
    if (sender == meInviteBtn_) {
        allInviteBtn_.selected = NO;
        someInviteBtn_.selected = NO;
        inviteStatus_ = 1;
    }
    if (sender == allInviteBtn_) {
        meInviteBtn_.selected = NO;
        someInviteBtn_.selected = NO;
        inviteStatus_ = 100;
    }
    if (sender == someInviteBtn_) {
        allInviteBtn_.selected = NO;
        meInviteBtn_.selected = NO;
        inviteStatus_ = 3;
        
        chooseMemberCtl_ = [[ChooseMemberCtl alloc] init];
        chooseMemberCtl_.type_ = Invite_Type;
        chooseMemberCtl_.delegate_ = self;
        [self.navigationController pushViewController:chooseMemberCtl_ animated:YES];
        [chooseMemberCtl_ beginLoad:groupId exParam:myModal_.InviteArr_];
    }
    
}


-(void)rightBarBtnResponse:(id)sender
{
    if (joinStatus_ == myModal_.joinStatus_ && publishStatus_ == myModal_.publishStatus_ && inviteStatus_ == myModal_.inviteStatus_ &&[publishArr_ isEqualToArray:myModal_.publishArr_] && [inviteArr_ isEqualToArray:myModal_.InviteArr_]) {
        [self.navigationController popViewControllerAnimated:YES];
        [BaseUIViewController showAutoDismissSucessView:@"保存成功" msg:nil];
        
    }
    else
    {
        [self setGroupPermission];
    }
}

-(void)setGroupPermission
{
    if (!setPerCon_) {
        setPerCon_ = [self getNewRequestCon:NO];
    }
    [setPerCon_ setGroupPermission:groupId userId:[Manager getUserInfo].userId_ joinStatus:joinStatus_ publishStatus:publishStatus_ inviteStatus:inviteStatus_ publishArray:publishArr_ inviteArray:inviteArr_];
}

#pragma ChooseMemberDelegate
-(void)chooseMember:(ChooseMemberCtl *)ctl memberArray:(NSMutableArray *)array type:(ChooseType)type
{
    if (type == Publish_Type) {
        publishArr_ = array;
    }
    if (type == Invite_Type) {
        inviteArr_ = array;
    }
    
}

@end
