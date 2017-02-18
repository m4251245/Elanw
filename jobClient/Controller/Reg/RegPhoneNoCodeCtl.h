//
//  RegPhoneNoCodeCtl.h
//  jobClient
//
//  Created by 一览ios on 14/12/24.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"
@class ServiceCode_DataModal;

@interface RegPhoneNoCodeCtl : BaseEditInfoCtl

@property(nonatomic, copy) NSString *phone;

@property(nonatomic, strong) ServiceCode_DataModal *serviceCode;

@property (weak, nonatomic) IBOutlet UIButton *registBtn;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;

@end
