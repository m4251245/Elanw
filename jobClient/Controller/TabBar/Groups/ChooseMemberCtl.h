//
//  ChooseMemberCtl.h
//  Association
//
//  Created by YL1001 on 14-5-30.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "GroupMemberCtl.h"
#import "GroupPermission_DataModal.h"

typedef  enum
{
    Publish_Type,
    Invite_Type,
    
}ChooseType;

@class ChooseMemberCtl;

@protocol ChooseMemberOKDelegate <NSObject>

-(void)chooseMember:(ChooseMemberCtl*)ctl memberArray:(NSMutableArray*)array type:(ChooseType)type;

@end

@interface ChooseMemberCtl : GroupMemberCtl
{
    NSMutableArray * inMemberArr_;
    NSMutableArray * myMemberArr_;
    
}

@property(nonatomic,weak) IBOutlet UIButton * allBtn_;
@property(nonatomic,weak) IBOutlet UIButton * okBtn_;
@property(nonatomic,assign) id<ChooseMemberOKDelegate> delegate_;
@property(nonatomic,assign) ChooseType         type_;
@property (nonatomic,strong) GroupPermission_DataModal *groupPermissionModel;

@end
