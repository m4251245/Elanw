//
//  ELCreatChangeCtl.h
//  jobClient
//
//  Created by 一览iOS on 16/8/6.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "ELGroupChangeTypeModel.h"
#import "GroupPermission_DataModal.h"

#define kJoinTypeName @"加群验证"
#define kPublishTypeName @"话题发表"
#define kInviteTypeName @"成员邀请"
#define kCanSeeTypeName @"谁可浏览"
#define kJoinTypeAll @"允许所有人加入"
#define kJoinTypeApply @"申请加入"
#define kJoinTypeInvite @"受邀加入（私密）" 
#define kPublishTypeOwn @"仅自己发表"
#define kPublishTypeSpecific @"授权本群特定成员可发表"
#define kPublishTypeAll @"所有成员可发表"  
#define kInviteTypeOwn @"仅自己可邀请"
#define kInviteTypeSpecific @"授权本群特定成员可邀请"
#define kInviteTypeAll @"所有成员可邀请" 
#define kCanSeeTypeAll @"所有人可已浏览"
#define kCanSeeTypeLogin @"登录即可浏览"
#define kCanSeeTypeGroup @"仅成员可浏览"

typedef enum
{
    JoinType=1,
    PublishArticleType,
    InviteType,
    CanSeeType,
    AllType
}ChangeDataType;

@protocol ChangeTypeDelegate <NSObject>

-(void)selectTypeWithName:(ELGroupChangeTypeModel *)dataModel;

@end

@interface ELCreatChangeCtl : BaseListCtl

@property (nonatomic,strong) ELGroupChangeTypeModel *selectModel; //选中的卡片
@property (nonatomic,weak) id<ChangeTypeDelegate> typeDeleagte; //修改社群权限成功的代理
@property (nonatomic,assign) ChangeDataType dataType; //社群权限类型
@property (nonatomic,copy) NSString *groupId; //社群Id
@property (nonatomic,strong) GroupPermission_DataModal *groupPermissionModel;//社群权限数据
@property (nonatomic,assign) BOOL isFromGroup;

@end
