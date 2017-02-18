//
//  ConsultantSearchCtl.h
//  jobClient
//
//  Created by 一览ios on 15/6/8.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "PreCondictionListCtl.h"
#import "ConditionItemCtl.h"
#import "ConsultantResumePreviewCtl.h"

@interface ConsultantSearchCtl : BaseListCtl<CondictionChooseDelegate,ConditionItemCtlDelegate,LoadResumeDelegate>
{
    BOOL        conFlag;
}
//@property (weak, nonatomic) IBOutlet UIButton *regionBtn;
//@property (weak, nonatomic) IBOutlet UIButton *tradeBtn;
//@property (weak, nonatomic) IBOutlet UIButton *gznumBtn;

@property (nonatomic, assign) NSInteger searchFlag;

@end
