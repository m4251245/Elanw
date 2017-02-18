//
//  CreateGroupStep3Ctl.m
//  jobClient
//
//  Created by 一览iOS on 14-9-27.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "CreateGroupStep3Ctl.h"

@interface CreateGroupStep3Ctl ()

@end

@implementation CreateGroupStep3Ctl
@synthesize enteType_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = @"创建社群";
    [self setNavTitle:@"创建社群"];
    [tipsLb_ setTextColor:BLACKCOLOR];
    [tipsLb_ setFont:FIFTEENFONT_TITLE];
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    inModel_= dataModal;
}

- (void)btnResponse:(id)sender
{
    if (sender == inviBtn_) {
        if (!groupsInviteCtl_) {
            groupsInviteCtl_ = [[GroupsInviteCtl alloc] init];
        }
        groupsInviteCtl_.fromCreatGroup = YES;
        [self.navigationController pushViewController:groupsInviteCtl_ animated:YES];
        [groupsInviteCtl_ beginLoad:inModal_ exParam:nil];
    }
}

- (void)rightBarBtnResponse:(id)sender
{
//    if (![Manager shareMgr].groupsCtl_) {
//        [Manager shareMgr].groupsCtl_ = [[GroupsCtl alloc] init];
//    }
//    [self.navigationController pushViewController:[Manager shareMgr].groupsCtl_ animated:YES];
//    [Manager shareMgr].groupsCtl_.type_ = @"4";
//    [[Manager shareMgr].groupsCtl_ beginLoad:nil exParam:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)backBarBtnResponse:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHPERSONCENTER" object:nil];
    if ([Manager shareMgr].creatGroupStartIndex > 0)
    {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[Manager shareMgr].creatGroupStartIndex-1]animated:YES];
    }
    else
    {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }
//    //入口是哪里就返回哪里
//    if (enteType_ == ENTER_FORMROOT) {
//        //返回到社群列表
//        [Manager shareMgr].groupsCtl_.type_ = @"4";
//        [[Manager shareMgr]tabViewModalChanged:[Manager shareMgr].tabView_ type:Tab_Second];
//        //求职
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"CREATEGROUPSUCCESS" object:nil];
//    }else if(enteType_ == ENTER_FORMGROUPLIST){
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"CREATEGROUPSUCCESS" object:nil];
//        //刷新个人中心社群
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHPERSONCENTER" object:nil];
//        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
//    }
    
}

@end
