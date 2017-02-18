//
//  GroupPermissionCtl.h
//  Association
//
//  Created by YL1001 on 14-5-12.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "ExRequetCon.h"
#import "Groups_DataModal.h"
#import "GroupPermission_DataModal.h"
#import "ChooseMemberCtl.h"



@interface GroupPermissionCtl : BaseUIViewController<ChooseMemberOKDelegate>
{
    IBOutlet UIButton * allJoinBtn_;
    IBOutlet UIButton * inviteJoinBtn_;
    IBOutlet UIButton * requestJoinBtn_;
    
    IBOutlet UIButton * mePublishBtn_;
    IBOutlet UIButton * allPublishBtn_;
    IBOutlet UIButton * somePublishBtn_;
    
    IBOutlet UIButton * meInviteBtn_;
    IBOutlet UIButton * allInviteBtn_;
    IBOutlet UIButton * someInviteBtn_;
    
    GroupPermission_DataModal * myModal_;
    
    RequestCon        * getPerCon_;
    RequestCon        * setPerCon_;
    
    ChooseMemberCtl   * chooseMemberCtl_;
    
    NSArray           * publishArr_;
    NSArray           * inviteArr_;
    NSInteger                joinStatus_;
    NSInteger                publishStatus_;
    NSInteger                inviteStatus_;
}

@end
