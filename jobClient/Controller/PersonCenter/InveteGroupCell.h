//
//  InveteGroupCell.h
//  jobClient
//
//  Created by 一览ios on 14-12-31.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Groups_DataModal.h"
#import "InviteGroupList.h"

@interface InveteGroupCell : UITableViewCell
{
    IBOutlet    UIImageView                 *_photoImgv;
    IBOutlet    UILabel                       *_groupNameLb;
    IBOutlet    UILabel                       *_groupMsgLb;
}

@property(nonatomic,weak)   IBOutlet    UIButton                     *inveteBtn;
- (void)initCellWithGroupData:(Groups_DataModal *)groupDataModel indexPath:(NSIndexPath *)indexPath inviteGroupList:(InviteGroupList *)ctl;

@end
