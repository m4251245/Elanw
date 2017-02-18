//
//  InviteFansCtl_Cell.m
//  Association
//
//  Created by YL1001 on 14-5-12.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "InviteFansCtl_Cell.h"

@implementation InviteFansCtl_Cell

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)giveDataWithModal:(ELSameTradePeopleFrameModel *)dataModal
{
    self.imageInvite.layer.borderColor = [UIColor colorWithRed:231/255.0 green:234/255.0 blue:241/255.0 alpha:1.0].CGColor;
    
    self.tradeLb_.text = [NSString stringWithFormat:@"职位:%@",dataModal.peopleModel.person_zw];
    
    
    [self.imgView_ sd_setImageWithURL:[NSURL URLWithString:dataModal.peopleModel.person_pic] placeholderImage:nil];
    
    if (dataModal.isHaveInvite == YES) {
        self.imageInvite.layer.borderColor = [UIColor clearColor].CGColor;
        self.imageInvite.image = [UIImage imageNamed:@"redduihao.png"];
    }
    else
    {
        self.imageInvite.image = [UIImage imageNamed:@""];
    }
    if ([dataModal.peopleModel.is_group_member isEqualToString:@"1"]) {
        self.imageInvite.layer.borderColor = [UIColor clearColor].CGColor;
        self.imageInvite.image = [UIImage imageNamed:@"duihao.png"];
    }
}

@end
