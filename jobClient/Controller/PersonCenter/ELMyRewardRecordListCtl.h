//
//  ELMyRewardRecordListCtl.h
//  jobClient
//
//  Created by YL1001 on 15/11/9.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"

@interface ELMyRewardRecordListCtl : BaseListCtl
{
    
    IBOutlet UIImageView *userImg;
    IBOutlet UILabel *rewardCountLb;
    IBOutlet UIButton *rewardBtn;
    IBOutlet UIButton *backBtn;
}

@property (nonatomic, strong) NSString *personId;
@property (nonatomic, strong) NSString *personImg;
@property (nonatomic, strong) NSString *personName;

@property (nonatomic,assign) BOOL isPop;

@end
