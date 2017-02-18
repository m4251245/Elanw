//
//  GroupsDetailCtl.h
//  Association
//
//  Created by YL1001 on 14-5-9.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"
#import "ExRequetCon.h"
#import "Groups_DataModal.h"
#import "GroupsInviteCtl.h"
#import "GroupMemberCtl.h"
#import "GroupPermissionCtl.h"
#import "UPdateGroupTagsCtl.h"
#import "UpdateGroupIntroCtl.h"
#import "UpdateGroupPhotoCtl.h"
#import "ELGroupDetailModal.h"

@protocol QuitGroupDelegate <NSObject>

@optional
-(void)quitGroupSuccess;
- (void)updateGroupImgSuccess:(NSString *)img;

@end


@interface GroupsDetailCtl : BaseEditInfoCtl<UPdateGroupTagsCtlDelegate,UpdateGroupIntroCtlDelegate,UpdateGroupPhotoCtlDelegate>
{

    IBOutlet UILabel    * groupNumLb_;
    IBOutlet UILabel    * tagsLb_;
    IBOutlet UILabel    * introLb_;
    IBOutlet UILabel    * groupNumDescLb_;
    IBOutlet UILabel    * tagsDescLb_;
    IBOutlet UILabel    * introDescLb_;
    IBOutlet UIView     * detailView_;
    IBOutlet UILabel    * createrLb_;
    IBOutlet UIButton   * createrBtn_;
    IBOutlet UILabel   * createrDescLb_;
    IBOutlet UIView     * memberView_;
    IBOutlet UILabel    * memberCntLb_;
    IBOutlet UIButton   *tagsBtn_;
    IBOutlet UIButton   *introBtn_;
    IBOutlet UIButton   * permissionBtn_;
    IBOutlet UIButton   * inviteBtn_;
    
    IBOutlet UIView     *zbarView_;
    
    IBOutlet UIButton   *zbarBtn_;
    IBOutlet UIScrollView * myscrollView_;
    IBOutlet UIView     *permissionView_;
    IBOutlet UILabel    *permissionLb_;
    IBOutlet UIView     *tagsView_;
    IBOutlet UIView     *introView_;
    IBOutlet UIView     *introLineView_;
    IBOutlet UIImageView    *introJianTou_;
    IBOutlet UIImageView    *tagsJianTou_;
    IBOutlet UIView     *articleSetView_;
    IBOutlet UIButton   *articleSetBtn_;
    IBOutlet UILabel    *articleSetTitleLb_;
    IBOutlet UIImageView        *groupSetImgv_;
    IBOutlet UIImageView        *groupPicImgv_;
    IBOutlet UIButton           *groupPicBtn_;
    IBOutlet UILabel            *zbLb_;
    IBOutlet UILabel            *groupNameLb_;
    __weak IBOutlet UIImageView *groupNameArrow;
    NSMutableArray          *memberArr_;    //用于存储社群成员的数组
    NSMutableArray          *imageConArr_;  //用于加载群成员图片
    RequestCon              *createrCon_;  //获取群主信息的请求
    RequestCon              *permissionCon_;  //获取社群权限的请求
    RequestCon              *quitCon_;

    GroupsInviteCtl         *groupInviteCtl_;
    GroupMemberCtl          *groupMemberCtl_;
    GroupPermissionCtl      *groupPermissionCtl_;
    
    __weak IBOutlet UIButton *changeGroupNameBtn;

}

@property(nonatomic,assign) id<QuitGroupDelegate>  delegate_;
@property(nonatomic,assign) BOOL                   isQuitMember_;

@end
