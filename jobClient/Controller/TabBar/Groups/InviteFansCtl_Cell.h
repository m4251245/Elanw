//
//  InviteFansCtl_Cell.h
//  Association
//
//  Created by YL1001 on 14-5-12.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Expert_DataModal.h"
#import "ELSameTradePeopleFrameModel.h"

@interface InviteFansCtl_Cell : UITableViewCell

@property(nonatomic,weak) IBOutlet  UILabel  * nameLb_;
@property(nonatomic,weak) IBOutlet  UILabel  * tradeLb_;
@property(nonatomic,weak) IBOutlet  UIImageView  * imgView_;

@property (weak, nonatomic) IBOutlet UIImageView *imageInvite;

@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftWidth;

-(void)giveDataWithModal:(ELSameTradePeopleFrameModel *)dataModal;

@end
