//
//  SafeVarifyCtl.h
//  jobClient
//
//  Created by 一览ios on 15/12/21.
//  Copyright © 2015年 YL1001. All rights reserved.
//

@class RegCustomTextField;

#import "BaseEditInfoCtl.h"
#import "BindCtl.h"

@interface SafeVarifyCtl : BaseEditInfoCtl

@property (nonatomic, assign) VarifyType varifyType;

@property (weak, nonatomic) IBOutlet UILabel *oldEmailOrPhoneLb;

@property (weak, nonatomic) IBOutlet RegCustomTextField *oldEmailOrPhoneTF;
@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;

@property(nonatomic, copy) NSString *phone;
@property(nonatomic, copy) NSString *email;

@end
