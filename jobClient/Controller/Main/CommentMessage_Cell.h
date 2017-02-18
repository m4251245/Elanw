//
//  CommentMessage_Cell.h
//  jobClient
//
//  Created by YL1001 on 14/10/28.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GroupInvite_DataModal;
@class MLEmojiLabel;

@interface CommentMessage_Cell : UITableViewCell

@property(nonatomic,weak) IBOutlet UIImageView  * userImg_;
@property(nonatomic,weak) IBOutlet UILabel      * nameLb_;
@property(nonatomic,weak) IBOutlet UILabel      * titleLb_;
@property(nonatomic,weak) IBOutlet UILabel      * contentLb_;
@property(nonatomic,weak) IBOutlet UILabel      * timeLb_;
@property(nonatomic,weak) IBOutlet UIImageView  * markNewImg_;
@property(nonatomic,weak) IBOutlet UIView       * contentView_;
@property (weak, nonatomic) IBOutlet UILabel *titlelableOne;
@property (weak, nonatomic) IBOutlet UILabel *contentLableOne;

@property (nonatomic,strong) GroupInvite_DataModal *dataModal;//社群新的评论消息
@property (nonatomic,strong) GroupInvite_DataModal *dataModalOne;//活动报名消息
@property (nonatomic,strong) GroupInvite_DataModal *dataModalTwo;//社群新的发表消息

@end
