//
//  ConsultantToRecomResumeCtl.h
//  jobClient
//
//  Created by 一览ios on 15/6/9.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "ConditionItemCtl.h"
#import "PreCondictionListCtl.h"

@interface OfferToRecomResumeCtl : BaseListCtl<CondictionChooseDelegate,ConditionItemCtlDelegate>

@property (nonatomic, copy) NSString *jobfair_id;
@property (weak, nonatomic) IBOutlet UIButton *recomBtn;
@property (nonatomic, assign) BOOL recommendLineUpFlag;


@end
