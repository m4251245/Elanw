//
//  CreateGroupStep3Ctl.h
//  jobClient
//
//  Created by 一览iOS on 14-9-27.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"
#import "Groups_DataModal.h"
#import "GroupsInviteCtl.h"


typedef enum  {
    ENTER_FORMROOT = 0,//ROOT入口
    ENTER_FORMGROUPLIST,//社群列表入口
} CREATEENTERTYPE;

@interface CreateGroupStep3Ctl : BaseEditInfoCtl
{
    IBOutlet    UILabel    *tipsLb_;
    IBOutlet    UIButton   *inviBtn_;
    Groups_DataModal        *inModel_;
    GroupsInviteCtl       *groupsInviteCtl_;
}

@property(nonatomic,assign) int enteType_;

@end
