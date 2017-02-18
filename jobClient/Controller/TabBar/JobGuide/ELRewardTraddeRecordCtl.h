//
//  ELRewardTraddeRecordCtl.h
//  jobClient
//
//  Created by YL1001 on 15/8/31.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"

@interface ELRewardTraddeRecordCtl : BaseListCtl
{
    
    IBOutlet UIView *headerView;
    IBOutlet UILabel *totalLb;
    IBOutlet UILabel *moneyTotallb;
    
    IBOutlet UIView *typeView;
    IBOutlet UIButton *allTypeBtn;
    IBOutlet UIButton *rewardBtn;
    IBOutlet UIButton *interviewBtn;
    IBOutlet UIButton *withdrawBtn;
    
    IBOutlet UIButton *moreBtn;
}
@end
