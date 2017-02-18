//
//  GroupsMessage_Cell.h
//  jobClient
//
//  Created by YL1001 on 14/10/30.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GroupInvite_DataModal;
@interface GroupsMessage_Cell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView  * userImg_;
@property (nonatomic, weak) IBOutlet UIImageView  * markNewImg_;
@property (nonatomic, weak) IBOutlet UIImageView  * expertImg_;
@property (nonatomic, weak) IBOutlet UILabel      * nameLb_;
@property (nonatomic, weak) IBOutlet UILabel      * statusLb_;
@property (nonatomic, weak) IBOutlet UIButton     * myBtn_;
@property (nonatomic, weak) IBOutlet UILabel      * groupsNameLb_;
@property (nonatomic, weak) IBOutlet UILabel      * timeLb_;
@property (nonatomic, weak) IBOutlet UIView       * bgView_;
@property (nonatomic, weak) IBOutlet UIButton     * userBtn_;
@property (nonatomic, weak) IBOutlet UILabel      * reasonLb;
@property (nonatomic, strong) GroupInvite_DataModal *dataModel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLeftToUimg;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *timeLbTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bgViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *reasonLbHeight;

@end
