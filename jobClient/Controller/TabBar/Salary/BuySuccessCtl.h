//
//  BuySuccessCtl.h
//  jobClient
//
//  Created by 一览ios on 15/3/30.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"

@interface BuySuccessCtl : BaseEditInfoCtl

@property(nonatomic, copy) NSString *orderId;

- (IBAction)showOrderBtnClick:(id)sender;

- (IBAction)showSalaryBtnClick:(id)sender;

@end
