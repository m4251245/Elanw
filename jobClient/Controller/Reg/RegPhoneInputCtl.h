//
//  RegPhoneInputCtl.h
//  jobClient
//
//  Created by 一览ios on 15/1/5.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"

@interface RegPhoneInputCtl : BaseEditInfoCtl

@property (weak, nonatomic) IBOutlet UILabel *titleLb;

@property (weak, nonatomic) IBOutlet UIButton *smsCodeBtn;

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@property (weak, nonatomic) IBOutlet UILabel *tipLb;

@property(nonatomic, copy) NSString *phone;

@property(nonatomic, assign)BOOL isThirdBanderPhoneNum;

- (IBAction)hasAccBtnClick:(id)sender;

@end
