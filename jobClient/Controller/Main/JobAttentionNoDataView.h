//
//  JobAttentionNoDataView.h
//  jobClient
//
//  Created by 一览ios on 14/12/2.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttendtionOrganizationCtl.h"

@interface JobAttentionNoDataView : UIView

@property (assign, nonatomic) OrganizationType type;

@property (weak, nonatomic) IBOutlet UILabel *attentionLb;

@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;

- (IBAction)attentionBtnClick:(id)sender;

@end
