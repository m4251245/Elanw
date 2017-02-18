//
//  InveteGroupCell.m
//  jobClient
//
//  Created by 一览ios on 14-12-31.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "InveteGroupCell.h"
#import "MyConfig.h"

@implementation InveteGroupCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)initCellWithGroupData:(Groups_DataModal *)groupDataModel indexPath:(NSIndexPath *)indexPath inviteGroupList:(InviteGroupList *)ctl{
    [_groupNameLb setFont:FOURTEENFONT_CONTENT];
    [_groupNameLb setTextColor:BLACKCOLOR];
    [_groupMsgLb setFont:TWEELVEFONT_COMMENT];
    [_groupMsgLb setTextColor:GRAYCOLOR];
    [_inveteBtn.titleLabel setFont:FOURTEENFONT_CONTENT];
    [_groupNameLb setText:groupDataModel.name_];
    [_photoImgv sd_setImageWithURL:[NSURL URLWithString:groupDataModel.pic_] placeholderImage:[UIImage imageNamed:@"icon_zhiysq.png"]];
    _inveteBtn.layer.cornerRadius = 2.0;
    _inveteBtn.layer.masksToBounds = YES;
    if (groupDataModel.invitePerm_ == YES) {
        [_inveteBtn setTitle:@"已邀请" forState:UIControlStateNormal];
        [_inveteBtn setBackgroundColor:[UIColor whiteColor]];
        [_inveteBtn setTitleColor:GRAYCOLOR forState:UIControlStateNormal];
        [_inveteBtn setUserInteractionEnabled:NO];
    }else{
        [_inveteBtn setTitle:@"邀请" forState:UIControlStateNormal];
        [_inveteBtn setBackgroundColor:[UIColor colorWithRed:149.0/255.0 green:0.0/255.0 blue:6.0/255.0 alpha:1.0]];
        [_inveteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_inveteBtn setUserInteractionEnabled:YES];
    }
    [_inveteBtn addTarget:ctl action:@selector(inveteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_inveteBtn setTag:indexPath.row +1000];
}

@end
