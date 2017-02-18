//
//  ConsultantLoadResumeCtl.h
//  jobClient
//
//  Created by 一览ios on 15/6/8.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"

@interface ConsultantLoadResumeCtl : ELBaseListCtl

@property (weak, nonatomic) UITextField *keyWorkTf;
@property (nonatomic, assign) NSInteger downloadFlag;
@property (nonatomic, copy) NSString *salerId;
@end
